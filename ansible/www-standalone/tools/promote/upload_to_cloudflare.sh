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
if [ -z ${staging_bucket+x} ]; then
  echo "\$staging_bucket is not set"
  exit 1
fi
if [ -z ${dist_bucket+x} ]; then
  echo "\$dist_bucket is not set"
  exit 1
fi
if [ -z ${cloudflare_endpoint+x} ]; then
  echo "\$cloudflare_endpoint is not set"
  exit 1
fi
if [ -z ${cloudflare_profile+x} ]; then
  echo "\$cloudflare_profile is not set"
  exit 1
fi

relativedir=${dstdir/$dist_rootdir/"$site/"}
tmpversion=$2

# Due to R2 limitations, `aws s3 cp` and `aws s3 sync` only succeed in copying
# different sets of files across. Fortunately the sets are disjoint, so running
# both commands (ignoring errors) will copy all the files across.
aws s3 cp $staging_bucket/$relativedir/$tmpversion/ $dist_bucket/$relativedir/$tmpversion/ --endpoint-url=$cloudflare_endpoint --profile $cloudflare_profile --recursive --no-follow-symlinks --copy-props none || true
aws s3 sync $staging_bucket/$relativedir/$tmpversion/ $dist_bucket/$relativedir/$tmpversion/ --endpoint-url=$cloudflare_endpoint --profile $cloudflare_profile --no-follow-symlinks || true
aws s3 cp $staging_bucket/$relativedir/index.json $dist_bucket/$relativedir/index.json --endpoint-url=$cloudflare_endpoint --profile $cloudflare_profile
aws s3 cp $staging_bucket/$relativedir/index.tab $dist_bucket/$relativedir/index.tab --endpoint-url=$cloudflare_endpoint --profile $cloudflare_profile
