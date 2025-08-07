#!/bin/bash

set -e

site=$1

if [ "$site" != "iojs" ] && [ "$site" != "nodejs" ]; then
  echo "Usage: queue-cdn-purge.sh < iojs | nodejs > [reason]"
  exit 1
fi

umask 000
echo ${2:-unknown} >> /tmp/cdnpurge.$site
