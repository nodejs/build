# Node.js Foundation Build WorkGroup Meeting 2017-12-05

## Links

* **Recording**:  https://www.youtube.com/watch?v=6TT90qgE-pU
* **GitHub Issue**: https://github.com/nodejs/build/issues/1028

## Present

* Michael Dawson (@mhdawson)
* Jon Moss (@maclover7)
* Refael Ackermann (@refack)
* Kyle Farnung (@kfarnung)
* Rod Vagg (@rvagg)
* George Adams (@gdams)
* Rich Trott (@Trott)
* Gibson Fahnestock (@gibfahn)
* João Reis (@joaocgreis)

## Standup

* George Adams (@gdams)
  * Working on macOS Ansible scripts
  * Started looking at ppcle ansible
* João Reis (@joaocgreis)
  * Created VS2017 release machines, will move forward with test CI.
* Jon Moss (@maclover7)
  * Status update job is now done, playing with pipelines
* Kyle Farnung (@kfarnung)
  * Just got back, started looking at docker
* Michael Dawson (@mhdawson)
  * working on macOS infra, job to test out new machines
  * working on addition of z/OS machines and libuv jobs (in and green)
  * working to fixup put compilers on PPC machines
  * working to get/setup additional PCC/zLinux test machines to support compiler wok
  * some work on process to recover when we don’t have ArmV6 in release
* Refael Ackermann (@refack)
  * Maintenance
  * CI Job tweaks
  * core build scripts (Makefile, .gyp, and vcbuild)
  * GCC upgrade investigation
* Rich Trott (@Trott)
* Rod Vagg (@rvagg)
* Gibson Fahnestock (@gibfahn)
  * looked at OSX ansible stuff with George
  * working on job to test cmake replacement for gyp

## Agenda

* New OSX infra walkthrough [#1026](https://github.com/nodejs/build/issues/1026)
* Provide read access to our ci.nodejs.org configs [#972](https://github.com/nodejs/build/issues/972)
* Ubuntu non-LTS strategy [#967](https://github.com/nodejs/build/issues/967)
* Remove ARM64 Ubuntu 14.04 X-Gene servers from CI [#966](https://github.com/nodejs/build/issues/966)
* Remove Fedora 22, 23, 24 [#962](https://github.com/nodejs/build/issues/962)
* Remove Ubuntu 12.04 [#961](https://github.com/nodejs/build/issues/961)
* Make it easier for people to join the Build WG [#941](https://github.com/nodejs/build/issues/941)
* Permission to start culling all pre-v4 infra and build logic [#926](https://github.com/nodejs/build/issues/926)
* suggestion: investigate a commit-queue solution [#705](https://github.com/nodejs/build/issues/705)
* [#1030](https://github.com/nodejs/build/issues/1030)
* Blue overview

## Minutes

### Provide read access to our ci.nodejs.org configs [#972](https://github.com/nodejs/build/issues/972)
  * General agreement, just need to make sure no sensitive info will be exposed

### Ubuntu non-LTS strategy [#967](https://github.com/nodejs/build/issues/967)
 * Rod: We haven’t yet had complaints, but I don’t want to have too much load on
   our providers
 * Balancing broad test range across work to maintain machines and number of
   machines needed. Proposal for ubuntu, keep all active LTS lines, Could also
   include those that people pay for additional LTS.  Others lose support after
   9month (every 10 and every odd 4). Proposal to drop those.

### Remove ARM64 Ubuntu 14.04 X-Gene servers from CI [#966](https://github.com/nodejs/build/issues/966)
* These draw a lot of power, were needed earlier to get ARM64 support
* We now have alternative suppliers that we have ARM64 machines with
* Only issue is that we can’t get 14.04 which they run for the new machines
* We are running centos7 on the new machines, so good kernel/libc coverge that
  pre-dates 14.04
* General agreement that we can take out of builds

### Remove Fedora 22, 23, 24 [#962](https://github.com/nodejs/build/issues/962)
* Fedora has no LTS, they release every 6 or so months
* 24 was end of life this Aug
* Rod to formulate suggestion for next meeting.
* For now will drop 22 when we bring 27 on line

### Remove Ubuntu 12.04 [#961](https://github.com/nodejs/build/issues/961)
* Rod, chatted to ubuntu contact, they are now doing extended support.  Very
  popular for them.  Was EOL Apil this year, but extended support will go on
  for a number of years. Take back to github until next meeting

### Make it easier for people to join the Build WG [#941](https://github.com/nodejs/build/issues/941)
* Already split access to different levels (jenkins, infra, test, etc.)
* Add another level, can join and enter that level (ie less access)

### Permission to start culling all pre-v4 infra and build logic [#926](https://github.com/nodejs/build/issues/926)
* Can we remove stuff for pre 4
* Consensus in issue was yes
* Put #997 on agenda for TSC meeting tomorrow to get final agreement

### suggestion: investigate a commit-queue solution [#705](https://github.com/nodejs/build/issues/705)
* Possibly start with script that will help with person doing it
* Jon has created one - https://github.com/maclover7/committer-tools-rb

### [#1030](https://github.com/nodejs/build/issues/1030)
* Some advocacy to cut it at 10.11 ?, We currently build on 10.10
* Agreed to leave 10.8, 10.9 as experimental.

### New OSX infra walkthrough [#1026](https://github.com/nodejs/build/issues/1026)
* Defer to next meeting

### Blue Ocean overview
* Jon quickly took us through it

## Upcoming Meetings

* **Node.js Foundation Calendar**: https://nodejs.org/calendar

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
