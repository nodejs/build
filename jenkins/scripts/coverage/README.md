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
  [node-test-commit-linux-coverage-daily](https://ci.nodejs.org/view/All/job/node-test-commit-linux-coverage-daily/).
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

# Coverage Job

The coverage job follows the same pattern as our other build jobs in order
to check out the version of node to be build/tested. It requires the following
additions:

1. Build/test with the coverage targets.  This is currently:

   ```
   ./configure --coverage
   make coverage-clean
   NODE_TEST_DIR=${HOME}/node-tmp PYTHON=python COVTESTS=test-ci make coverage -j $(getconf _NPROCESSORS_ONLN)
   ```

2. Generate html summary page and push results to the benchmarking data machine:

   ```
   #!/bin/bash

   # copy the coverage results to the directory where we keep them
   # generate the summaries and transfer to the benchmarking data
   # machine from which the website will pull them

   export PATH="$(pwd):$PATH"

   # copy over results
   COMMIT_ID=$(git rev-parse --short=16 HEAD)
   mkdir -p "$HOME/coverage-out"
   OUTDIR="$HOME/coverage-out/out"
   mkdir -p "$OUTDIR"
   rm -rf "$OUTDIR/coverage-$COMMIT_ID" || true
   cp -r coverage "$OUTDIR/coverage-$COMMIT_ID"

   # add entry into the index and generate the html version
   JSCOVERAGE=$(grep -B1 Lines coverage/index.html | \
     head -n1 | grep -o '[0-9\.]*')
   CXXCOVERAGE=$(grep -A3 Lines coverage/cxxcoverage.html | \
    grep style | grep -o '[0-9]\{1,3\}\.[0-9]\{1,2\}')
   NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

   echo "$JSCOVERAGE,$CXXCOVERAGE,$NOW,$COMMIT_ID" >> "$OUTDIR/index.csv"

   cd $OUTDIR/..
   $WORKSPACE/testing/coverage/generate-index-html.py

   # transfer results to machine where coverage data is staged.
   rsync -r out coveragedata:coverage-out
   ```

The current setup depends on past runs being in /home/iojs/coverage-out/out
on the machine that it is run on so that the generated index
includes the current and past data. For this and other reasons described
in the other sections, the job is pegged to run on:
[iojs-softlayer-benchmark](https://ci.nodejs.org/computer/iojs-softlayer-benchmark/)


# Transfer to benchmarking data machine
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
