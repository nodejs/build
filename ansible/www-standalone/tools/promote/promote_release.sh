#!/usr/bin/env bash

set -e

site=$1

__dirname="$(CDPATH= cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$site" != "iojs" ] && [ "$site" != "nodejs" ]; then
  echo "Usage: promote_release.sh < iojs | nodejs > <version>"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Usage: promote_release.sh < iojs | nodejs > <version>"
  exit 1
fi

. ${__dirname}/settings

srcdir=$release_srcdir
dstdir=$release_dstdir
dirmatch=$release_dirmatch

node --no-warnings /home/staging/tools/promote/check_assets.js $srcdir/$2 $dstdir/$2

relative_srcdir=${srcdir/$staging_rootdir/"$site/"}
relative_dstdir=${dstdir/$dist_rootdir/"$site/"}

node --no-warnings /home/staging/tools/promote/check_r2_assets.mjs $staging_bucket/$relative_srcdir/$2 $prod_bucket/$relative_dstdir/$2

while true; do
  echo -n "Are you sure you want to promote the $2 assets? [y/n] "
  yorn=""
  read yorn

  if [ "${yorn}" == "n" ]; then
    echo "Bailing out ..."
    exit 1
  fi

  if [ "${yorn}" == "y" ]; then
      . ${__dirname}/_promote.sh $site $2
      nodejs-latest-linker /home/dist/${site}/release/ /home/dist/${site}/docs/
    break
  fi
done
