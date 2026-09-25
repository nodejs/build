# Node.js Build WorkGroup Meeting 2026-08-13

## Time

**UTC Thu, Aug 13, 2026, 03:00 PM**:

| Timezone | Date/Time |
| -------- | --------- |
| US / Pacific | Thu, Aug 13, 2026, 08:00 AM |
| US / Mountain | Thu, Aug 13, 2026, 09:00 AM |
| US / Central | Thu, Aug 13, 2026, 10:00 AM |
| US / Eastern | Thu, Aug 13, 2026, 11:00 AM |
| EU / Western | Thu, Aug 13, 2026, 04:00 PM |
| EU / Central | Thu, Aug 13, 2026, 05:00 PM |
| EU / Eastern | Thu, Aug 13, 2026, 06:00 PM |
| Moscow | Thu, Aug 13, 2026, 06:00 PM |
| Chennai | Thu, Aug 13, 2026, 08:30 PM |
| Hangzhou | Thu, Aug 13, 2026, 11:00 PM |
| Tokyo | Fri, Aug 14, 2026, 12:00 AM |
| Sydney | Fri, Aug 14, 2026, 01:00 AM |

Or in your local time:

* https://www.timeanddate.com/worldclock/fixedtime.html?msg=Node.js+Foundation+Build%20WorkGroup+Meeting+2026-08-13&iso=20260813T150000
* or https://www.wolframalpha.com/input/?i=03%3A00%20PM+UTC%2C+Aug%2013%2C%202026+in+local+time

## Links

* Minutes: <https://hackmd.io/@openjs-nodejs/Hk55m3zUzl>
* GitHub Issue: <https://github.com/nodejs/build/issues/4417>

## Present

* Stewart Addison (@sxa)
* Milad Fa (@miladfarca)
* Ryan Aslett (@ryanaslett)
* Abdirahim Musse (@abmusse)
* Richard Lau (@richardlau)

### Observers/Guests

_None._

## Agenda

### Announcements

_No announcements._

### Issues and Pull Requests

Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

#### nodejs/build

* "CBN" revalidation on the firewall holes for the release team. [#4424](https://github.com/nodejs/build/issues/4424)
  * No objections to cleaning up the list
  * CloudFlare jumphost with Spectrum already in place 
  * Could we use "Cloudflare zero trust" going forward?
* OSUOSL decommissioning POWER8 [#4405](https://github.com/nodejs/build/issues/4405)
  * Since all our POWER8 systems were migrated to POWER9 we now have more POWER9 than we need
  * Perhaps check if we can reprovision some as POWER10 to better use the capacity?
  * Upcoming decomissioning of some older POWER systems in December 2027 in IBM Cloud
* Node.js 20 End-of-Life action items [#4306](https://github.com/nodejs/build/issues/4306)
  * webhooks remaining. github bot and maybe unofficial-builds
  * Playbook updates required to install later version of node
* Standardise web-infra/admins Cloudflare access [#4194](https://github.com/nodejs/build/issues/4194)
  * Should we change the names on some of the groups?
  * Should they match the node groups? General acceptance that this is a good idea to more easily justify and understand access. There is already webadmins r/w and web-infra group r/o. 

#### nodejs/node

* build: show CI results on PR [#64483](https://github.com/nodejs/node/pull/64483)
  * Jenkins currently has no functional ability to call out
  * GitHub bot specifically allows access from the jenkins-workspace machines to report status to the PRs
  * Should we move away from github bot to GitHub Actions given the lack of understanding of the current process? (May be existing issue on that)
  * May be possible to update github bot to return the test status but would need further analysis
  * Should we have the list of uses of the build github account (there are at least two) documented?

## Q&A, Other

* Alpine agent for release CI: https://github.com/nodejs/build/issues/4423#issuecomment-5279010367
  * Preferred option is to add the alpine parts into the linux section of iojs+release
  * "alpine-x64-release" as the label is appropriate
  * Intend to enable it across all active release lines
  * Will potentially need modification to the website to be able to find it, but for the initial need for having official builds for Docker this will be good.
  * Look at implications for third party tools especially nvm

## Upcoming Meetings

* **Calendar**: <https://nodejs.org/calendar>

Click `Add to Google Calendar` at the bottom left to add to your own Google calendar.
