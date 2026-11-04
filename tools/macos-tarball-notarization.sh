#!/usr/bin/env bash

# Check, and optionally backfill, Apple notarization tickets for the bin/node
# binaries shipped in the Node.js darwin release tarballs.
#
# Background: the release tarballs are codesigned but, until nodejs/node
# started notarizing them in the tarball build, nothing submitted their
# bin/node to the notary service. Only the .pkg was notarized, and its
# bin/node is a different build (different install prefix), so its ticket
# does not cover the tarball binary. Gatekeeper looks tickets up by code
# directory hash. See https://github.com/nodejs/node/issues/67140 for the
# full analysis, plus https://github.com/nodejs/build/issues/3538 and
# https://github.com/nodejs/build/issues/4545.
#
# Notarizing an already published binary does not modify it: Apple records
# its code directory hash and Gatekeeper fetches the ticket online. The
# published SHASUMS256.txt stays valid.
#
# Usage:
#   tools/macos-tarball-notarization.sh [--submit] [--arch x64|arm64|all] <version>...
#   tools/macos-tarball-notarization.sh [--submit] --all-supported [--latest N]
#
#   --submit          submit every binary that has no ticket to the Apple
#                     notary service. Requires a Mac with full Xcode and a
#                     notarytool keychain profile (default NODE_RELEASE_PROFILE,
#                     as provisioned on the release images by
#                     orka/templates/macos-release.pkr.hcl), and
#                     NOTARIZATION_TEAM_ID set to the team the binaries must
#                     be signed by. Without --submit the script only reports.
#   --arch            which tarball architectures to check for the versions
#                     given on the command line (default all).
#   --all-supported   instead of explicit versions, take the releases of every
#                     release line that is currently supported according to
#                     the Release WG schedule, and for each one only the
#                     darwin tarballs it actually published. Releases only;
#                     nightlies are never included.
#   --latest N        with --all-supported, only the N most recent releases
#                     of each line. 0 (the default) means all of them. Every
#                     check downloads one tarball per architecture, so the
#                     scheduled job uses a small N and a deeper backfill is a
#                     one-off run with a larger one.
#
# Environment:
#   NOTARIZATION_PROFILE   keychain profile name (default NODE_RELEASE_PROFILE)
#   NOTARIZATION_TEAM_ID   required with --submit; binaries whose signature
#                          is not from this team are reported and skipped
#   NODE_DIST_URL, NODE_SCHEDULE_URL
#                          alternative sources for check mode only, for
#                          example the nightly tree; refused with --submit
#
# The ticket check queries Apple's Gatekeeper ticket service by code directory
# hash, the same lookup macOS performs, so it needs network access and does
# not depend on what this machine has cached.
#
# Exit status: 0 when every checked binary has a ticket, 1 when at least one
# binary lacks a ticket after a completed check, 2 on usage errors, 3 when an
# infrastructure problem (download, extraction, ticket lookup, notary
# service, signature from an unexpected team) prevented a check from
# completing.

set -euo pipefail

default_dist="https://nodejs.org/dist"
default_schedule="https://raw.githubusercontent.com/nodejs/Release/HEAD/schedule.json"

submit=0
arch=all
all_supported=0
latest=0
versions=()
dist="${NODE_DIST_URL:-$default_dist}"
schedule="${NODE_SCHEDULE_URL:-$default_schedule}"
profile="${NOTARIZATION_PROFILE:-NODE_RELEASE_PROFILE}"
team="${NOTARIZATION_TEAM_ID:-}"

usage_error() { echo "error: $*" >&2; exit 2; }

while [ $# -gt 0 ]; do
  case "$1" in
    --submit) submit=1 ;;
    --all-supported) all_supported=1 ;;
    --arch) [ $# -ge 2 ] || usage_error "--arch needs a value"; shift; arch="$1" ;;
    --arch=*) arch="${1#--arch=}" ;;
    --latest) [ $# -ge 2 ] || usage_error "--latest needs a value"; shift; latest="$1" ;;
    --latest=*) latest="${1#--latest=}" ;;
    -h|--help) sed -n '3,55p' "$0"; exit 0 ;;
    v*) versions+=("$1") ;;
    *) usage_error "unknown argument $1" ;;
  esac
  shift
