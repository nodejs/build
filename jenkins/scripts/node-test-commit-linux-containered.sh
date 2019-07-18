#!/bin/bash -ex

function setupEnvironment {
  FLAKY_TESTS_MODE=run
  if test $IGNORE_FLAKY_TESTS = "true"; then
    FLAKY_TESTS_MODE=dontcare
  fi
  echo "FLAKY_TESTS_MODE=$FLAKY_TESTS_MODE"

  if [ -z ${JOBS+x} ]; then
    JOBS=$(getconf _NPROCESSORS_ONLN)
  fi
  echo "JOBS=$JOBS"

  if [ -z ${NODEJS_MAJOR_VERSION+x} ]; then
    NODE_VERSION="$(python tools/getnodeversion.py)"
    NODEJS_MAJOR_VERSION="$(echo "$NODE_VERSION" | cut -d . -f 1)"
  fi

  export CCACHE_BASEDIR=$PWD
  export CC="ccache gcc"
  export CXX="ccache g++"
  echo "gcc version:"
  g++ -v
}

function runCiWithConfig {
  local flags="$1"
  PYTHON=python \
    NODE_TEST_DIR=${HOME}/node-tmp \
    FLAKY_TESTS=$FLAKY_TESTS_MODE \
    CONFIG_FLAGS="$CONFIG_FLAGS $flags" \
    make run-ci -j $JOBS
}

function buildCiWithConfig {
  local flags="$1"
  PYTHON=python \
    NODE_TEST_DIR=${HOME}/node-tmp \
    FLAKY_TESTS=$FLAKY_TESTS_MODE \
    CONFIG_FLAGS="$CONFIG_FLAGS $flags" \
    make build-ci -j $JOBS
}

function testCiWithArgs {
  local args="$1"
  PYTHON=python \
    NODE_TEST_DIR=${HOME}/node-tmp \
    FLAKY_TESTS=$FLAKY_TESTS_MODE \
    TEST_CI_ARGS="$TEST_CI_ARGS $args" \
    make test-ci -j $JOBS
}

###--- ubuntu1604_sharedlibs_openssl102_x64 ---###
function runOpenSSL102 {
  export LD_LIBRARY_PATH=${OPENSSL102DIR}/lib/
  export DYLD_LIBRARY_PATH=${OPENSSL102DIR}/lib/
  export PATH=${OPENSSL102DIR}/bin/:$PATH

  runCiWithConfig "--shared-openssl --shared-openssl-includes=${OPENSSL102DIR}/include/ --shared-openssl-libpath=${OPENSSL102DIR}/lib/"

  # Sanity check that we have compiled the correct OpenSSL into the binary
  OPENSSL_VERSION="$(out/Release/node -pe process.versions | grep openssl)"
  echo "OpenSSL Version: $OPENSSL_VERSION"
  if [ X"$(echo $OPENSSL_VERSION | grep 1\.0\.2)" = X"" ]; then
    FAIL_MSG="Not built with OpenSSL 1.0.2, exiting"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi
}

###--- ubuntu1604_sharedlibs_openssl110_x64 ---###
function runOpenSSL110 {
  export LD_LIBRARY_PATH=${OPENSSL110DIR}/lib/
  export DYLD_LIBRARY_PATH=${OPENSSL110DIR}/lib/
  export PATH=${OPENSSL110DIR}/bin/:$PATH

  runCiWithConfig "--shared-openssl --shared-openssl-includes=${OPENSSL110DIR}/include/ --shared-openssl-libpath=${OPENSSL110DIR}/lib/"

  # Sanity check that we have compiled the correct OpenSSL into the binary
  OPENSSL_VERSION="$(out/Release/node -pe process.versions | grep openssl)"
  echo "OpenSSL Version: $OPENSSL_VERSION"
  if [ X"$(echo $OPENSSL_VERSION | grep 1\.1\.0)" = X"" ]; then
    FAIL_MSG="Not built with OpenSSL 1.1.0, exiting"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi
}

