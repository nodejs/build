# Node.js Build WorkGroup Meeting 2026-09-03

## Time

**UTC Thu, Sep 03, 2026, 03:00 PM**:

| Timezone | Date/Time |
| -------- | --------- |
| US / Pacific | Thu, Sep 03, 2026, 08:00 AM |
| US / Mountain | Thu, Sep 03, 2026, 09:00 AM |
| US / Central | Thu, Sep 03, 2026, 10:00 AM |
| US / Eastern | Thu, Sep 03, 2026, 11:00 AM |
| EU / Western | Thu, Sep 03, 2026, 04:00 PM |
| EU / Central | Thu, Sep 03, 2026, 05:00 PM |
| EU / Eastern | Thu, Sep 03, 2026, 06:00 PM |
| Moscow | Thu, Sep 03, 2026, 06:00 PM |
| Chennai | Thu, Sep 03, 2026, 08:30 PM |
| Hangzhou | Thu, Sep 03, 2026, 11:00 PM |
| Tokyo | Fri, Sep 04, 2026, 12:00 AM |
| Sydney | Fri, Sep 04, 2026, 01:00 AM |

Or in your local time:

* https://www.timeanddate.com/worldclock/fixedtime.html?msg=Node.js+Foundation+Build%20WorkGroup+Meeting+2026-09-03&iso=20260903T150000
* or https://www.wolframalpha.com/input/?i=03%3A00%20PM+UTC%2C+Sep%203%2C%202026+in+local+time

## Links

* **Recording**: <https://www.youtube.com/watch?v=ioQhe4UZf9E>
* Minutes: <https://hackmd.io/@openjs-nodejs/Sk9C6_0DMx>
* GitHub Issue: <https://github.com/nodejs/build/issues/4444>

## Present

* Stewart X Addison (@sxa)
* Milad Fa (@miladfarca)
* Richard Lau (@richardlau)
* Abdirahim Musse (@abmusse)

### Observers/Guests

_None._

## Agenda

### Announcements

_No announcements._

### Issues and Pull Requests

Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

#### nodejs/build

* Throttle `node-test-commit` jobs on test CI [#4435](https://github.com/nodejs/build/issues/4435)
  * Post builds and git-rebase jobs are both running on the jenkins-workspace machines.
  * Possibly move some of the jobs onto a dedicated executor
  * Design of pipelines might be an option to look at it
  * Keep it at 15 for now
  * Is capacity on the CI generally a concern?
  * Possibly also look at monitoring the queue depths over time. We may already have something to check for the number of live executors
* Build Linux binaries for Node.js 27 on RHEL 9 [#4431](https://github.com/nodejs/build/issues/4431)
  * Runtime implications for people on older (usually unsupported) operating systems with older glibc levels
  * Could be feasible to build in a dynamically created RHEL8 container but that is not the favoured approach
  * Can continue for now to also build/test on RHEL8 in the test CI so no immediate implication on the test CI
  * Applicable for Linux/glibc builds on x64, aarch64, ppc64le, s390x
  * Would need additional RHEL9 machines on each platform in the release CI
  * Announce as part of the alpha release in October
* "CBN" revalidation on the firewall holes for the release team. [#4424](https://github.com/nodejs/build/issues/4424)
  * Discussed in last call and we should go ahead with it
* OSUOSL decommissioning POWER8 [#4405](https://github.com/nodejs/build/issues/4405)
  * Likely no further action required - Richard to close this out
* Node.js 20 End-of-Life action items [#4306](https://github.com/nodejs/build/issues/4306)
  * Still ned to deal with webhook and bot which are on Node.js 20
* Out of space on www server [#3157](https://github.com/nodejs/build/issues/3157)
  * Needs to be scheduled - probably just as a cron job on the machine
  * Do we need the www server any more? Was originally to serve downloads and website. Website is on Vercel and downloads are staged on www server but hosted on R2 for public access.
    * Would require modifications to the release processes
    * Check if nightly builds are using it or using R2 (should be R2)
    * sxa to create an issue to discuss potentially not using www any more, or changing its role: [#4488](https://github.com/nodejs/build/issues/4488)

## Q&A, Other

* Extended outage on LinuxOne (Linux/s390x) machines occurring starting the week of the 9th September: https://github.com/nodejs/build/issues/4450
  * One of their z15 will be switched off. Our VMs are split across the physical machines
  * Our RHEL8 machines (including the release CI one) are not on the machine that is being disabled. All but one of the RHEL9 are on that z15. The linuxone builds on RHEL9 typically complete in about 30 minutes so is relatively fast so we expect to be able to cope with the reduction in capacity during the week while the systems are migrated to the new z17 hardware.
* Disk space on test CI server:
  * Could we enable log compression for everything? What would the implications on CPU load be?
  * Increase disk space on the server. test results are uncompressed and so will be taking up space regardless.
  * logcompress is currently set to retain 5 days of logs - expect to drop that to 4 as we are currently running at 96% disk capacity
  * Unclear at the moment how much headroom we have to increase the capacity. Aim to discuss with LF about feasibility on the digitalocean account
* Two issues raised relating to the multijob plugin. Should we move away from it (likely to plugins). Would need the resume functionality to be able to handle flaky CI runs. Noting that in the multijob plugin yellow status (due to flakes) are acceptable for the purposes of merging PRs, but they will be re-run on a "resume" operation
* Could we eliminate the fanned jobs? arm fanned job is only run via the versionselector for arm32 so not for anything later than Node 22 (Does it run git-rebase).  Windows is fanned for two reasons:
  * To build once and test on multiple different distributions
  * Splitting the tests into four subsets of jobs. Does it make sense to keep doing this or could we just run them all together. Aim to discuss with Stefan.
  * Would ephemeral machines in Azure be a good approach?

## Upcoming Meetings

* **Calendar**: <https://nodejs.org/calendar>

Click `Add to Google Calendar` at the bottom left to add to your own Google calendar.
