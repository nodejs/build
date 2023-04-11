# Node.js  Build WorkGroup Meeting 2020-12-01

## Links

* **Recording**: https://youtu.be/qngUIR5WIMs
* **GitHub Issue**: https://github.com/nodejs/build/issues/2483

## Present

* Build team: @nodejs/build
* Richard Lau (@richardlau)
* Michael Dawson (@mhdawson)
* Rod Vagg
* Rich Trott
* Ash Cripps (@AshCripps)

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

* Ash - Node.js Orka cloud will do down on Dec 10th

### nodejs/build

* Apple silicon builds [#2474](https://github.com/nodejs/build/issues/2474)
  * Still need to get DTKs working again, after OSX update
  * MacStadium do have M1’s but they have high demand, so will get some but likely a bit later
  * Translation layer seems to work, so existing binaries seem to work ok on ARM
  * For building natively only 15.x or higher works
  * Targeting 16.x to do build fat binaries
  * Rod has PR into gyp-next, disables some flags that are used for compiling
  * Michael mentioned - https://github.com/nodejs/build/issues/2474#issuecomment-735446869
     * Current thought is to rely on MacStadium to start then once things settle out a bit more
       potentially look at some redundancy through physical machines

* Ash
  * Making some good progress on the Metrics side. Have something that worked running over
    the weekend.

## Q&A, Other


## Upcoming Meetings


* **Node.js Foundation Calendar**: https://nodejs.org/calendar


Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
