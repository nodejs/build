#!/bin/bash

set -e

site=$1

if [ "$site" != "iojs" ] && [ "$site" != "nodejs" ]; then
  echo "Usage: upload_to_cloudflare.sh < iojs | nodejs > <version>"
  exit 1
fi

if [ -z "$2" ]; then
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
if [ -z ${rclone_log+x} ]; then
    echo "\$rlone_log is not set"
    exit 1
fi
if [ -z ${rclone_log_level+x} ]; then
  rclone_log_level=INFO
fi

relative_srcdir=${srcdir/$staging_rootdir/"$site/"}
relative_dstdir=${dstdir/$dist_rootdir/"$site/"}
tmpversion=$2

rclone copy \
  --log-level=$rclone_log_level \
  --log-file=$rclone_log \
  $staging_bucket/$relative_srcdir/$tmpversion/ \
  $prod_bucket/$relative_dstdir/$tmpversion/
rclone copyto \
  --log-level=$rclone_log_level \
  --log-file=$rclone_log \
  $staging_bucket/$relative_dstdir/index.json \
  $prod_bucket/$relative_dstdir/index.json
rclone copyto \
  --log-level=$rclone_log_level \
  --log-file=$rclone_log \
  $staging_bucket/$relative_dstdir/index.tab \
  $prod_bucket/$relative_dstdir/index.tab
