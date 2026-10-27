# Node.js Build WorkGroup Meeting 2026-10-15

## Time

**UTC Thu, Oct 15, 2026, 03:00 PM**:

| Timezone | Date/Time |
| -------- | --------- |
| US / Pacific | Thu, Oct 15, 2026, 08:00 AM |
| US / Mountain | Thu, Oct 15, 2026, 09:00 AM |
| US / Central | Thu, Oct 15, 2026, 10:00 AM |
| US / Eastern | Thu, Oct 15, 2026, 11:00 AM |
| EU / Western | Thu, Oct 15, 2026, 04:00 PM |
| EU / Central | Thu, Oct 15, 2026, 05:00 PM |
| EU / Eastern | Thu, Oct 15, 2026, 06:00 PM |
| Moscow | Thu, Oct 15, 2026, 06:00 PM |
| Chennai | Thu, Oct 15, 2026, 08:30 PM |
| Hangzhou | Thu, Oct 15, 2026, 11:00 PM |
| Tokyo | Fri, Oct 16, 2026, 12:00 AM |
| Sydney | Fri, Oct 16, 2026, 02:00 AM |

Or in your local time:

* https://www.timeanddate.com/worldclock/fixedtime.html?msg=Node.js+Foundation+Build%20WorkGroup+Meeting+2026-10-15&iso=20261015T150000
* or https://www.wolframalpha.com/input/?i=03%3A00%20PM+UTC%2C+Oct%2015%2C%202026+in+local+time

## Links

* **Recording**: https://www.youtube.com/watch?v=fKeuT8VQNxM
* Minutes: <https://hackmd.io/@openjs-nodejs/SJVlnhSjzx>
* GitHub Issue: <https://github.com/nodejs/build/issues/4510>

## Present

* Abdirahim Musse (@abmusse)
* Juan (@juanarbol)
* Richard Lau (@richardlau)
* Ryan Aslett (@ryanaslett)
* Stewart Addison (@sxa)
* Ulises Gascon (@ulisesgascon)

### Observers/Guests

_None._

## Agenda

### Announcements

_No announcements._

### Issues and Pull Requests

Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

#### nodejs/build

* \[NEXT-SECURITY-RELEASE\] Heads up on upcoming Node.js security release 2026/10/21 [#4520](https://github.com/nodejs/build/issues/4520)
  * No current planned outages during that time so no specific action required at this time
  * Richard observed that in some recent releases some of the ssh connections to the `www` staging server has dropped and needs to be re-run
  * There may be potential to use an agent to put these release entries into a unified calendar across all releases (security or otherwise)
* Rethink download metrics processing? [#4519](https://github.com/nodejs/build/issues/4519)
  * Currently being done on a Google Cloud account which is pulling from CloudFlare and storing in the google account
  * Need to identify the origin of the Google account currently being used and check its funding status and check if it is still being made available then make any required decisions on it. Matteo potentially doing graphs with the data.
  * Potential migration issue and whether old data needs to be retained. Noted that we had a gap in the total data around the time when the cloudflare cache was introduced.
  * Access to anyone outside the groups who wanted to volunteer for this would have to be granted access by build WG
* Python 3.10 EOL 2026-10-01 used in Windows [#4514](https://github.com/nodejs/build/issues/4514)
  * Version of python on windows was pinned to 3.10 because an old version of Node didn't build with it.
  * Discussions ongoing in the issue, so no action required by the Build WG at present until we have a conclusion in there.
* Update to clang 21 [#4509](https://github.com/nodejs/build/issues/4509)
* Is gzemnid still required? [#4501](https://github.com/nodejs/build/issues/4501)
  * Nobody claiming to be using it so far, so we will shut it down to see if anything breaks.
  * Also running Ubuntu 18.04 (out of support)
  * Will revisit at next build WG meeting and potentially fully shut it down
* Solidify Digital Ocean Partnership [#4499](https://github.com/nodejs/build/issues/4499)
  * Discussions ongoing with Linux Foundation. No specific updates at this time
* Certificates expiring on five machines on 2026-10-23 [#4482](https://github.com/nodejs/build/issues/4482)
  * Ryan continuing to look at migrating to letsencrypt
  * Noted that a schedule of releases (as per discussion point above) would be useful for knowing when outages can be done.
  * All are using nginx so expected that it will be a very short outage (likely won't affect people)
  * Aim to complete this before the end of the week. If it needs to be moved to net week we should have a further discussion to ensure noimpact to the upcoming security releases.
* Throttle `node-test-commit` jobs on test CI [#4435](https://github.com/nodejs/build/issues/4435)
  * Will close this issue since we are going to leave it in place
* Node.js 20 End-of-Life action items [#4306](https://github.com/nodejs/build/issues/4306)
  * No updates
* Out of space on www server [#3157](https://github.com/nodejs/build/issues/3157)
  * Will remove `build-agenda` label for this
  * Create issue for "Release build retention" (https://github.com/nodejs/build/issues/4530)

#### nodejs/TSC

* Proposal: use Node.js sponsorship funds for additional CI/build capacity on Hetzner [#1903](https://github.com/nodejs/TSC/issues/1903)
  * Build WG had some questions about the specific motivation for the proposal which will be asked in the issue. We need to define the problem that this would solve before making a decision

## Q&A, Other
* Potentially look at having maintence windows for updating jenkins etc.
  * Maybe look at delaying some/all updates (docker/java can be problematic) rather than having the OS auto-update everything
  * Noting that for security it is generally preferable to have things auto-update but we know some packages cause problems when done in the background so we should carefully evaluate the potential impact of such a change

## Upcoming Meetings

* **Calendar**: <https://nodejs.org/calendar>

Click `Add to Google Calendar` at the bottom left to add to your own Google calendar.
