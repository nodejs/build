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

relativedir=${dstdir/$dist_rootdir/"$site/"}
version=$2

aws s3 cp $dstdir/$version/ $destination_bucket/$relativedir/$version/ --endpoint-url=$cloudflare_endpoint --profile $cloudflare_profile --recursive
