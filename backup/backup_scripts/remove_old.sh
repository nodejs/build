#!/usr/bin/env bash

#
#./remove_old "ci-release.nodejs.org"
#

if [ ! -f /root/.jenkins_credentials ]; then
  echo "Add credentials (user:token) to /root/.jenkins_credentials"
  exit 1
fi

if [ "" == "$1" ]; then
  echo "Pass URL to jenkins instance as first argument"
  exit 1
fi

HOST=$1
DAYS=21
ROOTDIR=/var/lib/jenkins/jobs
REGEX="${ROOTDIR}/.*/builds/[0-9]+"
#JOBS="$ROOTDIR/*/builds/"
#MULTIJOBS="$ROOTDIR/*/configurations/axis-*/*/builds/"
CREDENTIALS=$(</root/.jenkins_credentials)
ssh -i /root/.ssh/nodejs_build_backup $HOST find "$ROOTDIR" -depth -type d -regex "$REGEX" -mtime +$DAYS -exec "rm -rf '{}' \;"
JENKINS_CRUMB=$(curl -sL --user "$CREDENTIALS" https://$HOST/'crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')
curl -X POST -q --user "$CREDENTIALS" -H "$JENKINS_CRUMB" https://$HOST/reload

