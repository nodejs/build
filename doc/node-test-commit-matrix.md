# node-test-commit matrix

This is a close approximation of the standard node-test-commit invocation, as called by node-test-pull-request in <ci.nodejs.org>. The work is performed by sub-jobs and sub-sub-jobs, mostly invoking `make run-ci` but some invoke custom configure, build and test commands, as indicated below. Differentiation by Node.js version is performed primarily by the [VersionSelectorScript](../jenkins/scripts/VersionSelectorScript.groovy) and some version selection is performed by logic contained within the job config (some of which is reproduced below).

This is assumed correct as of the date of last commit. If you notice a discrepancy with actual ci.nodejs.org runs, please update this document.

**node-test-commit**
  - **node-test-linter**
    1. `make lint-md-build`
    1. `make lint-py-build`
    1. `make lint-py PYTHON=python3`
    1. `make lint-ci PYTHON=python2`
  - **node-test-commit-freebsd**
    - freebsd10-64 (Node < 12)
    - freebsd11-x64
  - **node-test-commit-linux**
    - alpine-last-latest-x64
    - alpine-latest-x64
    - centos5-32 (Node < 8)
    - centos5-64 (Node < 8)
    - centos6-64-gcc48 (Node < 10)
    - centos6-64-gcc6 (Node >= 10)
    - centos7-64-gcc48 (Node < 10)
    - centos7-64-gcc6 (Node >= 10)
    - debian8-64
    - debian8-x86 (Node < 10)
    - debian9-64
    - fedora-last-latest-x64
    - fedora-latest-x64
    - ubuntu1204-64 (Node < 10)
    - ubuntu1404-32 (Node < 10)
    - ubuntu1404-64 (Node < 12)
    - ubuntu1604-32 (Node < 10)
    - ubuntu1604-64
    - ubuntu1804-64
  - **node-test-commit-osx**
    - osx1010 (Node < 11)
    - osx1011
  - **node-test-commit-plinux**
    - centos7-ppcle (Node >= 12)
    - ppcbe-ubuntu1404 (Node < 8)
    - ppcle-ubuntu1404 (Node < 13)
  - **node-test-commit-smartos**
    - smartos14-32 (Node < 8)
    - smartos14-64 (Node < 8)
    - smartos15-64 (Node >= 8 < 10)
    - smartos16-64 (Node >= 8 < 12)
    - smartos17-64 (Node >= 10 < 12)
    - smartos18-64 (Node >= 12)
  - **node-test-commit-windows-fanned**
    - **node-compile-windows**
      * Combination Filter (structured as a conjunction of implications):
        - When `ENGINE!="ChakraCore"` exclude `*-arm`
        - When Node >= 6 exclude `win-vs2013*`
        - When Node >= 10 exclude `win-vs2015*` and `win-vcbt2015*`
        - When Node < 8 exclude `win-vs2017*`
        - When Node < 10 exclude `win-vs2017-x86`
      - win-vcbt2015 (Node < 10)
      - win-vs2015 (Node >= 6 < 10)
      - win-vs2015-arm (Node-ChakraCore)
      - win-vs2015-x86 (Node >= 6 < 10)
      - win-vs2017 (Node >= 8)
      - win-vs2017-arm (Node-ChakraCore)
      - win-vs2017-x86 (Node >= 10)
    - **node-test-binary-windows** (Node <= 10)
      * Combination Filter (structured as a conjunction of implications):
        - When Node < 10:
          - On `win10` run:
            - `COMPILED_BY=="vcbt2015"` always
          - On `win2008r2-vs2013` run:
            - `COMPILED_BY=="vs2013"` when Node < 6
            - `COMPILED_BY=="vs2015"` when Node >= 6 < 9
          - On `win2008r2-vs2017` run:
            - `COMPILED_BY=="vs2015"` when Node >= 9
          - On `win2012r2` run:
            - `COMPILED_BY=="vs2015"` always
            - `COMPILED_BY=="vs2015-x86"` always
          - On `win2016` run:
            - `COMPILED_BY=="vs2015"` when Node < 8
            - `COMPILED_BY=="vs2017"` when Node >= 8
        - When Node == 10:
          - On `win10` run `COMPILED_BY=="vs2017"`
          - On `win2008r2-vs2017` run `COMPILED_BY=="vs2017"`
          - On `win2012r2` run `COMPILED_BY=="vs2017-x86"`
          - On `win2016` run `COMPILED_BY=="vs2017"`
    - **node-test-binary-windows-2** (Node >= 11)
      * Combination Filter:
        - On `win10` run `COMPILED_BY=="vs2017"`
        - On `win2008r2-vs2017` run `COMPILED_BY=="vs2017"`
        - On `win2012r2` run `COMPILED_BY=="vs2017-x86"`
        - On `win2016` run `COMPILED_BY=="vs2017"`
  - **node-test-commit-linux-containered**
    - ubuntu1604_sharedlibs_debug_x64 
      1. `CONFIG_FLAGS="$CONFIG_FLAGS --debug" make build-ci -j $JOBS`
      1. `python tools/test.py -j $JOBS -p tap --logfile test.tap --mode=debug --flaky-tests=skip async-hooks default known_issues`
    - ubuntu1604_sharedlibs_fips20_x64 (Node < 10)
      1. `CONFIG_FLAGS="$CONFIG_FLAGS --openssl-fips=$FIPS20DIR" make run-ci -j $JOBS` (FIPS20DIR points to a pre-build of OpenSSL FIPS 2.0)
    - ubuntu1604_sharedlibs_openssl102_x64 (Node < 10)
      1. `CONFIG_FLAGS="$CONFIG_FLAGS --shared-openssl --shared-openssl-includes=${OPENSSL102DIR}/include/ --shared-openssl-libpath=${OPENSSL102DIR}/lib/" make run-ci -j $JOBS` (OPENSSL102DIR points to a pre-build of OpenSSL 1.0.2)
    - ubuntu1604_sharedlibs_openssl110_x64 (Node >= 9 < 12)
      1. `CONFIG_FLAGS="$CONFIG_FLAGS --shared-openssl --shared-openssl-includes=${OPENSSL110DIR}/include/ --shared-openssl-libpath=${OPENSSL110DIR}/lib/" make run-ci -j $JOBS` (OPENSSL110DIR points to a pre-build of OpenSSL 1.1.0)
    - ubuntu1604_sharedlibs_openssl111_x64 (Node >= 11)
      1. `CONFIG_FLAGS="$CONFIG_FLAGS --shared-openssl --shared-openssl-includes=${OPENSSL111DIR}/include/ --shared-openssl-libpath=${OPENSSL111DIR}/lib/" make run-ci -j $JOBS` (OPENSSL111DIR points to a pre-build of OpenSSL 1.1.1)
    - ubuntu1604_sharedlibs_shared_x64 (Node >= 10)
      1. `CONFIG_FLAGS="$CONFIG_FLAGS --shared" make run-ci -j $JOBS`
    - ubuntu1604_sharedlibs_withoutintl_x64 (Node >= 10)
      1. `CONFIG_FLAGS="$CONFIG_FLAGS --without-intl" make run-ci -j $JOBS`
    - ubuntu1604_sharedlibs_withoutssl_x64 (Node >= 11)
      1. `CONFIG_FLAGS="$CONFIG_FLAGS --without-ssl" make build-ci -j $JOBS`
    - ubuntu1604_sharedlibs_zlib_x64
      1. `CONFIG_FLAGS="$CONFIG_FLAGS --shared-zlib --shared-zlib-includes=${ZLIB12DIR}/include/ --shared-zlib-libpath=${ZLIB12DIR}/lib/" make run-ci -j $JOBS` (ZLIB12DIR points to a pre-build of zlib 1.2)
  - **node-test-commit-arm**
    - centos7-arm64-gcc48 (Node < 10)
    - centos7-arm64-gcc6 (Node >= 10)
    - debian7-docker-armv7 (Node < 10)
    - debian8-docker-armv7 (Node < 12)
    - debian9-docker-armv7 (Node >= 10)
    - ubuntu1604-arm64 
  - **node-test-commit-linuxone**
    - rhel72-s390x (Node >= 6)
  - **node-test-commit-aix**
    - aix61-ppc64 (Node >= 6)
  - **node-test-commit-arm-fanned**
    - **node-cross-compile**
      - cross-compiler-armv6-gcc-4.8 (Node < 10)
      - cross-compiler-armv6-gcc-4.9.4 (Node >= 10 < 12)
      - cross-compiler-armv7-gcc-4.8  (Node < 10)
      - cross-compiler-armv7-gcc-4.9.4 (Node >= 10 < 12)
      - cross-compiler-armv7-gcc-6 (Node >= 12)
    - **node-test-binary-arm & node-test-binary-arm-12+**
      - pi1-docker
        - debian7 (Node < 10)
        - debian8 (Node >= 10 < 12)
      - pi2-docker
        - debian7 (Node < 10)
        - debian8 (Node >= 10 < 12)
        - debian9 (Node >= 12)
      - pi3-docker
        - debian8 (Node < 10)
        - debian9 (Node >= 10)
  - **node-test-commit-custom-suites-freestyle**
    1. `make -j1 bench-addons-build`
    1. `make -j 4 build-ci`
    1. `python tools/test.py -j 4 -p tap --logfile test.tap --mode=release --flaky-tests=dontcare --worker`
