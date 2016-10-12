# Code Coverage Generation

We have nightly code coverage generation so that we can track test coverage
for Node.js, make the information public and then use that information
to improve coverage over time.

At this time we only capture coverage results once a day on linux x86. We
believe that coverage will not vary greatly across platforms and that the
process will be too expensive to run on every commit.  We will re-evaluate
these assumptions based on data once the process has been in place for
a while.

This doc captures the infrastructure in place to support the generation
of the coverage information published to https://coverage.nodejs.org.

# Steps

Generation/publication of the code coverage results consists of the following:

* Nightly scheduled job - We have a job in jenkins which is scheduled to run at
  11 EST each night.
  [node-test-commit-linux-coverage](https://ci.nodejs.org/view/All/job/node-test-commit-linux-coverage/).
* At the end of the scheduled job it rsync's the generated data to the
  benchmarking data machine.  We do this so that once the job is complete
  the data is in a place where we know we can pull it from, and that pulling
  that data will not affect any other jobs (for example jobs measuring
  performance on the benchmark machine).
* At hourly intervals the the data is rsync'd from the benchmarking
  data machine to the website.  This is triggered from the nodejs.org website
  machine and data is pulled from the benchmarking data machine. This allows
  us to minimize who can modify the nodejs.org website as no additional
  access is required.

# Benchmark Job

The benchmark job follows the same pattern as our other build jobs in order
to check out the version of node to be build/tested. It requires the following
additions:


1. Checkout of the scripts used to generate the coverage
   These will be moved to https://github.com/nodejs/testing/coverage and the job
   updated once that is complete:
   ```
   if [ ! -d node-core-coverage ]; then
     git clone --depth=10 --single-branch git://github.com/addaleax/node-core-coverage.git
   fi
   ```

2. Get a copy of gcov:

   ```
   # get gcov if required and then apply patches that are required for it
   # to work with Node.js.
   if [ ! -d gcovr ]; then
     git clone --depth=10 --single-branch git://github.com/gcovr/gcovr.git
     (cd gcovr && patch -p1 < "../node-core-coverage/gcovr-patches.diff")
   fi
   ```

3. Install the npm modules that we use to instrument Node.js and
   generate JavaScript coverage, instrument Node.js
   (both JavaScript and c++) and remove any
   old coverage files. This requires first building Node.js without
   coverage so we can install the npm modules and then use those npms to do
   the instrumentation. A later step will then rebuild as we would in the
   normal build/test jobs resulting in an instrumented binary.  The step
   that instruments for C++ currently requires patching the Node.js source
   tree (patches.diff).  We will work to build those changes into the Makefile
   so that there are additional targets that can be used for code coverage
   runs and that patching the source is no longer required.  This will
   reduce the likelihood/frequency of conflicts causing the code
   coverage job to fail due to conflicts.

   ```
   #!/bin/bash
   # patch things up
   patch -p1 < "./node-core-coverage/patches.diff"
   export PATH="$(pwd):$PATH"

   # if we don't have our npm dependencies available, build node and fetch them
   # with npm
   if [ ! -x "./node_modules/.bin/nyc" ] || \
      [ ! -x "./node_modules/.bin/istanbul-merge" ]; then
     echo "Building, without lib/ coverage..." >&2
     ./configure
     make -j $(getconf _NPROCESSORS_ONLN) node
     ./node -v


     # get nyc + istanbul-merge
     "./node" "./deps/npm" install istanbul-merge@1.1.0
     "./node" "./deps/npm" install nyc@8.0.0-candidate

     test -x "./node_modules/.bin/nyc"
     test -x "./node_modules/.bin/istanbul-merge"
   fi


   echo "Instrumenting code in lib/..."
   "./node_modules/.bin/nyc" instrument lib/ lib_/
   sed -e s~"'"lib/~"'"lib_/~g -i~ node.gyp

   echo "Removing old coverage files"
   rm -rf coverage
   rm -rf out/Release/.coverage
   rm -f out/Release/obj.target/node/src/*.gcda
   ```

4. Build/test as per normal build/test job.  This is currently:

   ```
   NODE_TEST_DIR=${HOME}/node-tmp PYTHON=python FLAKY_TESTS=$FLAKY_TESTS_MODE make run-ci -j $(getconf _NPROCESSORS_ONLN)
   ```

   but modified for that test failures don't stop the rest of the process as the
   instrumentation seems to have introduced a couple of failures.

5. Gather coverage and push to the benchmarking data machine:

   ```
   #!/bin/bash

   export PATH="$(pwd):$PATH"
   echo "Gathering coverage..." >&2

   mkdir -p coverage .cov_tmp
   "$WORKSPACE/node_modules/.bin/istanbul-merge" --out .cov_tmp/libcov.json \
     'out/Release/.coverage/coverage-*.json'
   (cd lib && "$WORKSPACE/node_modules/.bin/nyc" report \
     --temp-directory "$(pwd)/../.cov_tmp" -r html --report-dir "../coverage")
   (cd out && "$WORKSPACE/gcovr/scripts/gcovr" --gcov-exclude='.*deps' --gcov-exclude='.*usr' -v \
     -r Release/obj.target/node --html --html-detail \
     -o ../coverage/cxxcoverage.html)

   mkdir -p "$HOME/coverage-out"
   OUTDIR="$HOME/coverage-out/out"
   COMMIT_ID=$(git rev-parse --short=16 HEAD)

   mkdir -p "$OUTDIR"
   cp -rv coverage "$OUTDIR/coverage-$COMMIT_ID"

   JSCOVERAGE=$(grep -B1 Lines coverage/index.html | \
     head -n1 | grep -o '[0-9\.]*')
   CXXCOVERAGE=$(grep -A3 Lines coverage/cxxcoverage.html | \
     grep style | grep -o '[0-9]\{1,3\}\.[0-9]\{1,2\}')

   echo "JS Coverage: $JSCOVERAGE %"
   echo "C++ Coverage: $CXXCOVERAGE %"

   NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

   echo "$JSCOVERAGE,$CXXCOVERAGE,$NOW,$COMMIT_ID" >> "$OUTDIR/index.csv"
   cd $OUTDIR/..
   $HOME/coverage-out/generate-index-html.py

   # transfer results to machine where coverage data is staged.
   rsync -r out coveragedata:coverage-out
   ```

The current setup depends on past runs being in /home/iojs/coverage-out/out
on the machine that it is run on so that the generated index
includes the current and past data. For this and other reasons described
in the other sections, the job is pegged to run on:
[iojs-softlayer-benchmark](https://ci.nodejs.org/computer/iojs-softlayer-benchmark/)


# Tranfer to benchmarking data machine
The rsync from the machine on which the job runs to the benchmarking
data machine requires an ssh key.  Currently we have pegged the job to the
benchmarking machine
[iojs-softlayer-benchmark](https://ci.nodejs.org/computer/iojs-softlayer-benchmark/),
have installed the key there, and have added an entry in
the ```.ssh/config``` file for the iojs user so that connections to the
'coveragedata' go to the benchmarking machine and use the correct key
(uses the softlayer internal network as opposed to public ip)

```
Host coveragedata
  HostName 10.52.6.151
  User benchmark
  IdentityFile ~/coverage-out/key/id_rsa
```

The results are pushed to /home/benchmark/coverage-out/out.

# Transfer to the website
As mentioned earlier, the website will pull updates hourly from
/home/benchmark/coverage-out/out and put
them in the right place to be served at coverage.nodejs.org.  The key
required to do this is already in place in order to support the similar process
for benchmarking.nodejs.org
