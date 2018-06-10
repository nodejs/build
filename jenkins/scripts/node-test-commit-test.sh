#/bin/bash

rm -rf build
git clone https://github.com/nodejs/build.git

. ./build/jenkins/scripts/node-test-commit-pre.sh

if test $IGNORE_FLAKY_TESTS = "true"
then
  FLAKY_TESTS_MODE=dontcare
else
  FLAKY_TESTS_MODE=run
fi
echo FLAKY_TESTS_MODE=$FLAKY_TESTS_MODE

echo $NODE_NAME

if [[ $NODE_NAME = *"aix"* ]]; then
  # Some of the tests require a file size limit that is greating that
  # string size limite (see https://github.com/nodejs/node/pull/16273#pullrequestreview-70282286)
  # Set the limit so the test can run
  # Disable for now as need more config to make it allowable
  #ulimit -f 4194304

  # LIBPATH must be set to /opt/freeware/lib for the git plugin to work, however
  # it must be unset for the build.  The ansible start script sets the libpath
  # so that when git runs its set, but we must unset it here otherwise it
  # causes the build to find the 32 bit stdc++ library instead of the 64 bit one
  # that we need when running binaries (like mksnapshot) since our target is 64 bit
  unset LIBPATH
  echo LIBPATH:$LIBPATH
fi

. ./build/jenkins/scripts/select-compiler.sh

if [[ $NODE_NAME = *"aix"* ]]; then
  MAKE=gmake
elif [ -x "$(command -v make)" ] ; then
  MAKE=make
else
  MAKE=gmake
fi

getconf _NPROCESSORS_ONLN 2> /dev/null
if [ $? -eq 0 ] ; then
  JOB_COUNT=$(getconf _NPROCESSORS_ONLN)
elif [[ $NODE_NAME = *"smartos"* ]] ; then
  JOB_COUNT=4
elif [[ $NODE_NAME = *"aix"* ]] ; then
  JOB_COUNT=5
else
  JOB_COUNT=$(getconf NPROCESSORS_ONLN)
fi

MAKE_ARGS="-j $JOB_COUNT"

CONFIG_FLAGS=""

if [ $HOSTNAME = *"ppc64--be"* ] || [ $HOSTNAME = *"ppc64--le"* ] || [[ $NODE_NAME = *"aix"* ]]; then
  CONFIG_FLAGS="$CONFIG_FLAGS --dest-cpu=ppc64"
fi

if test $nodes = "ubuntu1604_sharedlibs_openssl110_x64"; then
  export LD_LIBRARY_PATH=${OPENSSL110DIR}/lib/
  export DYLD_LIBRARY_PATH=${OPENSSL110DIR}/lib/
  export PATH=${OPENSSL110DIR}/bin/:$PATH

  CONFIG_FLAGS="$CONFIG_FLAGS --shared-openssl --shared-openssl-includes=${OPENSSL110DIR}/include/ --shared-openssl-libpath=${OPENSSL110DIR}/lib/"
  MAKE_ARGS="$MAKE_ARGS --output-sync=target"
elif test $nodes = "ubuntu1604_sharedlibs_fips20_x64"; then
  CONFIG_FLAGS="$CONFIG_FLAGS --openssl-fips=$FIPS20DIR"
  MAKE_ARGS="$MAKE_ARGS --output-sync=target"
elif test $nodes = "ubuntu1604_sharedlibs_debug_x64"; then
  # see https://github.com/nodejs/node/issues/17016
  sed -i 's/\[\$system==linux\]/[$system==linux]\ntest-error-reporting : PASS, FLAKY/g' test/parallel/parallel.status
  # see https://github.com/nodejs/node/issues/17017
  sed -i 's/\[\$system==linux\]/[$system==linux]\ntest-inspector-async-stack-traces-promise-then : PASS, FLAKY/g' test/sequential/sequential.status
  # see https://github.com/nodejs/node/issues/17018
  sed -i 's/\[\$system==linux\]/[$system==linux]\ntest-inspector-contexts : PASS, FLAKY/g' test/sequential/sequential.status

  CONFIG_FLAGS="$CONFIG_FLAGS --debug"
  MAKE_ARGS="$MAKE_ARGS --output-sync=target"
