# Node.js Foundation Build WG Meeting 2016-02-02

## Links

* **GitHub issue:** https://github.com/nodejs/build/issues/313
* **Meeting video:** http://www.youtube.com/watch?v=PKFUFWGHF48
* **Meeting minutes:** https://docs.google.com/document/d/1hP5CmYFc8OkEk83gdnEo3J7W5nhDpVBKSL2uGso0ta0
* **Previous meetings:** https://docs.google.com/document/d/1MuN5J4JD7RvnxT3GvzzrY_U377rWWT5xyZXF0DtjSDs

## Present

* Alexis Campailla (@orangemocha)
* Hans Kristian Flaatten (@starefossen)
* Johan Bergström (@jbergstroem)
* Michael Dawson (@mhdawson)
* Myles Borins (@TheAlphaNerd)
* Rich Trott (observing only)
* Rod Vagg (@rvagg)
* Ryan Graham (@rmg)

## Standup

* Johan Bergström
  * Working with Michael on issues with PPC cluster. Still having issues. Don’t
    do reboots through the dashboards, use CLI instead. Still work in progress.
  * Work with Jenkins. Purging older jobs to reduce slowdowns. Delete 75 GB of
    data, Jenkins speeds up.
  * Worked on timeouts for Windows machines.
  * Worked on backups.
  * Issue #308, please take a look.
  * Spun up a few more CentOS slaves on Softlayer for improved redundancy.

* Alexis Campailla
  * Not much work on Build

* Rod Vagg
  * Not much to report for Build
  * xz compression for 0.12, 0.10 releases (inc headers) \[#284]

* Hans Kristian Flaatten
  * Jenkins monitor. Reduce noise. It now takes a 15 minutes downtime to send a
    report. Please send me any false reports.

* Michael Dawson
  * Jobs that do v8 testing in the node tree. PR pending. Still needs svn to be
    added to ansible configuration.
  * PPC big endian support in release (toolchain related issues)
  * Adding AIX machine and setting up builds

* Myles Borins
  * Refactoring on CITGM.

* Rich Trott (observing only)
  * Working on the testing WG.

* Ryan Graham
  * Nothing to report.

## Minutes

### Alpine Linux / Docker Build \[#75 #21]

Hans: Will run Jenkins slaves in Docker containers. Next steps: provision a
machine, write ansible configuration.

Someone mentioned [dante](https://github.com/retrohacker/dante).

Rod: which tag of Alpine Linux? Is this going to be a constant or a job parameter?

### Option to run V8 test suite \[#199]

Doesn’t run on windows at the moment.

Add subversion to a subset of the machines to expand testing

### Make sure all init scripts has JOBS and NODE_TEST_DIR \[#291]

Now supporting running tests in parallel.

Johan will put together a proposal

### how do we manage and share tokens tied to jenkins/github?

We cannot trust Jenkins with security tokens because they might bleed to stdout.

Joao will comment on how it works today. Johan will create an issue about it.

## Previous meeting review

Skipped

## Follow-ups
