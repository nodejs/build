#!/bin/bash
#
# Report CI health of every repository in a GitHub organisation, on its
# default branch.
#
# The checks are deliberately strict: a repository is only reported green when
# we could actually verify that it is green.  Anything unverifiable -- an API
# error, a truncated response, an unknown check conclusion, a commit that no
# workflow ever ran on -- is reported as such instead of being rounded up to a
# pass.
#
#   ORG=nodejs ./ci-status-org-wide.sh
#
# Environment:
#   ORG                organisation to scan               (default: nodejs)
#   INCLUDE_ARCHIVED   also scan archived repositories    (default: 0)
#   INCLUDE_FORKS      also scan forks                    (default: 0)
#   CANCELLED_IS_FAIL  count cancelled checks as failures (default: 0)
#   INCLUDE_DYNAMIC_RUNS  count Dependabot "dynamic/" runs   (default: 0)
#   JOBS               repositories checked in parallel   (default: 8)
#   REPO_LIMIT         max repositories to list           (default: 1000)
#
# Exit status is 0 only when every scanned repository was verified green.

set -o pipefail

ORG="${ORG:-nodejs}"
INCLUDE_ARCHIVED="${INCLUDE_ARCHIVED:-0}"
INCLUDE_FORKS="${INCLUDE_FORKS:-0}"
CANCELLED_IS_FAIL="${CANCELLED_IS_FAIL:-0}"
INCLUDE_DYNAMIC_RUNS="${INCLUDE_DYNAMIC_RUNS:-0}"
JOBS="${JOBS:-8}"
REPO_LIMIT="${REPO_LIMIT:-1000}"

# Absolute path to self, so the xargs workers can re-enter this script
# regardless of the caller's working directory.
SELF=$(cd "$(dirname "$0")" && pwd)/$(basename "$0")

# Conclusions that mean the check genuinely failed.  "cancelled" is handled
# separately because it usually means "superseded", not "broken".
FAIL_CONCLUSIONS='"failure","timed_out","startup_failure","action_required","stale"'
PASS_CONCLUSIONS='"success","neutral","skipped"'

# Colors (disabled when not writing to a terminal)
if [ -t 1 ]; then
    BOLD=$'\033[1m'; DIM=$'\033[2m'; RESET=$'\033[0m'
    GREEN=$'\033[32m'; RED=$'\033[31m'; YELLOW=$'\033[33m'; CYAN=$'\033[36m'
else
    BOLD=""; DIM=""; RESET=""; GREEN=""; RED=""; YELLOW=""; CYAN=""
fi

# ---------------------------------------------------------------------------
# API helper
# ---------------------------------------------------------------------------

# gh_api <path> [extra gh args...]
#
# Prints the response body and returns 0 only when the request really
# succeeded, 2 when the endpoint answered 404, 1 for anything else.  gh writes the error body to stdout on a 4xx/5xx, so a plain
# `gh api ... 2>/dev/null` leaves jq looking at an error object and reading it
# as "zero checks, therefore fine" -- which is how unverifiable repositories
# used to be reported green.  Transient failures are retried.
gh_api() {
    local path="$1"; shift
    local attempt out rc

    for attempt in 1 2 3; do
        out=$(gh api "$path" "$@" 2>/dev/null)
        rc=$?

        if [ $rc -eq 0 ] && [ -n "$out" ] && jq -e . >/dev/null 2>&1 <<< "$out"; then
            # An error object gh happened to exit 0 on is still an error.
            if jq -e '(if type == "array" then (.[0] // {}) else . end)
                       | type == "object" and has("message") and has("documentation_url")' \
                    >/dev/null 2>&1 <<< "$out"; then
                printf '%s' "$out"
                api_is_404 "$out" && return 2
                return 1
            fi
            printf '%s' "$out"
            return 0
        fi

        # 4xx will not fix itself; only back off for empty or 5xx responses.
        case "$out" in
            *'"status": "4'*|*'"status":"4'*) break ;;
        esac
        sleep $(( attempt * 2 ))
    done

    printf '%s' "$out"
    api_is_404 "$out" && return 2
    return 1
}

# A 404 on an /actions/ endpoint means Actions is switched off for the
# repository, not that the repository is unverifiable.
api_is_404() {
    case "$1" in
        *'"status": "404"'*|*'"status":"404"'*|*'Not Found'*) return 0 ;;
    esac
    return 1
}

# Condense an error body into one line of explanation.
api_error() {
    local msg
    msg=$(jq -r '(if type == "array" then (.[0] // {}) else . end) | .message? // empty' \
              2>/dev/null <<< "$1" | head -1)
    printf '%s' "${msg:-unreachable}"
}

