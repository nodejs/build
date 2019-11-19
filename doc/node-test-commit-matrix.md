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
    - centos6-64-gcc48 (Node < 10)
    - centos6-64-gcc6 (Node >= 10)
    - centos7-64-gcc48 (Node < 10)
    - centos7-64-gcc6 (Node >= 10)
    - debian8-64
    - debian8-x86 (Node < 10)
    - debian9-64
    - fedora-last-latest-x64
    - fedora-latest-x64
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
    - smartos15-64 (Node >= 8 < 10)
    - smartos16-64 (Node >= 8 < 12)
    - smartos17-64 (Node >= 10 < 12)
    - smartos18-64 (Node >= 12)
  - **node-test-commit-windows-fanned**  
    [See below for detailed information](#windows-test-matrix). Sub-jobs are:
    - **node-compile-windows**
    - **node-test-commit-windows-debug**
    - **node-test-binary-windows-js-suites**
    - **node-test-binary-windows-native-suites**
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
    - rhel7-s390x (Node >= 6)
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

## Windows Test Matrix

The **node-test-commit-windows-fanned** is divided in 3 stages:
  - **git-rebase** loads a commit from GitHub into a repository dedicated to temporary data, optionally rebasing.
  - **node-compile-windows** compiles Node.js, loading from and storing the result back in the temporaries repository. Meanwhile, **node-compile-windows-debug** compiles Node.js in debug mode and compiles a native add-on to ensure minimum functionality, discarding the resulting binaries.
  - **node-test-binary-windows-js-suites** and **node-test-binary-windows-native-suites** fully test the binaries from the previous stage (only from the Release builds).

Running the resulting binaries from every supported Visual Studio version in every supported Windows version would place an unreasonable demand on the infrastructure we have available, so **only a subset of combinations is run**.
- Debug builds run only to ensure the debug build is not broken, the resulting binaries are not fully tested.
- x86 builds only run in one Visual Studio version, preferably the one used to build the official releases.

### Combinations being tested

- Run JS tests on all supported Windows Versions.
- Run add-ons tests on all supported Visual Studio versions (preferably spanning all supported Windows Versions).
- If necessary, run more combinations for the Visual Studio version that is used to build the official releases.

The following combinations are used:

#### Node.js versions 10 & 12

| Binaries produced by: | Run in Windows version: | Test add-ons with: |
|-----------------------|-------------------------|--------------------|
| VS 2017               | 10                      | VCBT 2015          |
|                       | 2008R2 (until EOL)      | VS 2017            |
|                       | 2016                    | VS 2017            |
| VS 2017 (x86)         | 2012R2                  | VS 2015            |

#### Node.js versions 13 and newer

| Binaries produced by: | Run in Windows version: | Test add-ons with: |
|-----------------------|-------------------------|--------------------|
| VS 2017               | 2016                    | VS 2017            |
|                       | 2008R2 (until EOL)      | VS 2017            |
| VS 2019               | 10                      | VCBT 2015, VS 2019 |
| VS 2019 (x86)         | 2012R2                  | VS 2015, VS 2019   |

### Machines available to CI

| # | Windows | Visual Studio | Use for   | Provider  | Notes |
|---|---------|---------------|-----------|-----------|-------|
| 4 | 10      | VCBT 2015     | All       | Azure     |       |
| 4 | 10      | VS 2019       | Test Only | Azure     |       |
| 6 | 2016    | VS 2017       | Test Only | Azure     |       |
| 4 | 2008R2  | VS 2017       | Test Only | Rackspace | Remove at Windows 2008 EOL |
| 2 | 2012R2  | VS 2013       | All       | Rackspace | Remove at Node.js 8 EOL |
| 2 | 2012R2  | VS 2015       | All       | Rackspace |       |
| 4 | 2012R2  | VS 2017       | All       | Rackspace |       |
| 6 | 2012R2  | VS 2019       | All       | Rackspace |       |

- Machines for "Test Only" don't build Node.js, but are still used to build add-ons so Visual Studio is necessary.
- Machines in Rackspace have more capacity, so avoid building on Azure, at least the current Node.js version.
- Optimize resources for the current Node.js master.
- Ensure Node.js LTS versions have full coverage, even if with possible bottlenecks in certain versions.

### Jenkins Labels

Machines for "Test Only" should have the following labels:

| Template | Examples | Notes |
|---|---|---|
| `winVER` | `win10` | Used for other CI jobs that don't require VS |
| `winVER-vsVER` | `win10-vcbt2015`, `win2012r2-vs2019` | Used for other CI jobs |
| 1 | `win10-COMPILED_BY-vcbt2015` | Used for running JS tests |
| 2 | `win10-vs2015-COMPILED_BY-vs2017` | Used for running add-ons tests |

All combinations of labels possible from the tables above (Combinations being tested) need to be assigned to the machines:
1. `Run in Windows version`-COMPILED_BY-`Binaries produced by`
2. `Run in Windows version`-`Test add-ons with`-COMPILED_BY-`Binaries produced by`

- When building add-ons with a x86 Node.js version, the addons will automatically be compiled for x86 so a specific label (`winV-vsV-x86-COMPILED_BY-vsV`) is not needed.

Machines for "All" ("Test Only" + Build) should also have the labels:

| Template | Examples | Notes |
|---|---|---|
| `win-vsVER` | `win-vs2019` |  |
| `win-vsVER-x86` | `win-vs2019-x86` | Not necessary for `vcbt2015` |
