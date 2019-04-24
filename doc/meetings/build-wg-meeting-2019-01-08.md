# Node.js Foundation Build WorkGroup Meeting 2019-01-08

## Links

* **Recording**:  https://www.youtube.com/watch?v=-YNS0kE_OvU
* **GitHub Issue**: https://github.com/nodejs/build/issues/1654

## Present

* Michael Dawson (@mhdawson)
* Refael Ackermann (@refack)
* Rich Trott (@Trott)


## Agenda

## Announcements
 
*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

* No announcements this week.

### nodejs/build

* doc: add gireeshpunathil to members [#1641](https://github.com/nodejs/build/pull/1641)
  * Gireesh onboarded last week. Welcome!
* Can 'make lint-py PYTHON=python3' be a mandatory Jenkins test? [#1631](https://github.com/nodejs/build/issues/1631)
  * Rafael is trying to catch up with Christian. There has been work in Ansilble to setup
    Python3 on one of the machines.  May replace one of the machines and run lint on 
    both Python2 and Python3. However, there may be a small gap of files that are not
    yet Python 3 lint. For those listening, if you have have Python3 installed you can
    run linter specifying the path you python3 linting. Reach out to Christian or Refael if
    you need help getting started to work on fixing the remaining issues.
* Add more aix machines [#1623](https://github.com/nodejs/build/issues/1623)
  * George is working on this. Taking a bit more time because he wants to be religious about
     using Ansible where possible.
  * Refael, Rich is AIX still a bottleneck. Michael, single one that I looked at Windows ended
    after AIX.
* Request for elevated permissions [#1337](https://github.com/nodejs/build/issues/1337)
  * No update this time.
* Use Foundation resources to support build [#1154](https://github.com/nodejs/build/issues/1154)
  * No update, plan is to start strategic initiative as outlined in issue.

* Rich nightly jobs
  * Nightly job that runs benchmark tests and internet tests.  
  * Would like to add pummel tests to that. Needs a number of pull requests to land
  * Also want to add an additional nightly job to run the same on windows as well.
  * Refael, needs to make the “custom test suites” job, windows compatible.
  * Refael is volunteering since he setup the other one.

## Q&A, Other

* No questions this week.

## Upcoming Meetings

* **Node.js Foundation Calendar**: https://nodejs.org/calendar

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.