# ---------------------------------------------------------------------------
# Per-repository check.  Emits a single "<state>\t<label>\t<detail>" line.
# ---------------------------------------------------------------------------

check_repo() {
    local repo="$1" branch="$2"
    local body sha link="https://github.com/$ORG/$repo"

    if [ -z "$branch" ]; then
        printf 'empty\tempty\tno default branch | %s\n' "$link"
        return
    fi

    # ---- head commit ------------------------------------------------------
    # Resolve the head SHA once and pin every later request to it, so a push
    # landing mid-scan cannot mix checks from two different commits.
    if ! body=$(gh_api "repos/$ORG/$repo/commits/$branch"); then
        printf 'error\tapi-error\t%s | %s\n' "$(api_error "$body")" "$link"
        return
    fi
    sha=$(jq -r '.sha // empty' <<< "$body")
    if [ -z "$sha" ]; then
        printf 'error\tapi-error\tno head commit | %s\n' "$link"
        return
    fi

    # ---- workflow runs pinned to this commit ------------------------------
    # Fetched before the check runs because it also tells us which runs are
    # Dependabot's "dynamic/" security updates.  Those attach check runs to the
    # head commit but are not the project's CI, and a failing one used to make
    # a perfectly green repository look broken.
    local runs_raw runs foreign rc actions_off=0
    runs_raw=$(gh_api "repos/$ORG/$repo/actions/runs?head_sha=$sha&per_page=100&exclude_pull_requests=true")
    rc=$?
    if [ $rc -eq 2 ]; then
        runs_raw='{"workflow_runs":[]}'
        actions_off=1
    elif [ $rc -ne 0 ]; then
        printf 'error\tapi-error\tactions/runs: %s | %s\n' "$(api_error "$runs_raw")" "$link"
        return
    fi
    if [ "$INCLUDE_DYNAMIC_RUNS" = "1" ]; then
        foreign='[]'
    else
        foreign=$(jq -c '[ .workflow_runs[]?
                           | select((.path // "") | startswith(".github/workflows/") | not)
                           | .id | tostring ]' <<< "$runs_raw")
    fi
    [ -n "$foreign" ] || foreign='[]'

    runs=$(jq -c --argjson dyn "$INCLUDE_DYNAMIC_RUNS" "
        [ .workflow_runs[]?
          | select(\$dyn == 1 or ((.path // \"\") | startswith(\".github/workflows/\"))) ]
        | group_by(.workflow_id)
        | map(max_by(.run_number // 0))
        | (map(select(.status == \"completed\"))) as \$done
        | {
            total: length,
            fail:      [ \$done[] | select((.conclusion // \"\") | IN($FAIL_CONCLUSIONS)) | .name ],
            cancelled: [ \$done[] | select((.conclusion // \"\") == \"cancelled\") | .name ],
            pending:   [ .[]      | select(.status != \"completed\") | .name ],
          }" <<< "$runs_raw")

    # ---- check runs -------------------------------------------------------
    local checks_raw checks checks_404=0
    checks_raw=$(gh_api "repos/$ORG/$repo/commits/$sha/check-runs?per_page=1000" \
                        --paginate --slurp)
    rc=$?
    if [ $rc -eq 2 ]; then
        checks_raw='[{"total_count":0,"check_runs":[]}]'
        checks_404=1
    elif [ $rc -ne 0 ]; then
        printf 'error\tapi-error\tcheck-runs: %s | %s\n' "$(api_error "$checks_raw")" "$link"
        return
    fi

    # Confirm we received as many runs as the API claimed exist, then keep only
    # the newest run per (app, check name) so a re-run supersedes the attempt
    # it replaced instead of both being counted.
    checks=$(jq -c --argjson foreign "$foreign" "
        (.[0].total_count // 0) as \$expected
        | [ .[].check_runs[]? ] as \$raw
        | [ \$raw[]
            | ((.html_url // \"\") | [ scan(\"/actions/runs/([0-9]+)\") ] | flatten | first) as \$rid
            | select(\$rid == null or (\$foreign | index(\$rid)) == null) ] as \$all
        | (\$all
           | group_by([(.app.id // 0), .name])
           | map(max_by([(.started_at // \"\"), (.id // 0)]))) as \$latest
        | (\$latest | map(select(.status == \"completed\"))) as \$done
        | {
            expected: \$expected,
            received: (\$raw | length),
            truncated: ((\$raw | length) < \$expected),
            total: (\$latest | length),
            fail:      [ \$done[]  | select((.conclusion // \"\") | IN($FAIL_CONCLUSIONS)) | .name ],
            cancelled: [ \$done[]  | select((.conclusion // \"\") == \"cancelled\") | .name ],
            unknown:   [ \$done[]  | select((.conclusion // \"\") | IN($PASS_CONCLUSIONS, $FAIL_CONCLUSIONS, \"cancelled\") | not)
                                   | \"\\(.name)=\\(.conclusion // \"null\")\" ],
            pending:   [ \$latest[] | select(.status != \"completed\") | .name ],
          }" <<< "$checks_raw")

    if [ -z "$checks" ]; then
        printf 'error\tparse-error\tunparseable check-runs response | %s\n' "$link"
        return
    fi

    if [ "$(jq -r '.truncated' <<< "$checks")" = "true" ]; then
        printf 'error\ttruncated\tgot %s of %s check runs | %s\n' \
            "$(jq -r '.received' <<< "$checks")" "$(jq -r '.expected' <<< "$checks")" "$link"
        return
    fi

    # An unrecognised conclusion means GitHub grew a state this script does not
    # model.  Say so rather than guessing "green".
    local unknown
    unknown=$(jq -r '.unknown | join(", ")' <<< "$checks")
    if [ -n "$unknown" ]; then
        printf 'error\tunknown\tunhandled conclusion: %s | %s\n' "$unknown" "$link"
        return
    fi

    # ---- legacy commit statuses -------------------------------------------
    local status_raw statuses
    status_raw=$(gh_api "repos/$ORG/$repo/commits/$sha/status?per_page=100")
    rc=$?
    if [ $rc -eq 2 ]; then
        status_raw='{"statuses":[]}'
        checks_404=1
    elif [ $rc -ne 0 ]; then
        printf 'error\tapi-error\tstatus: %s | %s\n' "$(api_error "$status_raw")" "$link"
        return
    fi
    statuses=$(jq -c '
        (.statuses // [])
        | group_by(.context)
        | map(max_by(.updated_at // ""))
        | {
            total: length,
            fail:    [ .[] | select(.state == "failure" or .state == "error") | .context ],
            pending: [ .[] | select(.state == "pending") | .context ],
          }' <<< "$status_raw")

    # ---- verdict ----------------------------------------------------------
    # Merge the three sources into one deduplicated view; the same job often
    # shows up as both a check run and a commit status.
    local verdict
    verdict=$(jq -cn --argjson c "$checks" --argjson s "$statuses" --argjson w "$runs" \
                     --argjson cancel_fail "$CANCELLED_IS_FAIL" '
        (($c.cancelled + $w.cancelled) | unique) as $cancelled
        | ((($c.fail + $s.fail + $w.fail) | unique)
           + (if $cancel_fail == 1 then $cancelled else [] end) | unique) as $fail
        | (($c.pending + $s.pending + $w.pending) | unique) as $pending
        | {
            fail: $fail,
            cancelled: (if $cancel_fail == 1 then [] else $cancelled end),
            pending: $pending,
            evidence: ($c.total + $s.total + $w.total),
          }')

    local n_fail n_pending n_cancelled evidence names
    n_fail=$(jq -r '.fail | length' <<< "$verdict")
    n_pending=$(jq -r '.pending | length' <<< "$verdict")
    n_cancelled=$(jq -r '.cancelled | length' <<< "$verdict")
    evidence=$(jq -r '.evidence' <<< "$verdict")

    if [ "$n_fail" -gt 0 ]; then
        names=$(jq -r '.fail[:4] | join(", ")' <<< "$verdict")
        printf 'failure\tfailure\t%d failing (%s%s) | %s\n' \
            "$n_fail" "$names" "$([ "$n_fail" -gt 4 ] && printf ', …')" "$link"
        return
    fi

    if [ "$n_pending" -gt 0 ]; then
        printf 'pending\tpending\t%d still running | %s\n' "$n_pending" "$link"
        return
    fi

    # Nothing failed outright, but nothing conclusively passed either.
    if [ "$n_cancelled" -gt 0 ]; then
        names=$(jq -r '.cancelled[:3] | join(", ")' <<< "$verdict")
        printf 'cancelled\tcancelled\t%d cancelled, no failure (%s) | %s\n' \
            "$n_cancelled" "$names" "$link"
        return
    fi

    if [ "$evidence" -eq 0 ]; then
        # No evidence at all.  If the repository has active workflows then CI
        # was expected to run on this commit and did not, which is not a pass.
        local wf_active=0
        if [ "$actions_off" -eq 0 ]; then
            body=$(gh_api "repos/$ORG/$repo/actions/workflows?per_page=100")
            rc=$?
            if [ $rc -eq 0 ]; then
                wf_active=$(jq -r '[.workflows[]? | select(.state == "active")] | length' <<< "$body")
            elif [ $rc -ne 2 ]; then
                printf 'error\tapi-error\tworkflows: %s | %s\n' "$(api_error "$body")" "$link"
                return
            fi
        fi
        if [ "$wf_active" -gt 0 ]; then
            printf 'no-checks\tno-checks\t%d active workflow(s), none ran on head | %s\n' \
                "$wf_active" "$link"
        else
            local why='no CI configured'
            [ "$actions_off" -eq 1 ] && why='Actions disabled'
            [ "$checks_404" -eq 1 ] && why="$why, checks API unavailable"
            printf 'no-ci\tno-ci\t%s | %s\n' "$why" "$link"
        fi
        return
    fi

    printf 'success\tsuccess\t%s\n' "$link"
}

# ---------------------------------------------------------------------------
# Rendering
# ---------------------------------------------------------------------------

# render_line <repo> <branch> <state> <label> <detail>
render_line() {
    local repo="$1" branch="$2" state="$3" label="$4" detail="$5" color mark
    case "$state" in
        success)   color="$GREEN";  mark="✔" ;;
        failure)   color="$RED";    mark="✖" ;;
        error)     color="$RED";    mark="‼" ;;
        cancelled) color="$YELLOW"; mark="⊘" ;;
        no-checks) color="$YELLOW"; mark="▴" ;;
        pending)   color="$YELLOW"; mark="•" ;;
        no-ci)     color="$DIM";    mark="–" ;;
        empty)     color="$YELLOW"; mark="○" ;;
        *)         color="$RED";    mark="‼"; label="internal-error" ;;
    esac
    printf '%s%s%s %-40s %s%-12s%s %s%-10s%s %s%s%s\n' \
        "$color" "$mark" "$RESET" "$ORG/$repo" \
        "$DIM" "${branch:-(none)}" "$RESET" \
        "$color" "$label" "$RESET" \
        "$DIM" "$detail" "$RESET"
}

# Check one repository and print its verdict as soon as it is known.  The
# result is also written to its own file so the closing summary is computed
# from complete data rather than from whatever happened to reach the terminal.
if [ "${1:-}" = "--report" ]; then
    _idx="$2"; _repo="$3"; _branch="$4"
    _result=$(check_repo "$_repo" "$_branch")
    printf '%s\t%s\t%s\n' "$_repo" "$_branch" "$_result" > "$RESULTS_DIR/$_idx"

    # One line at a time: workers run concurrently, so serialise the write.
    while ! mkdir "$LOCK_DIR" 2>/dev/null; do sleep 0.05; done
    _n=$(( $(cat "$COUNTER_FILE" 2>/dev/null || echo 0) + 1 ))
    printf '%s' "$_n" > "$COUNTER_FILE"
    IFS=$'\t' read -r _state _label _detail <<< "$_result"
    printf '%s[%*d/%d]%s ' "$DIM" "${#TOTAL}" "$_n" "$TOTAL" "$RESET"
    render_line "$_repo" "$_branch" "$_state" "$_label" "$_detail"
    rmdir "$LOCK_DIR"
    exit 0
fi

# Single-repository entry point, handy for debugging one repository by hand.
if [ "${1:-}" = "--worker" ]; then
    check_repo "$2" "$3"
    exit 0
fi

# ---------------------------------------------------------------------------
# Driver
# ---------------------------------------------------------------------------

gh auth status >/dev/null 2>&1 || { gh auth status; exit 1; }

repos_json=$(gh repo list "$ORG" --limit "$REPO_LIMIT" \
    --json name,defaultBranchRef,isArchived,isFork 2>/dev/null)
if [ -z "$repos_json" ] || ! jq -e 'type == "array"' >/dev/null 2>&1 <<< "$repos_json"; then
    printf '%s✖ could not list repositories for %s%s\n' "$RED" "$ORG" "$RESET" >&2
    exit 1
fi

total_repos=$(jq -r 'length' <<< "$repos_json")
if [ "$total_repos" -ge "$REPO_LIMIT" ]; then
    printf '%s! repository list hit the limit of %d; raise REPO_LIMIT%s\n' \
        "$YELLOW" "$REPO_LIMIT" "$RESET" >&2
fi

repos=$(jq -r --argjson arch "$INCLUDE_ARCHIVED" --argjson forks "$INCLUDE_FORKS" '
    .[]
    | select($arch == 1 or (.isArchived | not))
    | select($forks == 1 or (.isFork | not))
    | "\(.name)\t\(.defaultBranchRef.name // "")"' <<< "$repos_json")

scanned=$(grep -c . <<< "$repos")
skipped=$(( total_repos - scanned ))
if [ "$scanned" -eq 0 ]; then
    printf '%s✖ no repositories matched the filters (%d listed, %d skipped)%s\n' \
        "$RED" "$total_repos" "$skipped" "$RESET" >&2
    exit 1
fi

tmp=$(mktemp -d) || exit 1
trap 'rm -rf "$tmp"' EXIT

# Fan out.  Each worker writes its own numbered file, so the report stays in
# repository order and the summary is computed from complete results rather
# than from a partially-read stream.
mkdir -p "$tmp/results"
export RESULTS_DIR="$tmp/results" LOCK_DIR="$tmp/lock" \
       COUNTER_FILE="$tmp/counter" TOTAL="$scanned"
# The workers re-execute this script, so the knobs must reach them.
export ORG INCLUDE_DYNAMIC_RUNS CANCELLED_IS_FAIL

i=0
while IFS=$'\t' read -r repo branch; do
    [ -n "$repo" ] || continue
    printf '%04d\0%s\0%s\0' "$i" "$repo" "$branch"
    i=$((i + 1))
done <<< "$repos" | xargs -0 -P "$JOBS" -n 3 "$SELF" --report

ok=0; pending=0; cancelled=0; nochecks=0; noci=0; empties=0; seen=0
failed=(); errored=(); stalled=()

for f in "$tmp"/results/*; do
    [ -f "$f" ] || continue
    IFS=$'\t' read -r repo branch state label detail < "$f"
    [ -n "$repo" ] || continue

    seen=$((seen + 1))
    case "$state" in
        success)   ok=$((ok + 1)) ;;
        failure)   failed+=("https://github.com/$ORG/$repo") ;;
        error)     errored+=("$ORG/$repo — $detail") ;;
        cancelled) cancelled=$((cancelled + 1)); stalled+=("$ORG/$repo — $detail") ;;
        no-checks) nochecks=$((nochecks + 1)); stalled+=("$ORG/$repo — $detail") ;;
        pending)   pending=$((pending + 1)) ;;
        no-ci)     noci=$((noci + 1)) ;;
        empty)     empties=$((empties + 1)) ;;
        *)         errored+=("$ORG/$repo — unrecognised state '$state'") ;;
    esac
done

# A worker that died without writing its file would otherwise vanish from the
# report entirely; count the difference as unverified rather than losing it.
if [ "$seen" -lt "$scanned" ]; then
    errored+=("$(( scanned - seen )) repositor$([ $(( scanned - seen )) -eq 1 ] && echo y || echo ies) produced no result")
fi

echo ""

if [ ${#failed[@]} -gt 0 ]; then
    printf '%s%s✖ %d failing repositor%s%s\n' "$BOLD" "$RED" "${#failed[@]}" \
        "$([ ${#failed[@]} -eq 1 ] && echo y || echo ies)" "$RESET"
    for url in "${failed[@]}"; do
        printf '  %s%s%s\n' "$CYAN" "$url" "$RESET"
    done
fi

if [ ${#errored[@]} -gt 0 ]; then
    printf '%s%s‼ %d repositor%s could not be verified%s\n' "$BOLD" "$RED" "${#errored[@]}" \
        "$([ ${#errored[@]} -eq 1 ] && echo y || echo ies)" "$RESET"
    for line in "${errored[@]}"; do
        printf '  %s%s%s\n' "$DIM" "$line" "$RESET"
    done
fi

if [ ${#stalled[@]} -gt 0 ]; then
    printf '%s%s▴ %d repositor%s neither passed nor failed%s\n' \
        "$BOLD" "$YELLOW" "${#stalled[@]}" \
        "$([ ${#stalled[@]} -eq 1 ] && echo y || echo ies)" "$RESET"
    for line in "${stalled[@]}"; do
        printf '  %s%s%s\n' "$DIM" "$line" "$RESET"
    done
fi

if [ ${#failed[@]} -eq 0 ] && [ ${#errored[@]} -eq 0 ]; then
    printf '%s%s✔ All %d verified repositories are green on their default branch%s\n' \
        "$BOLD" "$GREEN" "$ok" "$RESET"
fi

printf '%s%d green · %d failing · %d unverified · %d pending · %d cancelled · %d no-checks · %d no-ci · %d empty · %d skipped%s\n' \
    "$DIM" "$ok" "${#failed[@]}" "${#errored[@]}" "$pending" "$cancelled" \
    "$nochecks" "$noci" "$empties" "$skipped" "$RESET"

[ ${#failed[@]} -eq 0 ] && [ ${#errored[@]} -eq 0 ]
