#/bin/bash -ex

###
# node-test-v8-updates
# Run specific Node.js tests for V8 updates (from test/v8-updates). These tests
# are inteded to be run in Ubuntu 16.04 machines.
###

FLAKY_TESTS_MODE=run
if test $IGNORE_FLAKY_TESTS = "true"; then
  FLAKY_TESTS_MODE=dontcare
fi

echo FLAKY_TESTS_MODE=$FLAKY_TESTS_MODE

export JOBS=$(getconf _NPROCESSORS_ONLN)

MAKE_ARGS="--output-sync=target -j $JOBS CI_JS_SUITES='v8-updates' CI_NATIVE_SUITES='' CI_DOC=''"

NODE_TEST_DIR=${HOME}/node-tmp \
PYTHON=python \
FLAKY_TESTS=$FLAKY_TESTS_MODE \
V=1 \
make run-ci $MAKE_ARGS
