#!/usr/bin/env bash

set -e

site=$1

__dirname="$(CDPATH= cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "X$site" != "Xiojs" ] && [ "X$site" != "Xnodejs" ]; then
  echo "Usage: promote_nightly.sh < iojs | nodejs >"
  exit 1
fi

. ${__dirname}/settings

srcdir=$nightly_srcdir
dstdir=$nightly_dstdir

. ${__dirname}/_promote.sh $site

srcdir=$next_nightly_srcdir
dstdir=$next_nightly_dstdir

. ${__dirname}/_promote.sh $site

srcdir=$rc_srcdir
dstdir=$rc_dstdir

. ${__dirname}/_promote.sh $site
