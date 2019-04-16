#!/bin/bash

set -e

pidof -s -o '%PPID' -x $(basename $0) > /dev/null 2>&1 && \
  echo "$(basename $0) already running" && \
  exit 1

cd /home/nodejs/unofficial-builds
git reset --hard
git clean -fdx
git fetch origin
git checkout origin/master

bash -c ./bin/deploy.sh
