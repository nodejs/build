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

. ${__dirname}/_promote.sh $site $2

nodejs-latest-linker /home/dist/${site}/release/ /home/dist/${site}/docs/