###--- ubuntu1604_sharedlibs_openssl111_x64 ---###
function runOpenSSL111 {
  export LD_LIBRARY_PATH=${OPENSSL111DIR}/lib/
  export DYLD_LIBRARY_PATH=${OPENSSL111DIR}/lib/
  export PATH=${OPENSSL111DIR}/bin/:$PATH

  runCiWithConfig "--shared-openssl --shared-openssl-includes=${OPENSSL111DIR}/include/ --shared-openssl-libpath=${OPENSSL111DIR}/lib/"

  # Sanity check that we have compiled the correct OpenSSL into the binary
  OPENSSL_VERSION="$(out/Release/node -pe process.versions | grep openssl)"
  echo "OpenSSL Version: $OPENSSL_VERSION"
  if [ X"$(echo $OPENSSL_VERSION | grep 1\.1\.1)" = X"" ]; then
    FAIL_MSG="Not built with OpenSSL 1.1.1, exiting"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi
}

###--- ubuntu1604_sharedlibs_fips20_x64 ---###
function runFips20 {
  runCiWithConfig "--openssl-fips=$FIPS20DIR"

  # Sanity check that we actually built in FIPS capable mode. We expect to see
  # "-fips" in the openssl version.  For example: "openssl: '1.0.2d-fips"
  OPENSSL_VERSION="$(out/Release/node -pe process.versions | grep openssl)"
  echo "OpenSSL Version: $OPENSSL_VERSION"
  FIPS_CAPABLE="`echo "$OPENSSL_VERSION" | grep fips`"
  if [ X"$FIPS_CAPABLE" = X"" ]; then
    FAIL_MSG="Not built as FIPS capable, exiting"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi

  mv test.tap test-fips-base.tap

  testCiWithArgs "--node-args --enable-fips"
  mv test.tap test-fips-on.tap
}

###--- ubuntu1604_sharedlibs_debug_x64 ---###
function runDebug {
  if [ "$NODEJS_MAJOR_VERSION" -lt "10" ]; then
    # Needed for Node < 10, see https://github.com/nodejs/node/issues/17016
    sed -i 's/\[\$system==linux\]/[$system==linux]\ntest-error-reporting : PASS, FLAKY/g' test/parallel/parallel.status
    # TODO: can remove this for Node 8+ I think
    # see https://github.com/nodejs/node/issues/17017
    # sed -i 's/\[\$system==linux\]/[$system==linux]\ntest-inspector-async-stack-traces-promise-then : PASS, FLAKY/g' test/sequential/sequential.status
    # Needed for Node < 10, see https://github.com/nodejs/node/issues/17018
    sed -i 's/\[\$system==linux\]/[$system==linux]\ntest-inspector-contexts : PASS, FLAKY/g' test/sequential/sequential.status
  fi

  buildCiWithConfig "--debug"

  # Sanity check that we actually have a debug executable
  if ! [ -x out/Debug/node ]; then
    FAIL_MSG="No Debug executable"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    echo "  ---"
    echo "  duration_ms: 0"
    echo "  ..."
    exit 0
  fi

  # Sanity check that the apparent debug executable was built as debug
  BUILD_TYPE="$(out/Debug/node -pe process.config.target_defaults.default_configuration)"
  echo "Build type: $BUILD_TYPE"
  if [ X"$BUILD_TYPE" != X"Debug" ]; then
    FAIL_MSG="Not built as Debug"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    echo "  ---"
    echo "  duration_ms: 0"
    echo "  ..."
    exit 0
  fi

  if [ "$NODEJS_MAJOR_VERSION" -lt "10" ]; then
    # Run tests, emulate test-ci in Makefile but with --mode=debug
    python tools/test.py -j $JOBS -p tap --logfile test.tap \
      --mode=debug --flaky-tests=${FLAKY_TESTS_MODE} \
      default addons js-native-api node-api doctool
  else
    # Runs the proper mode in Node >= 10
    testCiWithArgs ""
  fi

  # Clean up any leftover processes, error if found.
  ps awwx | grep Debug/node | grep -v grep || true
  ps awwx | grep Debug/node | grep -v grep | awk '{print $$1}' | xargs -rl kill || true
}

