#!/usr/bin/env bash

set -e

site=$1

__dirname="$(CDPATH= cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "X$site" != "Xiojs" ] && [ "X$site" != "Xnodejs" ]; then
  echo "Usage: promote_release.sh < iojs | nodejs > <version>"
  exit 1
fi

if [ "X$2" == "X" ]; then
  echo "Usage: promote_release.sh < iojs | nodejs > <version>"
  exit 1
fi

. ${__dirname}/settings

srcdir=$release_srcdir
dstdir=$release_dstdir
dirmatch=$release_dirmatch

node --no-warnings /home/staging/tools/promote/check_assets.js $srcdir/$2 $dstdir/$2

while true; do
  echo -n "Are you sure you want to promote the $2 assets? [y/n] "
  yorn=""
  read yorn

  if [ "X${yorn}" == "Xn" ]; then
    echo "Bailing out ..."
    exit 1
  fi

  if [ "X${yorn}" == "Xy" ]; then
      . ${__dirname}/_promote.sh $site $2
      nodejs-latest-linker /home/dist/${site}/release/ /home/dist/${site}/docs/
      dstdir=/home/dist/${site}/docs
      . ${__dirname}/upload_to_cloudflare.sh $site $2
    break
  fi
done
