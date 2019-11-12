#!/bin/bash -ex

rm -rf src node_version.h.tar || true

source env.properties

set +x
export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $JENKINS_TMP_KEY"
set -x

# Retry once
git archive --format=tar --remote="$TEMP_REPO" $TEMP_BRANCH src/node_version.h -o node_version.h.tar ||
git archive --format=tar --remote="$TEMP_REPO" $TEMP_BRANCH src/node_version.h -o node_version.h.tar

tar xvf node_version.h.tar

# Same command also used by iojs+release
export NODEJS_MAJOR_VERSION=$(cat src/node_version.h | grep "#define NODE_MAJOR_VERSION" | awk '{ print $3}')

echo NODEJS_MAJOR_VERSION=$NODEJS_MAJOR_VERSION >> env.properties
