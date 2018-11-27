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
dirmatch=$nightly_dirmatch

. ${__dirname}/_promote.sh $site

srcdir=$next_nightly_srcdir
dstdir=$next_nightly_dstdir
dirmatch=$next_nightly_dirmatch

. ${__dirname}/_promote.sh $site

srcdir=$rc_srcdir
dstdir=$rc_dstdir
dirmatch=$rc_dirmatch

. ${__dirname}/_promote.sh $site

srcdir=$test_srcdir
dstdir=$test_dstdir
dirmatch=$test_dirmatch

. ${__dirname}/_promote.sh $site

srcdir=$v8_canary_srcdir
dstdir=$v8_canary_dstdir
dirmatch=$v8_canary_dirmatch

. ${__dirname}/_promote.sh $site

srcdir=$chakracore_nightly_srcdir
dstdir=$chakracore_nightly_dstdir
dirmatch=$chakracore_nightly_dirmatch

. ${__dirname}/_promote.sh $site

srcdir=$chakracore_rc_srcdir
dstdir=$chakracore_rc_dstdir
dirmatch=$chakracore_rc_dirmatch

. ${__dirname}/_promote.sh $site

srcdir=$chakracore_release_srcdir
dstdir=$chakracore_release_dstdir
dirmatch=$chakracore_release_dirmatch

. ${__dirname}/_promote.sh $site