done

if [ "$all_supported" -eq 0 ] && [ "${#versions[@]}" -eq 0 ]; then
  usage_error "give at least one version, for example v26.13.0, or --all-supported"
fi
if [ "$all_supported" -eq 1 ] && [ "${#versions[@]}" -gt 0 ]; then
  usage_error "--all-supported cannot be combined with explicit versions"
fi
case "$latest" in
  ''|*[!0-9]*) usage_error "--latest needs a non-negative number (0 means all)" ;;
esac
if [ "$latest" -gt 0 ] && [ "$all_supported" -eq 0 ]; then
  usage_error "--latest only applies with --all-supported"
fi
case "$arch" in
  all) arches="x64 arm64" ;;
  x64|arm64) arches="$arch" ;;
  *) usage_error "--arch must be x64, arm64 or all" ;;
esac
# Versions become URL and tar member paths. Check mode accepts nightly
# strings such as v28.0.0-nightly20261030abcdef1234; a credentialed run only
# accepts canonical release versions.
for v in "${versions[@]+"${versions[@]}"}"; do
  case "$v" in
    *[!A-Za-z0-9.-]*) usage_error "invalid version string $v" ;;
  esac
  if [ "$submit" -eq 1 ]; then
    echo "$v" | grep -Eq '^v[0-9]+\.[0-9]+\.[0-9]+$' || usage_error "--submit only accepts release versions, got $v"
  fi
done
if [ "$submit" -eq 1 ]; then
  # A credentialed run must only ever submit what nodejs.org publishes.
  [ "$dist" = "$default_dist" ] || usage_error "--submit does not accept NODE_DIST_URL"
  [ "$schedule" = "$default_schedule" ] || usage_error "--submit does not accept NODE_SCHEDULE_URL"
  [ -n "$team" ] || usage_error "--submit needs NOTARIZATION_TEAM_ID"
fi

if [ "$(uname -s)" != "Darwin" ]; then
  echo "error: this script needs macOS (codesign, ditto, notarytool)" >&2
  exit 2
fi

