#!/bin/bash

set -e

site=$1

if [ "X$site" != "Xiojs" ] && [ "X$site" != "Xnodejs" ]; then
  echo "Usage: upload_to_cloudflare.sh < iojs | nodejs > <version>"
  exit 1
fi

if [ "X$2" == "X" ]; then
  echo "Usage: upload_to_cloudflare.sh < iojs | nodejs > <version>"
  exit 1
fi

if [ -z ${dstdir+x} ]; then
  echo "\$dstdir is not set"
  exit 1
fi
if [ -z ${dist_rootdir+x} ]; then
  echo "\$dist_rootdir is not set"
  exit 1
fi
if [ -z ${prod_bucket+x} ]; then
  echo "\$prod_bucket is not set"
  exit 1
fi
if [ -z ${staging_bucket+x} ]; then
  echo "\$staging_bucket is not set"
  exit 1
fi

relative_srcdir=${srcdir/$staging_rootdir/"$site/"}
relative_dstdir=${dstdir/$dist_rootdir/"$site/"}
tmpversion=$2

rclone copy $staging_bucket/$relative_srcdir/$tmpversion/ $prod_bucket/$relative_dstdir/$tmpversion/
rclone copyto $staging_bucket/$relative_dstdir/index.json $prod_bucket/$relative_dstdir/index.json
rclone copyto $staging_bucket/$relative_dstdir/index.tab $prod_bucket/$relative_dstdir/index.tab
