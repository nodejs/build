# Node.js Foundation Build WorkGroup Meeting 2018-07-03 10

## Links

* **Recording**:  https://www.youtube.com/watch?v=rzyqeVzHCCg
* **GitHub Issue**: https://github.com/nodejs/build/issues/1387

## Present

* Build team: @nodejs/build
  * Michael Dawson (@mhdawson)
  * Refael Ackermann (@refack)
  * Matheus Marchini (@mmarchini)

* Observer
  * Adam Miller (@amiller-gh)

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* policy: no use of PR code in live jobs [#1378](https://github.com/nodejs/build/issues/1378)
  * There has been a number of different cases were we have used code from forks
  * There are tradeoffs to doing this.
  * Should formalize a “recommended way” and how to handle exceptions (todo @refack)

* Demo AWX (Ansible Tower) installation [#1340](https://github.com/nodejs/build/issues/1340)
   * will wait until next time when George is available

* Request for elevated permissions [#1337](https://github.com/nodejs/build/issues/1337)
  * Refack: problem is with the issue is that it's not an issue until it is.
  * The first ask is to the Release team, advance notification to build group to line up
     resources for releases.  Open issue in 1 week in advance, asking for who will be available
     during expected hours of release, and make sure there is acknowledgement before
     proceeding.

* Build WG self-nomination: amiller-gh [#1305](https://github.com/nodejs/build/issues/1305)
  * Rich make sure Adam gets onboarded.

* request to join the build group [#1303](https://github.com/nodejs/build/issues/1303)

* State of Ansible [#1277](https://github.com/nodejs/build/issues/1277)
  * Defer to next time when Jon is available

* Use of Docker in Build CI [#1226](https://github.com/nodejs/build/issues/1226)
  * Defer to next time when Rod is available.

* Release infrastructure post mortem [#1212](https://github.com/nodejs/build/issues/1212)
  * We have job that tries to download binaries
  * Refack: can use CITGM job that runs off packaged binary.
  * Existing job probably would have caught issue, if it did unzip/msi extract as well.
    Action ask George to see how hard it will be to add that.
    Refack mentioned there is a tool that can extract msi on windows.
    Other action is communication with Release team to make sure they kickoff the job after a release

* Dropping 32-bit builds [#885](https://github.com/nodejs/build/issues/885)
   * Key question is when we can remove the machines, answer is not until at least after
     8.x.  Leave on agenda until we have Rod add any insight he has from had looked at the
     data in detail.

## Q&A, Other

*  No questions from YouTube.

## Upcoming Meetings

* **Node.js Foundation Calendar**: https://nodejs.org/calendar

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