elif test $nodes = "ubuntu1604_sharedlibs_openssl102_x64"; then
  export LD_LIBRARY_PATH=${OPENSSL102DIR}/lib/
  export DYLD_LIBRARY_PATH=${OPENSSL102DIR}/lib/
  export PATH=${OPENSSL102DIR}/bin/:$PATH

  CONFIG_FLAGS="$CONFIG_FLAGS --shared-openssl --shared-openssl-includes=${OPENSSL102DIR}/include/ --shared-openssl-libpath=${OPENSSL102DIR}/lib/"
  MAKE_ARGS="$MAKE_ARGS --output-sync=target"
elif test $nodes = "ubuntu1604_sharedlibs_zlib_x64"; then
  export LD_LIBRARY_PATH=${ZLIB12DIR}/lib/
  export DYLD_LIBRARY_PATH=${ZLIB12DIR}/lib/

  CONFIG_FLAGS="$CONFIG_FLAGS --shared-zlib --shared-zlib-includes=${ZLIB12DIR}/include/ --shared-zlib-libpath=${ZLIB12DIR}/lib/" \
  MAKE_ARGS="$MAKE_ARGS --output-sync=target"
elif test $nodes = "ubuntu1604_sharedlibs_openssl111_x64"; then
  export LD_LIBRARY_PATH=${OPENSSL111DIR}/lib/
  export DYLD_LIBRARY_PATH=${OPENSSL111DIR}/lib/
  export PATH=${OPENSSL111DIR}/bin/:$PATH

  CONFIG_FLAGS="$CONFIG_FLAGS --shared-openssl --shared-openssl-includes=${OPENSSL111DIR}/include/ --shared-openssl-libpath=${OPENSSL111DIR}/lib/" \
  MAKE_ARGS="$MAKE_ARGS --output-sync=target"
elif test $nodes = "ubuntu1604_sharedlibs_withoutintl_x64"; then
  CONFIG_FLAGS="$CONFIG_FLAGS --without-intl"
  MAKE_ARGS="$MAKE_ARGS --output-sync=target"
elif test $nodes = "ubuntu1604_sharedlibs_withoutssl_x64"; then
  CONFIG_FLAGS="$CONFIG_FLAGS --without-ssl"
  MAKE_ARGS="$MAKE_ARGS --output-sync=target"
elif test $nodes = "ubuntu1604_sharedlibs_shared_x64"; then
  CONFIG_FLAGS="$CONFIG_FLAGS --shared"
  MAKE_ARGS="$MAKE_ARGS --output-sync=target"
fi

if test $nodes = "ubuntu1604_sharedlibs_debug_x64"; then
  MAKE_TARGET=build-ci
else
  MAKE_TARGET=run-ci
fi

if ! [[ $MAKE_ARGS = *"--output-sync"* ]]; then
  if [ $(make -v | grep 'GNU Make 4' -c) -ne 0 ]; then
    MAKE_ARGS="$MAKE_ARGS --output-sync=target"
  fi
fi

exec_cmd="
  NODE_TEST_DIR='${HOME}/node-tmp'
  NODE_COMMON_PORT='15000'
  PYTHON='python'
  FLAKY_TESTS='$FLAKY_TESTS_MODE'
  CONFIG_FLAGS='$CONFIG_FLAGS'
  $MAKE $MAKE_TARGET $MAKE_ARGS
"

if test $nodes = "centos6-64-gcc48"; then
  exec_cmd=". /opt/rh/devtoolset-2/enable; $exec_cmd"
elif [[ "$nodes" =~ centos[67]-(arm)?64-gcc6 ]]; then
  exec_cmd=". /opt/rh/devtoolset-6/enable; $exec_cmd"
fi

echo $exec_cmd
V=1

$SHELL -xec "$exec_cmd"

if test $nodes = "ubuntu1604_sharedlibs_openssl110_x64"; then
  OPENSSL_VERSION="$(out/Release/node -pe process.versions | grep openssl)"
  echo "OpenSSL Version: $OPENSSL_VERSION"
  if [ X"$(echo $OPENSSL_VERSION | grep 1\.1\.0)" = X"" ]; then
    FAIL_MSG="Not built with OpenSSL 1.1.0, exiting"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi
