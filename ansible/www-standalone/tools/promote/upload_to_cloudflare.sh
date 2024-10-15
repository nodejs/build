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

gh workflow run promote-release.yml --repo nodejs/release-cloudflare-worker --field path=$relativedir/$tmpversion/ --field recursive=true
gh workflow run promote-release.yml --repo nodejs/release-cloudflare-worker --field path=$relativedir/index.json
gh workflow run promote-release.yml --repo nodejs/release-cloudflare-worker --field path=$relativedir/index.tab
