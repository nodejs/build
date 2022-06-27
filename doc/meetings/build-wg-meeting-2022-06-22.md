# Node.js  Build WorkGroup Meeting 2022-06-22


## Links

* **Recording**:  http://www.youtube.com/watch?v=dyppFdYdPRI
* **GitHub Issue**: https://github.com/nodejs/build/issues/2970

## Present

* Michael Dawson (@mhdawson)
* Stewart Addison (sxa)
* Richard Lau (@richardlau)
* Rich Trott (@Trott)
* Rod Vagg

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build


* Enable HSTS on website [#2857](https://github.com/nodejs/build/issues/2857)
  * We just need to pick a date
  * Rod, would we get rid of encrypted as well?
  * Rich, volunteered to write the blog post, 
  * We’ll plan to do July 13th

* Interest in establishing a "Build Helper" role [#2550](https://github.com/nodejs/build/issues/2550)
  * Richard, most of what was required this last few weeks, build helper would not have helped
  * Webhook is a good one for this

* Memory issue on fedora in latest V8 (8.8) requirement [#2527](https://github.com/nodejs/build/issues/2527)
  * just waiting on documenting adding swap in manual instructions

* Official Windows arm64 binaries -  https://github.com/nodejs/build/issues/2970
  * access to windows on arm machines
  * access to Jenkins
  * ask is to configured through ansible
  * start with simpler build/test job
  * Next step is to set up follow up meeting, to connect with nsait-linaro, Stewart will do that.

*  https://github.com/nodejs/build/issues/2968
  * volunteer to give him access
  * Richard, happy to give access to second machine - test-nearform_intel-ubuntu1604-x64-2
  * Rod maybe we should try upgrading the least used one first?
  * Rod will add his keys once the meeting is over

* ubuntu 16, quite a lot that still runs on that
  * we can get esm licenses, we just need to say for how many
  * Rod will look with respect to the 16 and above ones that we have

* Raspberry PIs
  * Not running on 18.x
  * still running on earlier versions
  * once we have altra’s running reliability we’ll consider if we can retire PIs

## Q&A, Other


## Upcoming Meetings


* **Node.js Project Calendar**: <https://nodejs.org/calendar>


Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
