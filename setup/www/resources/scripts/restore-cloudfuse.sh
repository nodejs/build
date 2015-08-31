#!/bin/bash

for d in nodejs iojs; do
  srcdir=/home/nodejs/cloudfuse/${d}.org/public/release/
  dstdir=/home/dist/${d}/release/
  timesfile=/home/nodejs/cloudfuse/${d}.org/public.times

  mkdir -p $dstdir
  rsync -avz $srcdir $dstdir --ignore-times --size-only
  cat $timesfile | awk -F'|' '{ print "touch -d\""$2"\" \""$1"\"" }'
  find $srddir -fprintf $timesfile '%p|%TY-%Tm-%Td %TT\n'
done
