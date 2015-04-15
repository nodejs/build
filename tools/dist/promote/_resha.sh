#!/usr/bin/env bash

dstdir=$1
version=$2

if [ "X${dstdir}" == "X" ]; then
  echo "dstdir argument not provided"
  exit 1
fi

if [ "X${version}" == "X" ]; then
  echo "version argument not provided"
  exit 1
fi

(cd "${dstdir}/${version}" && shasum -a256 $(ls iojs* win-*/* 2> /dev/null) > SHASUMS256.txt) || exit 1
echo "${dstdir}/${version}/SHASUMS256.txt"
/home/dist/dist-indexer/dist-indexer.js --dist $dstdir --indexjson ${dstdir}/index.json  --indextab ${dstdir}/index.tab
find "${dstdir}/${version}" -type f -exec chmod 644 '{}' \;
find "${dstdir}/${version}" -type d -exec chmod 755 '{}' \;
