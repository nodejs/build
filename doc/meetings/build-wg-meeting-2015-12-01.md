# Node.js Foundation Build WG Meeting 2015-12-01

## Links

* **GitHub issue:** https://github.com/nodejs/build/issues/269
* **Meeting video:** http://www.youtube.com/watch?v=9aVNXVazrVw
* **Meeting minutes:** https://docs.google.com/document/d/1zFMmIYUP1tA_YS_sx7P0-vZQ3zy3sOYGSG73otRvoSc/edit
* **Previous meeting:** https://docs.google.com/document/d/1zTS3dc--ziFdRJrqQqzH6el0pir0EgQBq2cCCUT7VxU

## Present

* Alexis Campailla (@orangemocha)
* Johan Bergström (@jbergstroem)
* Michael Dawson (@mhdawson)
* Myles Borins (@TheAlphaNerd)
* Ryan Graham (@rmg)

## Standup

* Michael Dawson
  * still working on AIX, maybe 2016Q1
  * added FIPS mode build

* Johan Bergström
  * investigated Jenkins stability issues, tweaked JVM options, seems to be
    working better now
  * naming convention for hosts to better play with ansible roles for
    provisioning
  * moved some machines from Digital Ocean to SoftLayer
  * proposal for smaller set of ssh keys for access to infrastructure
    * test, release, infra - more details in nodejs/secrets repo
    * nodejs/build#254
  * refactoring nodejs/secrets repo
  * experimenting with ansible templating on the FreeBSD hosts

* Alexis Campailla
  * nodejs/build#151 proposal for a module building infrastructure, wants
    feedback before prototyping
  * emergency maintenance on Jenkins, problem with multijob plugin

* Myles Borins
  * unit tests working on citgm
  * started looking at integrating with CI jobs

* Ryan Graham
  * investigating connecting to Windows slaves that are running Microsoft’s port
    of OpenSSH

## Minutes

### Option to run V8 test suite \[#199]

Running tests should be fairly easy, hardest part is to figure out how to
configure all the prerequisites. Michael to follow up and report on progress.
First deliverable: a quick and dirty job in Jenkins to run this daily. We can
improve the process as we go.

### PPC platforms as part of standard release \[#205]


### Add FIPS mode build to CI \[#264]


## Previous meeting review

Skipped


## Follow-ups

Take a look at open PRs in the build repo. Lots of stale stuff.

These issues were not fully discussed. Keep on the agenda for next meeting:

* [ ] Probably should discuss how to include node-gyp and NAN in Jenkins, we've had
  requests for both projects and it makes sense, particularly for NAN which has
  a big test suite (node-gyp has a ... smaller test suite).
* [ ] I've been pondering our ARM hardware and would like to discuss how we might go
  about ensuring that we have hardware test coverage that is as close as
  possible to what is being used in the wild for Node—for IoT, hobbyist, etc.
  users. Consider how newer platforms like Pi Zero have the potential to change
  the landscape. Also think of MIPS and how we have zero coverage there. It
  might be something we can defer to the Hardware WG, maybe they can do some
  surveys or perhaps they have existing data.
