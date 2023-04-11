# Node.js  Build WorkGroup Meeting 2020-04-14

## Links

* **Recording**: https://youtu.be/Z5Xro9TcXDc
* **GitHub Issue**: https://github.com/nodejs/build/issues/2272

## Present

* Richard Lau (@richardlau)
* Myles Borins (@MylesBorins)
* Ash Cripps (@AshCripps)
* Michael Dawson (@mhdawson)
* John Kleinschmidt (@jkleinsc)
* Sam Roberts (@sam-github)

## Agenda


## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build


* retrospective on download outage [#2264](https://github.com/nodejs/build/issues/2264)
  * Sam, should we be communicating with Azure, GitHub actions etc, to clarify expectations
    on uptime
  * Myles best thing we can do is to document what level of support (clarifying that there is
    no SLA).
  * Sam, we can encourage larger players (like GitHub) to update examples to avoid the
    dependency, that could make a difference.

* Status page for NodeJS [2265](https://github.com/nodejs/build/issues/2265)
* Automating Email Notifications when there is an "incident" [#2274](https://github.com/nodejs/build/issues/2274)
  * We discussed a bit
    * Willing to look at Atlassian offering as it is SaS and we won’t have something additional to
      maintain.
  * Let’s invite him to the next build WG meeting to bring us up to speed on the meeting
  * Myles has agreed to pitch in and will send request to foundation to get licence to try it out.
  * Ashley good to schedule a meeting in advance.

* Platform requirements for Node.js 14 [#2168](https://github.com/nodejs/build/issues/2168)
  * Using OSX to build (needed for notarization)
  * Installed DevToolSet 8 so we can build on some platforms
  * Remaining issue is updating the cross compiler machine for armv7 from Ubuntu 16.04 to 18.04.
  * Very close to being ready, Release is next Tuesday.

## Q&A, Other

## Upcoming Meetings

* **Node.js Foundation Calendar**: https://nodejs.org/calendar


Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