elif test $nodes = "ubuntu1604_sharedlibs_fips20_x64"; then
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

  NODE_VERSION="$(out/Release/node --version | awk -F "." '{print $1}' | sed 's/v//g')"

  # now run the tests with fips on if we are a version later than 5.X
  if [ "$NODE_VERSION" -gt "5" ]; then
    NODE_TEST_DIR=${HOME}/node-tmp PYTHON=python FLAKY_TESTS=$FLAKY_TESTS_MODE TEST_CI_ARGS="--node-args --enable-fips" make test-ci -j $JOBS
    mv test.tap test-fips-on.tap
  fi
elif test $nodes = "ubuntu1604_sharedlibs_debug_x64"; then
  ls out/
  if ! [ -x out/Debug/node ]; then
    FAIL_MSG="No Debug executable"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi

  BUILD_TYPE="$(out/Debug/node -pe process.config.target_defaults.default_configuration)"
  echo "Build type: $BUILD_TYPE"
  if [ X"$BUILD_TYPE" != X"Debug" ]; then
    FAIL_MSG="Not built as Debug"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi

  python tools/test.py -j $JOBS -p tap --logfile test.tap \
    --mode=debug --flaky-tests=$FLAKY_TESTS_MODE \
    async-hooks default known_issues

  # Clean up any leftover processes, error if found.
  ps awwx | grep Debug/node | grep -v grep
  ps awwx | grep Debug/node | grep -v grep | awk '{print $$1}' | xargs -rl kill || true
elif test $nodes = "ubuntu1604_sharedlibs_openssl102_x64"; then
  OPENSSL_VERSION="$(out/Release/node -pe process.versions | grep openssl)"
  echo "OpenSSL Version: $OPENSSL_VERSION"
  if [ X"$(echo $OPENSSL_VERSION | grep 1\.0\.2)" = X"" ]; then
    FAIL_MSG="Not built with OpenSSL 1.0.2, exiting"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi
elif test $nodes = "ubuntu1604_sharedlibs_zlib_x64"; then
  ZLIB_VERSION="$(out/Release/node -pe process.versions | grep zlib)"
  echo "zlib Version: $ZLIB_VERSION"
  if [ X"$(echo $ZLIB_VERSION | grep 1\.2\.11)" = X"" ]; then
    FAIL_MSG="Not built with zlib 1.2.11, exiting"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi
elif test $nodes = "ubuntu1604_sharedlibs_openssl111_x64"; then
  OPENSSL_VERSION="$(out/Release/node -pe process.versions | grep openssl)"
  echo "OpenSSL Version: $OPENSSL_VERSION"
  if [ X"$(echo $OPENSSL_VERSION | grep 1\.1\.1)" = X"" ]; then
    FAIL_MSG="Not built with OpenSSL 1.1.1, exiting"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi
elif test $nodes = "ubuntu1604_sharedlibs_withoutintl_x64"; then
  INTL_OBJECT="$(out/Release/node -pe 'typeof Intl')"
  echo "Intl object type: $INTL_OBJECT"
  if [ X"$INTL_OBJECT" != X"undefined" ]; then
    FAIL_MSG="Has an Intl object, exiting"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi
  PROCESS_VERSIONS_INTL="$(out/Release/node -pe process.versions.icu)"
  echo "process.versions.icu: $PROCESS_VERSIONS_INTL"
  if [ X"$PROCESS_VERSIONS_INTL" != X"undefined" ]; then
    FAIL_MSG="process.versions.icu not undefined, exiting"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi
elif test $nodes = "ubuntu1604_sharedlibs_withoutssl_x64"; then
  HAS_OPENSSL="$(out/Release/node -p 'Boolean(process.versions.openssl)')"
  echo "Has OpenSSL: $HAS_OPENSSL"
  if [ X"$HAS_OPENSSL" != X"false" ]; then
    FAIL_MSG="Has an OpenSSL, exiting"
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi
  REQUIRE_CRYPTO="$(out/Release/node -p 'require("crypto")')"
  if test $? -eq 0; then
    FAIL_MSG='require("crypto") did not fail, exiting'
    echo $FAIL_MSG
    echo "1..1" > ${WORKSPACE}/test.tap
    echo "not ok 1 $FAIL_MSG" >> ${WORKSPACE}/test.tap
    exit -1
  fi
fi

. ./build/jenkins/scripts/node-test-commit-diagnostics.sh after