###--- ubuntu1604_sharedlibs_zlib_x64 ---###
function runZlib {
  export LD_LIBRARY_PATH=${ZLIB12DIR}/lib/
  export DYLD_LIBRARY_PATH=${ZLIB12DIR}/lib/

  runCiWithConfig "--shared-zlib --shared-zlib-includes=${ZLIB12DIR}/include/ --shared-zlib-libpath=${ZLIB12DIR}/lib/"

  # Sanity check that we have compiled the shared zlib version into the binary
  ZLIB_VERSION="$(out/Release/node -pe process.versions | grep zlib)"
  echo "zlib Version: $ZLIB_VERSION"
  if [ X"$(echo $ZLIB_VERSION | grep 1\.2\.11)" = X"" ]; then
    FAIL_MSG="Not built with zlib 1.2.11, exiting"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi
}

###--- ubuntu1604_sharedlibs_withoutintl_x64 ---###
function runWithoutIntl {
  runCiWithConfig "--without-intl"

  # Sanity check that `Intl` is `undefined`
  INTL_OBJECT="$(out/Release/node -pe 'typeof Intl')"
  echo "Intl object type: $INTL_OBJECT"
  if [ X"$INTL_OBJECT" != X"undefined" ]; then
    FAIL_MSG="Has an Intl object, exiting"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi

  # Sanity check that there is no ICU compiled into the binary
  PROCESS_VERSIONS_INTL="$(out/Release/node -pe process.versions.icu)"
  echo "process.versions.icu: $PROCESS_VERSIONS_INTL"
  if [ X"$PROCESS_VERSIONS_INTL" != X"undefined" ]; then
    FAIL_MSG="process.versions.icu not undefined, exiting"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi
}

###--- ubuntu1604_sharedlibs_withoutssl_x64 ---###
function runWithoutSsl {
  runCiWithConfig "--without-ssl"

  # Sanity check that there is no OpenSSL compiled into the binaruy
  HAS_OPENSSL="$(out/Release/node -p 'Boolean(process.versions.openssl)')"
  echo "Has OpenSSL: $HAS_OPENSSL"
  if [ X"$HAS_OPENSSL" != X"false" ]; then
    FAIL_MSG="Has an OpenSSL, exiting"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi

  # Sanity check that there is no 'crypto' core module available
  out/Release/node -p 'require("crypto")' || REQUIRE_CRYPTO="no crypto"
  if [ "$REQUIRE_CRYPTO" != "no crypto" ]; then
    FAIL_MSG='require("crypto") did not fail, exiting'
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi
}

###--- ubuntu1604_sharedlibs_shared_x64 ---###
function runShared {
  runCiWithConfig "--shared"
}

### MAIN ###

setupEnvironment

if [[ "$label" =~ _openssl102_ ]]; then
  runOpenSSL102
elif [[ "$label" =~ _openssl110_ ]]; then
  runOpenSSL110
elif [[ "$label" =~ _openssl111_ ]]; then
  runOpenSSL111
elif [[ "$label" =~ _fips20_ ]]; then
  runFips20
elif [[ "$label" =~ _debug_ ]]; then
  runDebug
elif [[ "$label" =~ _zlib_ ]]; then
  runZlib
elif [[ "$label" =~ _withoutintl_ ]]; then
  runWithoutIntl
elif [[ "$label" =~ _withoutssl_ ]]; then
  runWithoutSsl
elif [[ "$label" =~ _shared_ ]]; then
  runShared
fi
