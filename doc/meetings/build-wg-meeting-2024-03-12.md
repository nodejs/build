# Node.js  Build WorkGroup Meeting 2024-03-12

## Links

* **Recording**:  <https://www.youtube.com/watch?v=4uc3SiHid68>
* **Minutes Google Doc**: <https://github.com/nodejs/build/issues/3646>

## Present

* Michael Dawson (@mhdawson)
* Richard Lau (@richardlau)
* Stewart Addison (@sxa)

## Agenda

## Announcements

* No announcements this week

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Nearform can no longer host machines [#3615](https://github.com/nodejs/build/issues/3615)
  * <https://github.com/nodejs/build/issues/3638> - OSX
  * Waiting for proposal for replacement of build machines
  * Richard - End date is end of April
  * Richard, can probably survive if OSX machines are not in place at end date
  * Benchmark machines probably more important to plan for – currently no replacements
    * Follow up email has been sent to Linux Foundation IT team

* New Machine requirement: Replacement for Equinix x64 servers [#3597](https://github.com/nodejs/build/issues/3597)
  * Brian from mnx confirmed they can provide replacements for all of the machines that will
    be going away.
  * Linux IT team should be working with Brian/mnx to onboard the new machines, Linux IT will
    open issue with details of plan and target dates.

* Discuss state of r2 migration on Build WG meeting [#3508](https://github.com/nodejs/build/issues/3508)
  * No update

* IBM closing DAL05, SJC01 and WDC01 data centers 4 April 2024 [#3279](https://github.com/nodejs/build/issues/3279)
  * Richard will look at this week or next week
  * most machines will be moved to different OS levels versus a straight move over

* Infrastructure for MacOS 13.x [#3240](https://github.com/nodejs/build/issues/3240)
  * No update this week

* Interest in establishing a "Build Helper" role [#2550](https://github.com/nodejs/build/issues/2550)
  * No update this week
  * Some cleanup scripts for MacOS, which might be a good fit for adding to AWX. First step is
    to get scripts to point where they can be run from ansible.

### nodejs/admin

* Cloudflare access for @nodejs/web-infra [#833](https://github.com/nodejs/admin/issues/833)
  * We decided to manage access through Terraform, still underway.

## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
