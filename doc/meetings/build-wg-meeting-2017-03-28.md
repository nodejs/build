# Node.js Foundation Build WG Meeting 2017-03-28

- GitHub issue: https://github.com/nodejs/build/issues/660
- Meeting video:
https://www.youtube.com/watch?v=znJWeDabfOw
- Link for participants:
https://hangouts.google.com/hangouts/_/ytl/KOIfKbVSfs8CMc3OB3XsoxoKlDtgpIGkbsfAvJbRIe8=?eid=100598160817214911030&hl=en_US&authuser=0
- Previous meeting:
https://docs.google.com/document/d/1H92tArttCPi8EFO2Guz8lWY0kydA-RRHwXe0VIEKn3w/edit

Next meeting: 18 April 2017

## Present
* Michael Dawson (@mhdawson)
* João Reis (@joaocgreis)
* Gibson Fahnestock (@gibfahn)
* Rod Vagg (@rvagg)
* Michele Capra (@piccoloaiutante)
* Kunal Pathak (@kunalspathak)
* Kyle Farnung (@kfarnung)
* Rich Trott (@trott)

## Standup
* Michael Dawson
  * Investigation of AIX disk i/o speeds for CitGM testing
  * setup of npm user for Node.js foundation modules
  * landing supported platforms PRs
* Johan Bergström
  * jenkins master security updates, twice
  * play around with the tap2junit parser -- it will bail on citgm stuff; needs
    to be refactored
  * fix disk issues on joyent freebsd workers which seems to have changed how
    disk is mounted which led to disk issues.
  * housekeeping on a few workers
* João Reis
  * Working on CI test jobs for node-chakracore
  * Support for VS2017 in node-gyp
* Gibson Fahnestock
  * Looking at test-npm jobs, running on windows/unix, working on getting all
    test passing
  * looking at tap2junit, inc. for CitGM
  * tweaks to AIX (with @gdams), add ramdisk to speed up CiTGM runs
* Michele Capra
  * Ansible module for creating .remmina files
* Rod Vagg - minor ARM cluster maintenance, minor cloud cluster maintenance
* Kunal Pathak
  * added Windows Server 2016 to CI jobs
* Rich Trott
  * nothing to report

## Agenda
* Move nodejs/readable-stream CI from Travis to Jenkins
[#657](https://github.com/nodejs/build/issues/657)
* Add Kunal Pathak to Build WG
[#649](https://github.com/nodejs/build/issues/649)
* file and directory names for downloads
[#515](https://github.com/nodejs/build/issues/515)
* Draft text for HSTS communication
[#484](https://github.com/nodejs/build/issues/484)
* TAP Plugin issues on Jenkins
[#453](https://github.com/nodejs/build/issues/453)
* any other issues/topics

## Minutes

### Move nodejs/readable-stream CI from Travis to Jenkins [#657](https://github.com/nodejs/build/issues/657)
  * Discussion about moving to use Foundation infrastructure. We are not
    strictly firewalled, so likely not an issue.
  * Gibson will continue to work with them to implement and we’ll see if there
    are any issues.
### Add Kunal Pathak to Build WG [#649](https://github.com/nodejs/build/issues/649)
  * Everybody in the meeting agreed, we’ll add Kunal to the WG
### file and directory names for downloads [#515](https://github.com/nodejs/build/issues/515)
  * We agreed last meeting we should remove the agenda tag and discuss in
    github
### Draft text for HSTS communication [#484](https://github.com/nodejs/build/issues/484)
  * We agreed last meeting we should remove the agenda tag and discuss in
    github
### TAP Plugin issues on Jenkins [#453](https://github.com/nodejs/build/issues/453)
  * We agreed last meeting we should remove the agenda tag and discuss in
    GitHub

### Adding macOS workers.
  * Johan: We had an interesting opportunity which led into
    [this](https://github.com/nodejs/build/issues/539) and back to sleep. After
    we've sorted that we can revisit the opportunity and increase both
    redundancy and os versions tested.
  * Rod: We had been working with macOS hosting provider, but haven’t closed on
    this yet.
  * Rod to get email out and include Michael and Johan and we’ll try push
    forward.

### Bus factor:
  * Johan: I like Michaels idea of primary/backup for positions. Which would
    these positions be though? My ambition is that everybody in the build group
    would help out with the level of access they have – meaning all of our
    members should feel free to look at restarting/debugging individual
    workers. As for the higher tiers; we need to start by defining these
    positions.
  * Rod: good way to start is maintenance on the test workers.
  * Michael to open an issue to discuss the list of areas.


## Questions

### William Kapke - why not spend the community money?
  * Rod - we have done a good job getting contributions.  Once we start to pay
    then others may ask why they are not paid as well. Want to exhaust all
    possible channels before we go that way.
