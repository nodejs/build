# Node.js Build WorkGroup Meeting 2026-09-24

## Time

**UTC Thu, Sep 24, 2026, 03:00 PM**:

| Timezone | Date/Time |
| -------- | --------- |
| US / Pacific | Thu, Sep 24, 2026, 08:00 AM |
| US / Mountain | Thu, Sep 24, 2026, 09:00 AM |
| US / Central | Thu, Sep 24, 2026, 10:00 AM |
| US / Eastern | Thu, Sep 24, 2026, 11:00 AM |
| EU / Western | Thu, Sep 24, 2026, 04:00 PM |
| EU / Central | Thu, Sep 24, 2026, 05:00 PM |
| EU / Eastern | Thu, Sep 24, 2026, 06:00 PM |
| Moscow | Thu, Sep 24, 2026, 06:00 PM |
| Chennai | Thu, Sep 24, 2026, 08:30 PM |
| Hangzhou | Thu, Sep 24, 2026, 11:00 PM |
| Tokyo | Fri, Sep 25, 2026, 12:00 AM |
| Sydney | Fri, Sep 25, 2026, 01:00 AM |

Or in your local time:

* https://www.timeanddate.com/worldclock/fixedtime.html?msg=Node.js+Foundation+Build%20WorkGroup+Meeting+2026-09-24&iso=20260924T150000
* or https://www.wolframalpha.com/input/?i=03%3A00%20PM+UTC%2C+Sep%2024%2C%202026+in+local+time

## Links

* **Recording**: No recording made
* Minutes: <https://hackmd.io/@openjs-nodejs/H1Mn9bqKMx>
* GitHub Issue: <https://github.com/nodejs/build/issues/4474>

## Present

* Stewart Addison (@sxa)
* Richard Lau (@richardlau)
* Ryan Aslett (@ryanaslett)

### Observers/Guests

_None._

## Agenda

### Announcements

_No announcements._

### Issues and Pull Requests

Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

#### nodejs/build

* Certificates expiring on 2026-10-23 [#4482](https://github.com/nodejs/build/issues/4482)
  * Continuing to be worked - a couple of potential options in terms of whether we use certbot or do it via a call to CloudFlare
* git version(s) for V8 CI [#4476](https://github.com/nodejs/build/issues/4476)
  * For now fixed depot_tools to a specific version to buy us some time.
* Throttle `node-test-commit` jobs on test CI [#4435](https://github.com/nodejs/build/issues/4435)
  * Will keep it with the current limit unless there is a reason to fix it. Avoids excessive parallelism and potential deadlocks on the CI executors
* Build Linux binaries for Node.js 27 on RHEL 9 [#4431](https://github.com/nodejs/build/issues/4431)
* Node.js 20 End-of-Life action items [#4306](https://github.com/nodejs/build/issues/4306)
  * Still in progress but not as a higher priority than other things at present
* Out of space on www server [#3157](https://github.com/nodejs/build/issues/3157)
  * Awaiting putting the clean up job into a cron job
  * Since most distribution is via R2/Cloudflare we should consider if we need all the releases on there. Cloudflare should be going to r2 to get the artifacts and not to www.

## Q&A

* SmartOS latest proposal: https://github.com/nodejs/build/issues/4259#issuecomment-5552011910
  * New proposal from the MNX/Triton team to use a recent smartos distribution and not adding various other illumos distributions for now seems reasonable.
* Proposal to allow a selector to have some platforms run on nightly/release lines but not main: https://github.com/nodejs/build/issues/4457
  * This approach would differ from the approach in `node-daily-master` job which currently calls `node-test-commit` for most of the supported platforms but also separately calls the jobs for `node-test-commit-ibmi`, `node-test-commit-linux-pointer-compression` and `node-test-commit-custom-suites-freestyle (test-internet)`.
  * It would keep the configuration under version control and we would want to consider whether to move those three additional jobs directly under node-test-commit and select them in the same way. An alternative option would be to move distributions with insufficient executors directly under `node-daily-master` as is done for those three jobs, although that would not allow them to be enabled for PRs on the non-`main` branches.
  * It was also mentioned that such a proposal would potentially make it easier to start integrating other platforms such as RISC-V which may not currently have sufficient capacity for full PR testing
* FYI: Alpine tier 2 PR being merged today: https://github.com/nodejs/node/pull/63737
* Purpose of workspace machines was discussed - rebasing and fanned jobs which stuffs binaries into git repo and the test jobs pull the binary from there.

## Upcoming Meetings

* **Calendar**: <https://nodejs.org/calendar>

Click `Add to Google Calendar` at the bottom left to add to your own Google calendar.
