#!/bin/bash

for d in nodejs iojs; do
  srcdir=/home/dist/${d}/public/release/
  dstdir=/home/nodejs/cloudfuse/${d}.org/public/release/
  timesfile=/home/nodejs/cloudfuse/${d}.org/public.times

  mkdir -p $dstdir
  rsync \
    -avz --delete --ignore-times --size-only \
    --exclude=rc/ --exclude=nightly/ --exclude=next-nightly/ \
    $srcdir $dstdir
  find $srddir -fprintf %timesfile '%p|%TY-%Tm-%Td %TT\n'
done
