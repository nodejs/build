# Node.js Foundation Build WorkGroup Meeting 2018-07-31

## Links

* **Recording**:  https://www.youtube.com/watch?v=x5oihzTO71g
* **GitHub Issue**: https://github.com/nodejs/build/issues/1420

## Present

* Michael Dawson (@mhdawson)
* George Adams (@gdams)
* Rich Trott (@Trott)
* Jon Moss (@maclover7)
* Rod Vagg (@rvagg)
* Luca Lanziani (@lucalanziani)
* Refael Ackermann (@refack)

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

* No announcements this week.

### nodejs/build

* policy: no use of PR code in live jobs [#1378](https://github.com/nodejs/build/issues/1378)
  * Discussed in last meeting.  Want to balance reliability of infra versus getting things done.
  * Want to formalize how we make changes to public CI.
  * Conclusion is that we should start discussion
  * Rod, we should just agree that we should adopt policy
  * Michael, last time I think we agreed it should be the rule, with other cases the exceptions
  * Exceptions should be well documented and messaged.
  * Examples, version selector (using PR in production), use of repo for pipelines
  * General approach we discussed
    * Goal is to have PR for any change
    * In exceptions where that is not possible, open issue and make sure it gets enough visibility
  * Next step is to document process, @refack will write this up.


* Request for elevated permissions [#1337](https://github.com/nodejs/build/issues/1337)
  * Jon - Next step is criteria for giving people access.
  * Rod, real problem is that we need to break out levels of access so that we can more
    freely give out access
  * Michael, find highest pain point and then figure out how to tease appart
  * Jon, for example separate key for github bot, possibly different keys for web server
  * Next Action - Rod to describe the different pieces as the starting point for looking at how
    atomize access.

* Build WG self-nomination: amiller-gh [#1305](https://github.com/nodejs/build/issues/1305)
  * waiting on Adam to be available.
* request to join the build group [#1303](https://github.com/nodejs/build/issues/1303)
  * waiting on Dan to be available

* State of Ansible [#1277](https://github.com/nodejs/build/issues/1277)
  * leave centos as is as it will be retired when possible
  * AIX is being worked inside IBM and we have a new machine at OSU that we can use
    once we have ansible scripts.  TLDR; making slow progress.
  * For website maybe better approach is to pull out into component pieces as the whole
    is quite complicated.
  * First step is probably to plan to have new website be on its own server as opposed to pulling
    into existing monolith.
  * When we outline the pieces for 1337 that will make it obvious what we might break out.

* Use of Docker in Build CI [#1226](https://github.com/nodejs/build/issues/1226)
  * Rod, will prep and do in next meeting.

* Dropping 32-bit builds [#885](https://github.com/nodejs/build/issues/885)
  * commented in issue as to next steps and then remove build-agenda.

* Demo AWX (Ansible Tower) installation [#1340](https://github.com/nodejs/build/issues/1340)
  * George took us through a quick runthrough

## Q&A, Other
No questions this time.

## Upcoming Meetings
* **Node.js Foundation Calendar**: https://nodejs.org/calendar

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.

