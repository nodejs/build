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

. ${__dirname}/_promote.sh $site $2

/home/dist/tools/latest-linker/latest-linker.js  /home/dist/${site}/release/
