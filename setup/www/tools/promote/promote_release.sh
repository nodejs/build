#!/usr/bin/env bash

. /home/staging/promote/settings

srcdir=$release_srcdir
dstdir=$release_dstdir

. /home/staging/promote/_promote.sh $1

latest=$(ls $dstdir | grep ^v | tail -1)
rm -f ${dstdir}/latest
ln -s $latest ${dstdir}/latest
