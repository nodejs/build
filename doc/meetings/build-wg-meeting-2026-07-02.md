# Node.js Build WorkGroup Meeting 2026-07-02

## Time

**UTC Thu, Jul 02, 2026, 03:00 PM**:

| Timezone | Date/Time |
| -------- | --------- |
| US / Pacific | Thu, Jul 02, 2026, 08:00 AM |
| US / Mountain | Thu, Jul 02, 2026, 09:00 AM |
| US / Central | Thu, Jul 02, 2026, 10:00 AM |
| US / Eastern | Thu, Jul 02, 2026, 11:00 AM |
| EU / Western | Thu, Jul 02, 2026, 04:00 PM |
| EU / Central | Thu, Jul 02, 2026, 05:00 PM |
| EU / Eastern | Thu, Jul 02, 2026, 06:00 PM |
| Moscow | Thu, Jul 02, 2026, 06:00 PM |
| Chennai | Thu, Jul 02, 2026, 08:30 PM |
| Hangzhou | Thu, Jul 02, 2026, 11:00 PM |
| Tokyo | Fri, Jul 03, 2026, 12:00 AM |
| Sydney | Fri, Jul 03, 2026, 01:00 AM |

Or in your local time:

* https://www.timeanddate.com/worldclock/fixedtime.html?msg=Node.js+Foundation+Build%20WorkGroup+Meeting+2026-07-02&iso=20260702T150000
* or https://www.wolframalpha.com/input/?i=03%3A00%20PM+UTC%2C+Jul%202%2C%202026+in+local+time

## Links

* **Recording**: https://www.youtube.com/watch?v=2YE6iceVE-o
* Minutes: <https://hackmd.io/@openjs-nodejs/BJNLz8jfGg>
* GitHub Issue: <https://github.com/nodejs/build/issues/4382>

## Present

* Abdirahim Musse (@abmusse)
* Milad Fa (@miladfarca)
* Richard Lau (@richardlau)
* Ryan Aslett (@ryanaslett)
* Stewart Addison (@sxa)

Noting that Juan José attemped to join but was unable to using the link in the meeting which we should look to resolve for the next one.

### Observers/Guests

_None._

## Agenda

### Announcements

_No announcements._

### Issues and Pull Requests

Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

#### nodejs/build

* Potentially add libclang as a build dependency [#4350](https://github.com/nodejs/build/issues/4350)
  * Nothing new. Remove from agenda for now.
* Node.js 20 End-of-Life action items [#4306](https://github.com/nodejs/build/issues/4306)
  * Some Windows machines removed.
  * Some services still running on Node.js 20.
  * Confirmation macOS 13 still needed for Node.js 22 and 24.
* Upgrade to Clang 20 and Rust 1.88  [#4265](https://github.com/nodejs/build/issues/4265)
  * PR for Debian 13: https://github.com/nodejs/build/pull/4389
  * Ubuntu 24.04 not done yet.

## Q&A, Other

* Alpine to tier 2 is approved by the TSC so we need to consider how to make it available in the release CI before formally merging [PR63737](https://github.com/nodejs/node/pull/63737).
  * We have three Linux/x64 machines in the release CI which can lead to slowness if the ccaches are invalidated so are looking to drop this to two as per https://github.com/nodejs/build/issues/4390
  * This would free up one x64 machine which could be used for Alpine
  * If we leave the machine running RHEL8 then we would need to look at how to run the container. The playbooks have code to run some container images with `docker` on Ubuntu hosts but if we leave the machine as RHEL8 then `podman` would likely be the preferred option
  * We discussed the version of Alpine to use and ultimately decided that as long as it was one that was suitable for the versions used in the docker images then it would be ok
  * Subject to any build toolchain restrictions we will aim to build on the oldest or second oldest supported Alpine version at any given time and move it up when an Alpine release goes out of support. New Alpine releases occur every six motnhs and are supported for approximately two years.
* Coverity.
  * Currently broken https://github.com/nodejs/build/issues/4287
  * Add Ryan as owner.
* SmartOS: An [update came through regarding Illumos](https://github.com/nodejs/build/issues/4259#issuecomment-4867539795) during the meeting. We need to look at that message and determine which machines/distributions we want to support and include in the CI axes. We have removed smartos22 from the CI already so only have 23. The update includes an offer of additional smartos24/25 systems and also OmniOS machines. We should consider this in view of clang/rust availability and look to have a decision approved at the next build WG meeting.

## Upcoming Meetings

* **Calendar**: <https://nodejs.org/calendar>

Click `Add to Google Calendar` at the bottom left to add to your own Google calendar.
