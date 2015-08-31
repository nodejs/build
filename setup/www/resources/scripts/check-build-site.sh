#!/bin/bash

site=$1

if [ "X$site" != "Xiojs" ] && [ "X$site" != "Xnodejs" ]; then
  echo "Usage: check-build-site.sh < iojs | nodejs >"
  exit 1
fi

indexjson=/home/dist/${site}/release/index.json
indexhtml=/home/www/${site}/en/index.html
buildsite=/home/nodejs/build-site.sh

[ $indexjson -nt $indexhtml ] && $buildsite $site