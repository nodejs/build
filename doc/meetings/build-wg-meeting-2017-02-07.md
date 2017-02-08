# Node.js Foundation Build WG Meeting 2017-02-07

* GitHub issue: https://github.com/nodejs/build/issues/607
* Meeting video: https://www.youtube.com/watch?v=712Y-ytrBgY

* Previous meeting: https://docs.google.com/document/d/1-joUlwaNYirwDlG9sFUyrHKa43ljgRPpj5o-Ygv9JRc

* Next meeting: 14 Feb 2017


## Present

* @joaocgreis João Reis
* @mhdawson   Michael Dawson
* @jgergstroem Johan Bergström
* @piccoloaiutante Michele Capra

## Standup

* João Reis
  * Added shared library for engines test to package
    used in fanned jobs - https://github.com/nodejs/build/issues/596
  * Working with Kunal Pathak (@kunalspathak) to add Windows Server 2016
* Michael Dawson
  * Work on smartos release and test jobs to accommodate new version of V8
  * Creation of CI jobs for CIGTM, node-report and abi-stable-node
  * General work to keep AIX clean
* Johan Bergström
  * Ansible refactor
  * Verify backup routines
  * Jenkins security updates
  * Alpine/SmartOS inconsistencies
  * Jenkins host: disk issues
  * Bottlenecking in general
  * Add release host for smartos 15
* Michele Capra
  * Working on windows ansible script
  * Updating doc
  * Carrying work on remina scripts for generating secrets

## Agenda

* file and directory names for downloads:[#515](https://github.com/nodejs/build/issues/515)
* Draft text for HSTS communication [#484](https://github.com/nodejs/build/issues/484)
* TAP Plugin issues on Jenkins: [#453](https://github.com/nodejs/build/issues/453)
* rsync endpoint to mirror the releases: [#55](https://github.com/nodejs/build/issues/55)
* Document nightly [592](https://github.com/nodejs/build/issues/593)
* Reproducable builds: [#589](https://github.com/nodejs/build/issues/589)
* Cache CI downloads: [#599](https://github.com/nodejs/build/issues/599)

## Minutes

### file and directory names for downloads:[#515](https://github.com/nodejs/build/issues/515)
* Needs more discussion in github, remove agenda tag

### Draft text for HSTS communication [#484](https://github.com/nodejs/build/issues/484)
* Johan hopes to push this to March

### TAP Plugin issues on Jenkins: [#453](https://github.com/nodejs/build/issues/453)
* Johan has put together python script to push this along,
  next step is to get it onto all of the workers, needs to
  be tested on all machines. Johan will add more
  info in the issue.

### rsync endpoint to mirror the releases: [#55](https://github.com/nodejs/build/issues/55)
* Waiting on 484, remove from agenda

### Document nightly [592](https://github.com/nodejs/build/issues/593)
* some discussion of how it works
* João Reis  will add links to scripts into issue, Michael to submit PR with doc

### Reproducable builds: [#589](https://github.com/nodejs/build/issues/589)
* Waiting on availability of somebody to have enough time to tackle it

### Cache CI downloads: [#599](https://github.com/nodejs/build/issues/599)
* still in agreement with approach in issue

# other issues/topics

* Bus factor?
  * How do we reduce dependency on a small number of key individuals
  * Discussion to be continued in next meeting.

* Get back on track with meetings
  * Need to get back on track with regular meetings
  * Will meet next week to get those who could not make it this week
    and to get back on the regular schedule
