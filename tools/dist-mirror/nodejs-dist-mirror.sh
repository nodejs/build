#!/usr/bin/env bash
# Mirror https://nodejs.org/dist/ to a local directory with rclone, replacing
# the retired rsync endpoint. See README.md for usage and scheduling.
#
#     nodejs-dist-mirror.sh [--full] DEST [-- extra rclone flags]
#
# Default (incremental) mode copies release directories that are missing
# locally or were published in the last RECENT_DAYS days, then the top-level
# files (index.json, index.tab, ...). --full runs a complete `rclone sync`,
# which also catches older changes and deletions.
#
# In both modes the latest-* directories are not downloaded; they are
# recreated as local symlinks derived from index.json.

set -euo pipefail

DIST_URL=${DIST_URL:-https://nodejs.org/dist/}
RECENT_DAYS=${RECENT_DAYS:-14}

full=false
if [ "${1:-}" = "--full" ]; then
  full=true
  shift
fi
if [ $# -lt 1 ]; then
  echo "usage: $0 [--full] DEST [-- extra rclone flags]" >&2
  exit 2
fi
dest=${1%/}
shift
[ "${1:-}" = "--" ] && shift

mkdir -p "$dest"

rc() {
  rclone --http-url "$DIST_URL" \
    --user-agent "nodejs-dist-mirror (+https://github.com/nodejs/build)" \
    "$@"
}
# Only for directory transfers: rclone refuses filters on single files.
# --skip-links stops rclone warning about our own local symlinks.
skip_links=(--exclude "/latest/**" --exclude "/latest-*/**"
  --exclude "/node-latest.tar.gz" --skip-links)

index=$(rc cat :http:index.json)

# Map of symlink name -> target, matching the release worker's
# src/constants/latestVersions.json (only v0.10 and v0.12 get v0 links).
links=$(jq -r '
  def semver: .version | ltrimstr("v") | split(".") | map(tonumber);
  def line: semver as $v | if $v[0] == 0 then "v0.\($v[1]).x" else "v\($v[0]).x" end;
  def newest: max_by(semver).version;

  newest as $latest
  | [ {key: "latest", value: $latest},
      {key: "node-latest.tar.gz", value: "latest/node-\($latest).tar.gz"} ]
  + (group_by(line) | map({key: "latest-\(.[0] | line)", value: newest})
     | map(select((.key | startswith("latest-v0.") | not)
                  or .key == "latest-v0.10.x" or .key == "latest-v0.12.x")))
  + (map(select(.lts)) | group_by(.lts)
     | map({key: "latest-\(.[0].lts | ascii_downcase)", value: newest}))
  | .[] | "\(.key) \(.value)"' <<<"$index")

if $full; then
  rc sync :http: "$dest" "${skip_links[@]}" "$@"
else
  # Release directories first, so index.json never lists a version whose
  # files are not there yet.
  recent=$(jq -r --argjson days "$RECENT_DAYS" '
    (now - $days * 86400 | strftime("%Y-%m-%d")) as $cutoff
    | .[] | select(.date >= $cutoff) | .version' <<<"$index")
  for version in $(jq -r '.[].version' <<<"$index"); do
    if [ ! -d "$dest/$version" ] || grep -qxF "$version" <<<"$recent"; then
      rc copy ":http:$version" "$dest/$version" "$@"
    fi
  done
  rc copy :http: "$dest" --max-depth 1 "${skip_links[@]}" "$@"
fi

# Swap each symlink in atomically, skipping any whose target is missing.
while read -r name target; do
  if [ -e "$dest/$target" ]; then
    ln -sfn "$target" "$dest/.$name.tmp"
    mv -Tf "$dest/.$name.tmp" "$dest/$name"
  fi
done <<<"$links"
