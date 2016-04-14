# Node.js Foundation Build WG Meeting 2016-01-12

## Links

* **GitHub issue:** https://github.com/nodejs/build/issues/300
* **Meeting video:** https://www.youtube.com/watch?v=tSKLGN4PwlE
* **Meeting minutes:** https://docs.google.com/document/d/1MuN5J4JD7RvnxT3GvzzrY_U377rWWT5xyZXF0DtjSDs
* **Previous meeting:** https://docs.google.com/document/d/1zScaSAUZiGrbhEk9mFxA8l3isoDq34p3J8TwNnpG5xg

## Present

* Hans Kristian Flaatten (@starefossen)
* Johan Bergström (@jbergstroem)
* Michael Dawson (@mhdawson)
* Myles Borins (@TheAlphaNerd)
* Rich Trott (observing only)
* Ryan Graham (@rmg)

## Standup

* Michael:
  * getting benchmarks in place for the benchmarking group
  * looking to add zLinux machine to CI
  * Still working to get AIX machines

* Ryan:
  * getting started

* Johan
  * removing gyp jobs to reduce to single jenkins runner
  * work with deploying change to set path for temporary storage for test runner
    NODE_TEST_DIR (replacement for NODE_COMMON_PIPE)
  * Housecleaning on vmcluster (redeployments)

* Hans
  * work to parse jenkins job status to publish to git issues

* Myles
  * work with citgm
  * added ppc slaves to the job
  * investigated centos issues

## Previous meeting followup

### Option to run V8 test suite [#199]

Michael: getting a job will land this week

## Minutes

### Alpine Linux / Docker Build [#75 #79]

Hans: look into getting it into ansible

Hans: get a vm that can run docker and install alpine to avoid vm restrictions

Johan: start a docker vm at digitalocean to host this.

Michael: add docker to required packages in one of our ansible hosts

### New readme, new company listing incl logos, new team listing [#294]

Find a way to distinct between tiers (possibly number of vm deploys)

### Backup of configs / Config History [#295]

Myles: how do we improve backing up jenkins configs?

Ryan: I’ve had success with
https://wiki.jenkins-ci.org/display/JENKINS/JobConfigHistory+Plugin

Johan: get a “backup” jenkins master so we can test new plugins, plugin upgrades
or jenkins updates
