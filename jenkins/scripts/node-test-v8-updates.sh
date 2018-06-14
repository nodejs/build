#/bin/bash -ex

###
# node-test-v8-updates
# Run specific Node.js tests for V8 updates (from test/v8-updates). These tests
# are inteded to be run in Ubuntu 16.04 machines.
###

rm -rf build
git clone https://github.com/nodejs/build.git

. ./build/jenkins/scripts/node-test-commit-pre.sh

make run-ci CI_JS_SUITES="v8-updates" CI_NATIVE_SUITES="" CI_DOC=""
