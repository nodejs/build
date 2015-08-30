#!/usr/bin/env bash

. /home/staging/promote/settings

srcdir=$nightly_srcdir
dstdir=$nightly_dstdir

. /home/staging/promote/_promote.sh

srcdir=$next_nightly_srcdir
dstdir=$next_nightly_dstdir

. /home/staging/promote/_promote.sh
