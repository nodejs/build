#!/usr/bin/env bash

. /home/staging/promote/settings

dstdir=$release_dstdir

if [ "X${1}" == "X" ]; then
  echo "Please provide a version string"
  exit 1
fi

/home/staging/promote/_resha.sh $dstdir $1
