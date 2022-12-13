#!/bin/bash
# Pass `NODE_VERSION` as an environment variable. Can be an exact or vague version.
# NODE_VERSION=v8 ./download-test.sh --tap ./test.tap

while [ $# -gt 1 ]; do

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

if [ "$DOWNLOAD_LOCATION" == "Nightly" ]; then
  downloadDir="nightly"
else
  downloadDir="release"
fi

if [ -z "$NODE_VERSION" ]; then
  echo "NODE_VERSION is undefined! Please declare NODE_VERSION"
  exit 1
fi

# If the provided NODE_VERSION is inexact, e.g. `v8`, get the most recent matching version.
LINK=`rsync rsync://unencrypted.nodejs.org/nodejs/$downloadDir/ | grep $NODE_VERSION | sort -t. -k 1,1n -k 2,2n -k 3,3n | tail -1 | awk '{print $5}'`

if [ -z "$LINK" ]; then
  echo "No matches found for '$NODE_VERSION' in https://unencrypted.nodejs.org/nodejs/$downloadDir/"
  exit 1
fi

# Remove old files
rm -rf v*
[ "$tapFile" ] && rm -rf "$tapFile" && echo "TAP version 13" > $tapFile

# Scrape the download server
rsync -av rsync://unencrypted.nodejs.org/nodejs/"$downloadDir"/"$LINK" .

testNumber=0
cat "$LINK"/SHASUMS256.txt | {
  while read line; do
   let testNumber++ # Increment at the beginning
   sha=$(echo "${line}" | awk '{print $1}')
   file=$(echo "${line}" | awk '{print $2}')
   echo "Checking shasum for $file"
   calculatedSHA=$(shasum -a 256 "$LINK/$file" | awk '{print $1}')
   if [ "$calculatedSHA" != "$sha" ]; then
     echo "Error - SHASUMS256 does not match for $file"
     echo "Expected - $sha"
     echo "Found - $calculatedSHA"
     if [ "$tapFile" ]; then
       echo "not ok $testNumber SHASUMS256 does not match for $file
         ---
           Expected - $sha
           Found - $remoteSHA
         ...
       " >> "$tapFile"
     fi
   else
     echo "Pass - SHASUMS256 is correct for $file"
     [ "$tapFile" ] && echo "ok $testNumber SHASUMS256 for $file is correct" >> "$tapFile"
   fi
  done
[ "$tapFile" ] && echo "1..$testNumber" >> "$tapFile"
}
