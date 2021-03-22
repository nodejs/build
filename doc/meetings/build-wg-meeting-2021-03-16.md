# Node.js  Build WorkGroup Meeting 2021-03-16

## Links

* **Recording**:  
* **GitHub Issue**: https://github.com/nodejs/build/issues/2562

## Present

* Michael Dawson (@mhdawson)
* Rod Vagg (@rvagg)
* Richard Lau (@richardlau)
* Ash Cripps (@AshCripps

## Agenda

## Announcements
 
*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Interest in establishing a "Build Helper" role [#2550](https://github.com/nodejs/build/issues/2550)
  * some discussion, no objections
  * next step is to open issue/discussion in core repo to see if there is interest
  * how do we track perms

* Apple silicon builds [#2474](https://github.com/nodejs/build/issues/2474)
  * have new M1s from Mac Stadium - big thank you for providing that
  * Cross compiling from arm to intel as machines are faster
  * Providing separate tars in release should be lowest hanging fruit

* Install Python 3 everywhere in CI [#2507](https://github.com/nodejs/build/issues/2507)
  * PR open on node core for dropping support for Python 2
  * A lot of CI jobs force environment to be Python 2

* Remove explicit setting of PYTHON in CI jobs [#2576](https://github.com/nodejs/build/issues/2576)
  * quick update from Richard

* Compiler platforms
  * Ash, has updated compilers on most
  * smartos is last one that needs the update
  * arm, Rod will take a look at that one.  cc selector already for choosing the right toolchain per
    Version
  * armv7 - Raspberry pi os is still armv7 even though some hardware (Raspberry pi 4) support
    Arvm8

* Download metrics
  * Summaries working, now in JSON
  * Ash will create a new folder on the webserver to serve up the data for people to use



## Q&A, Other

## Upcoming Meetings

* **Node.js Foundation Calendar**: https://nodejs.org/calendar

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
