#!/usr/bin/env bash

if [ ! -f /root/.jenkins_credentials ]; then
  echo "Add credentials (user:token) to /root/.jenkins_credentials"
  exit 1
fi

if [ "x" == "x$1" ]; then
  echo "Pass URL to jenkins instance as first argument"
  exit 1
fi

HOST=$1
DAYS=30
ROOTDIR=/var/lib/jenkins/jobs
JOBS="$ROOTDIR/*/builds/"
MULTIJOBS="$ROOTDIR/*/configurations/axis-nodes/*/builds/"
CREDENTIALS=$(</root/.jenkins_credentials)
ssh -i /root/.ssh/nodejs_build_backup $HOST find "$JOBS" "$MULTIJOBS" -mindepth 1 -maxdepth 1 -type d -mtime +$DAYS -exec "rm -rf '{}' \;"
curl -X POST -q --user "$CREDENTIALS" https://$HOST/reload
