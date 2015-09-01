#!/usr/bin/env bash

set -e

site=$1

__dirname="$(CDPATH= cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "X$site" != "Xiojs" ] && [ "X$site" != "Xnodejs" ]; then
  echo "Usage: promote_nightly.sh < iojs | nodejs > <version>"
  exit 1
fi

if [ "X$2" == "X" ]; then
  echo "Usage: promote_nightly.sh < iojs | nodejs > <version>"
  exit 1
fi

. ${__dirname}/settings

srcdir=$nightly_srcdir
dstdir=$nightly_dstdir

. ${__dirname}/_promote.sh $site

srcdir=$next_nightly_srcdir
dstdir=$next_nightly_dstdir

. ${__dirname}/_promote.sh $site
