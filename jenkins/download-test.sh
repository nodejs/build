#!/bin/bash
# Pass `NODE_VERSION` as an environment variable. Can be an exact or vague version.
# NODE_VERSION=v8 ./download-test.sh --tap ./test.tap

while [ $# -gt 0 ]; do

  case "$1" in
      -t|--tap)
      tapFile="$2"
      shift # Past option argument.
      ;;
      *) # unknown option
      echo "Ignoring unknown option: $1"
      ;;
  esac
  shift # Past option.
done

case $DOWNLOAD_LOCATION in
  [Nn][Ii][Gg][Hh][Tt][Ll][Yy])
    downloadDir="nightly"
    ;;
  *)
    downloadDir="release"
    ;;
esac

if [ -z "$NODE_VERSION" ]; then
  echo "NODE_VERSION is undefined! Please declare NODE_VERSION"
  exit 1
fi

indexUrl="https://nodejs.org/download/$downloadDir/index.tab"
indexTab=$(curl -sSf "$indexUrl")

if [ -z "$indexTab" ]; then
  echo "Failed to fetch index from $indexUrl"
  exit 1
fi

# If the provided NODE_VERSION is inexact, e.g. `v8`, get the most recent matching version.
VERSION=$(echo "$indexTab" | awk 'NR>1 {print $1}' | grep -E "${NODE_VERSION}" | head -n 1)

if [ -z "$VERSION" ]; then
  echo "No matches found for '$NODE_VERSION' in $indexUrl"
  [ "$tapFile" ] && rm "$tapFile" && echo "TAP version 13
not ok 1 - find most recent downloads for ${NODE_VERSION}
  ---
  No matches found for '$NODE_VERSION' in $indexUrl
  ...
1..1" > "$tapFile"
  exit 1
fi

__dirname="$(CDPATH= cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXPECTED_ASSETS_DIR="${__dirname}/../ansible/www-standalone/tools/promote/expected_assets"

major=$(echo "$VERSION" | sed -E 's/^v([0-9]+).*/\1/')
LINE="v${major}.x"
EXPECTED_ASSETS_FILE="${EXPECTED_ASSETS_DIR}/${LINE}"

if [ ! -f "$EXPECTED_ASSETS_FILE" ]; then
  # Expected assets may not exist for nightlies from the `main` branch.
  # Fall back to existing assets from the previous semver major line.
  if [ "$downloadDir" = "nightly" ]; then
    major=$((major - 1))
    PREVIOUS_LINE="v${major}.x"
    EXPECTED_ASSETS_FILE="${EXPECTED_ASSETS_DIR}/${PREVIOUS_LINE}"
    echo "No expected assets file found for ${LINE} in ${EXPECTED_ASSETS_DIR}, falling back to expected assets for ${PREVIOUS_LINE}"
    LINE="${PREVIOUS_LINE}"
  fi
fi
if [ ! -f "$EXPECTED_ASSETS_FILE" ]; then
  echo "No expected assets file found for ${LINE} in ${EXPECTED_ASSETS_DIR}"
  exit 1
fi

# Determine checksum tool
if command -v sha256sum >/dev/null 2>&1; then
  shasum_cmd="sha256sum"
elif command -v shasum >/dev/null 2>&1; then
  shasum_cmd="shasum -a 256"
else
  echo "Neither sha256sum nor shasum is available"
  exit 1
fi

# Remove old files
rm -rf "$VERSION"
[ "$tapFile" ] && rm -rf "$tapFile" && echo "TAP version 13" > "$tapFile"

mkdir -p "$VERSION"
shasumsUrl="https://nodejs.org/download/$downloadDir/$VERSION/SHASUMS256.txt"
if ! curl -sSf "$shasumsUrl" -o "$VERSION/SHASUMS256.txt"; then
  echo "Failed to download SHASUMS256.txt from $shasumsUrl"
  exit 1
fi

testNumber=0
while IFS= read -r line || [ -n "$line" ]; do
  # Trim whitespace
  line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  # Skip empty lines, comments, and directory entries ending in /
  [ -z "$line" ] && continue
  [[ "$line" =~ ^# ]] && continue
  [[ "$line" =~ /$ ]] && continue

  let testNumber++
  file="${line//\{VERSION\}/$VERSION}"
  fileUrl="https://nodejs.org/download/$downloadDir/$VERSION/$file"
  localFile="$VERSION/$file"

  mkdir -p "$(dirname "$localFile")"

  echo "Downloading $file"
  if ! curl -sSf "$fileUrl" -o "$localFile"; then
    echo "Error - Failed to download $file"
    if [ "$tapFile" ]; then
      echo "not ok $testNumber Failed to download $file
  ---
    URL - $fileUrl
  ...
" >> "$tapFile"
    fi
    continue
  fi

  sha=$(grep -E "[ *]${file}$" "$VERSION/SHASUMS256.txt" | awk '{print $1}')
  if [ -n "$sha" ]; then
    echo "Checking shasum for $file"
    calculatedSHA=$($shasum_cmd "$localFile" | awk '{print $1}')
    if [ "$calculatedSHA" != "$sha" ]; then
      echo "Error - SHASUMS256 does not match for $file"
      echo "Expected - $sha"
      echo "Found - $calculatedSHA"
      if [ "$tapFile" ]; then
        echo "not ok $testNumber SHASUMS256 does not match for $file
  ---
    Expected - $sha
    Found - $calculatedSHA
  ...
" >> "$tapFile"
      fi
    else
      echo "Pass - SHASUMS256 is correct for $file"
      [ "$tapFile" ] && echo "ok $testNumber SHASUMS256 for $file is correct" >> "$tapFile"
    fi
  else
    echo "Pass - Downloaded $file"
    [ "$tapFile" ] && echo "ok $testNumber Downloaded $file" >> "$tapFile"
  fi
done < "$EXPECTED_ASSETS_FILE"

[ "$tapFile" ] && echo "1..$testNumber" >> "$tapFile"
