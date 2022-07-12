# Node.js Foundation Build WorkGroup Meeting 2018-08-14

## Links

* **Recording**:  (to be added at a later date)
* **GitHub Issue**: https://github.com/nodejs/build/issues/1433

## Present

* George Adams (@gdams)
* Refael Ackermann (@refack)
* Adam Miller (@amiller-gh)
* Jon Moss (@maclover7)
* Rod Vagg (@rvagg)
* Joyee Cheung (@joyeecheung)
* Matheus Marchini (@mmarchini)

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

* No announcements

### nodejs/build

* policy: no use of PR code in live jobs [#1378](https://github.com/nodejs/build/issues/1378)
  * Refack to put something in writing
    * don’t want to cause regressions on main CI (code not trackable in jenkins)
  * Need to formally document how to fast track certain ad hoc changes
* Request for elevated permissions [#1337](https://github.com/nodejs/build/issues/1337)
  * Waiting on Rod to split secrets (atomizing the more protected levels)
* Build WG self-nomination: amiller-gh [#1305](https://github.com/nodejs/build/issues/1305)
  * Jon and Rod to onboarding
* request to join the build group [#1303](https://github.com/nodejs/build/issues/1303)
  * Jon to follow up
* State of Ansible [#1277](https://github.com/nodejs/build/issues/1277)
  * AIX still being worked on by IBM people
  * Centos 5 can be removed -- Jon will remove playbook; Rod to remove from ci.nodejs.org
    * (P.S. libuv is happy for Centos 5 to be removed https://github.com/libuv/libuv/issues/1935 + https://github.com/libuv/libuv/pull/1940#issuecomment-411744257)
* Use of Docker in Build CI [#1226](https://github.com/nodejs/build/issues/1226)
  * Waiting for Michael to be back for walkthrough
  * Jon has written a guide for debugging (https://github.com/nodejs/build/blob/main/doc/jenkins-guide.md#fixing-machines-with-docker)
* Setting `core.autocrlf` on workers to avoid git “autofix” [#1443](https://github.com/nodejs/build/issues/1443)
  * Been happening for a while (a file marked as “Modified” breaks rebasing)
  * V8 file checked in with CRLF file endings
    * dependencies are not linted
  * Proposed solution is to set `core.autocrlf=false` && `core.safecrlf=false`. Since this is a CI cluster, it makes sense not to touch any files during testing.

* Refack was concerned that we aren’t using ccache enough on machines
* Also need to keep an eye on https://github.com/nodejs/node/issues/22006 (there’s a bug in  Makefile, breaking on macos 1012 with `-j2`)

## Q&A, Other

* Build IRC mirroring to slack (gdams)
  * http://www.nodeslackers.com/
  * No objection from the build WG, talk to the wider community to get approval

## Upcoming Meetings

* **Node.js Foundation Calendar**: https://nodejs.org/calendar

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
