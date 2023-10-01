#!/usr/bin/env bash

site=$1

__dirname="$(CDPATH= cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "X$site" != "Xiojs" ] && [ "X$site" != "Xnodejs" ]; then
  echo "Usage: resha_release.sh < iojs | nodejs > <version>"
  exit 1
fi

if [ "X$2" == "X" ]; then
  echo "Usage: resha_release.sh < iojs | nodejs > <version>"
  exit 1
fi

. ${__dirname}/settings

dstdir=$release_dstdir

if [ "X${1}" == "X" ]; then
  echo "Please provide a version string"
  exit 1
fi

${__dirname}/_resha.sh $site $dstdir $2

. ${__dirname}/upload_to_cloudflare.sh $site $2

/home/nodejs/queue-cdn-purge.sh $site resha_release
