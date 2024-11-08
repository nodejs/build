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

srcdir=$release_srcdir
dstdir=$release_dstdir

if [ "X${1}" == "X" ]; then
  echo "Please provide a version string"
  exit 1
fi

${__dirname}/_resha.sh $site $srcdir $dstdir $2

# https://github.com/nodejs/build/issues/3508
# Output from upload_to_cloudflare.sh must not go to stdout to prevent
# breaking the release.sh script.
logfile="${__dirname}/logs/cloudflare.log"
date >> "${logfile}"
. ${__dirname}/upload_to_cloudflare.sh $site $2 >> "${logfile}" 2>&1

/home/nodejs/queue-cdn-purge.sh $site resha_release