# Temporary workspace, removed on any exit. Same shape as the
# tools/dep_updaters scripts in nodejs/node. Signals exit with their
# conventional status so Jenkins sees an abort, not a success.
workdir=$(mktemp -d 2> /dev/null || mktemp -d -t 'tmp')
cleanup () {
  EXIT_CODE=$?
  [ -d "$workdir" ] && rm -rf "$workdir" || true
  exit $EXIT_CODE
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

# Ask Apple's ticket service directly, keyed by the binary's code directory
# hash. This is the lookup syspolicyd performs and it is the only reliable
# check for a bare binary: `codesign --verify -R=notarized` only consults the
# local ticket cache and answers "no" for a notarized binary this machine has
# never fetched a ticket for, and spctl rejects command line tools outright.
# Returns 0 ticket present, 1 no ticket, 2 lookup failed (network, format).
ticket_api="https://api.apple-cloudkit.com/database/1/com.apple.gk.ticket-delivery/production/public/records/lookup"
has_ticket() {
  local cdhash reply
  # Exactly one 40-hex CDHash: the tarball binaries are thin. A universal
  # binary prints one per slice and would need every slice ticketed, so it
  # is refused here rather than half-checked.
  cdhash=$(codesign -dvvv "$1" 2>&1 | sed -n 's/^CDHash=//p')
  if ! echo "$cdhash" | grep -Eqx '[0-9a-f]{40}' || [ "$(echo "$cdhash" | wc -l)" -ne 1 ]; then
    echo "    could not read a single CDHash from codesign"
    return 2
  fi
  reply=$(curl -fsS -X POST "$ticket_api" -H 'Content-Type: application/json' \
    -d "{\"records\":[{\"recordName\":\"2/2/$cdhash\"}]}" 2>/dev/null) || return 2
  # Structural check: one record, for the hash we asked about. Anything else
  # is a lookup failure, never "present". The reply travels in the
  # environment because stdin carries the program.
  TICKET_REPLY="$reply" TICKET_WANT="2/2/$cdhash" python3 -I - <<'PY'
import json, os, sys
want = os.environ["TICKET_WANT"]
try:
    records = json.loads(os.environ["TICKET_REPLY"])["records"]
except Exception:
    sys.exit(2)
if len(records) != 1 or records[0].get("recordName") != want:
    sys.exit(2)
r = records[0]
if r.get("serverErrorCode") == "NOT_FOUND":
    sys.exit(1)
if "serverErrorCode" not in r and r.get("recordType") == "DeveloperIDTicket":
    sys.exit(0)
sys.exit(2)
PY
}

signed_by_team() {
  codesign -dvv "$1" 2>&1 | grep -Fqx "TeamIdentifier=$team"
}

# Tickets can take a few minutes to become visible after notarytool reports
# Accepted, so poll with backoff (about 8 minutes in total).
# Returns 0 once the ticket is visible, 1 if it never appeared, 2 if the
# last lookup itself failed (so an Apple outage is not reported as delay).
wait_for_ticket() {
  local delay=15 attempt=1 rc=0
  while :; do
    rc=0
    has_ticket "$1" || rc=$?
    [ "$rc" -eq 0 ] && return 0
    if [ "$attempt" -ge 6 ]; then
      return "$rc"
    fi
    if [ "$rc" -eq 2 ]; then
      echo "    ticket lookup failed, retrying in ${delay}s (attempt $attempt)"
    else
      echo "    ticket not visible yet, retrying in ${delay}s (attempt $attempt)"
    fi
    sleep "$delay"
    attempt=$((attempt + 1))
    delay=$((delay * 2))
  done
}

# Zip, submit, remove the zip. Each step guarded so a failure is reported
# where it happens instead of cascading into notarytool with a bad archive.
# notarytool exits 0 whenever the submission completes, including when Apple
# rejects it, so the verdict has to be read from its output: only
# "status: Accepted" counts. On any other verdict the notary log is printed,
# it names the signing or entitlement problem Apple found.
submit_binary() {
  local binary="$1" zip="$1.zip" out id
  # ditto keeps the code signature intact and is the archiver Apple documents
  # for notarization uploads.
  if ! ditto -c -k --keepParent "$binary" "$zip"; then
    echo "    ditto failed to create $zip"
    return 1
  fi
  out=$(xcrun notarytool submit --keychain-profile "$profile" --wait --timeout 30m "$zip" 2>&1) || {
    rm -f "$zip"
    echo "$out" | sed 's/^/    | /'
    echo "    notarytool submission failed or timed out"
    return 1
  }
  rm -f "$zip"
  echo "$out" | sed 's/^/    | /'
  if ! echo "$out" | grep -Eq '^ *status: Accepted$'; then
    id=$(echo "$out" | sed -n 's/^ *id: //p' | head -1)
    echo "    notarization NOT accepted by Apple"
    if [ -n "$id" ]; then
      xcrun notarytool log "$id" --keychain-profile "$profile" 2>&1 | sed 's/^/    | /' || true
    fi
    return 1
  fi
}

# Build the list of "<version> <arch>" pairs to check into a file, so that a
# failed fetch or resolver is a hard error instead of an empty loop. For
# explicit versions use the requested architectures. For --all-supported read
# the release schedule for the lines whose support window includes today,
# then the dist index for the releases of those lines and the darwin tarballs
# each one actually published (v28+ has no darwin-x64, for example).
resolve_targets() {
  if [ "$all_supported" -eq 0 ]; then
    for v in "${versions[@]}"; do
      for a in $arches; do echo "$v $a"; done
    done
    return
  fi
  curl -fsSL "$schedule" -o "$workdir/schedule.json" || return 1
  curl -fsSL "$dist/index.json" -o "$workdir/index.json" || return 1
  python3 -I - "$workdir/schedule.json" "$workdir/index.json" "$latest" <<'PY'
import json, re, sys, datetime
schedule = json.load(open(sys.argv[1]))
index = json.load(open(sys.argv[2]))
latest = int(sys.argv[3])
release = re.compile(r"^v\d+\.\d+\.\d+$")

def day(value, line, field):
    try:
        return datetime.date.fromisoformat(value)
    except (TypeError, ValueError):
        sys.exit(f"schedule.json: line {line} has no valid {field} date")

supported = set()
today = datetime.date.today()
for line, info in schedule.items():
    if day(info.get("start"), line, "start") <= today < day(info.get("end"), line, "end"):
        supported.add(line)
if not supported:
    sys.exit("schedule.json: no release line is in its support window today")

def key(entry):
    return tuple(int(x) for x in entry["version"][1:].split("."))

entries = [e for e in index if release.match(e["version"])]
entries.sort(key=key, reverse=True)  # do not rely on the index being newest-first
seen = {}
for entry in entries:
    major = "v" + str(key(entry)[0])
    if major not in supported:
        continue
    seen[major] = seen.get(major, 0) + 1
    if latest and seen[major] > latest:
        continue
    for a in ("x64", "arm64"):
        if f"osx-{a}-tar" in entry["files"]:
            print(entry["version"], a)
PY
}

missing=0   # checks completed, binary has no ticket
failed=0    # checks that could not complete (download, extract, notary, team)
checked=0

# Check one "<version> <arch>" tarball.
check_one() {
  local version="$1" a="$2"
  local name="node-$version-darwin-$a"
  local tarball="$name.tar.gz"
  local binary="$workdir/$name/bin/node"

  echo "==> $name"
  if ! curl -fsSL -o "$workdir/$tarball" "$dist/$version/$tarball"; then
    echo "    download failed: $dist/$version/$tarball"
    failed=$((failed + 1))
    return
  fi
  if ! tar -xzf "$workdir/$tarball" -C "$workdir" "$name/bin/node"; then
    echo "    extract failed: $tarball"
    failed=$((failed + 1))
    return
  fi

  if ! codesign --verify --strict "$binary" 2>/dev/null; then
    echo "    codesign: INVALID signature"
    missing=$((missing + 1))
    return
  fi

  local rc=0
  has_ticket "$binary" || rc=$?   # bare call would trip errexit
  case "$rc" in
    0) echo "    notarization: ticket present"; return ;;
    2) echo "    notarization: ticket lookup failed"; failed=$((failed + 1)); return ;;
  esac

  if [ "$submit" -eq 0 ]; then
    echo "    notarization: NO ticket (run with --submit to backfill)"
    missing=$((missing + 1))
    return
  fi

  if ! signed_by_team "$binary"; then
    echo "    signature is not from team $team, refusing to submit"
    failed=$((failed + 1))
    return
  fi

  echo "    notarization: no ticket, submitting with profile $profile"
  if ! submit_binary "$binary"; then
    failed=$((failed + 1))
    return
  fi
  local wrc=0
  wait_for_ticket "$binary" || wrc=$?
  case "$wrc" in
    0) echo "    notarization: ticket present after submission" ;;
    2) echo "    notarization: accepted by Apple, ticket lookup failing after submission"
       failed=$((failed + 1)) ;;
    *) echo "    notarization: accepted by Apple, ticket still not visible after retries"
       failed=$((failed + 1)) ;;
  esac
}

if ! resolve_targets > "$workdir/targets"; then
  echo "error: could not resolve the tarballs to check" >&2
  exit 3
fi

while read -r version a; do
  [ -n "$version" ] || continue
  checked=$((checked + 1))
  check_one "$version" "$a"
  # Free the disk between binaries; a full --all-supported run is many GB.
  rm -rf "$workdir/node-$version-darwin-$a" "$workdir/node-$version-darwin-$a.tar.gz" || true
done < "$workdir/targets"

if [ "$checked" -eq 0 ]; then
  echo "error: no tarballs matched; check the schedule and index" >&2
  exit 2
fi
echo "checked $checked, without ticket $missing, could not check $failed"
if [ "$failed" -gt 0 ]; then
  echo "infrastructure problems prevented some checks; see above" >&2
  exit 3
fi
if [ "$missing" -gt 0 ]; then
  echo "published binaries without a notarization ticket; see above" >&2
  exit 1
fi
echo "all checked binaries carry a notarization ticket"
