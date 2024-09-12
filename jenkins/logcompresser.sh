#!/bin/bash

# Script invoked from cron on ci.nodejs.org to compress older on disk log files.
JENKINS_HOME=/var/lib/jenkins/jobs
find ${JENKINS_HOME} -type f -name "log" -path "./node*/*" -mtime +7 -print0|xargs -0 gzip -9v '{}'

