#!/bin/bash

set -e

site=$1

if [ "X$site" != "Xiojs" ] && [ "X$site" != "Xnodejs" ]; then
  echo "Usage: queue-cdn-purge.sh < iojs | nodejs >"
  exit 1
fi

umask 000
touch /tmp/cdnpurge.$site
