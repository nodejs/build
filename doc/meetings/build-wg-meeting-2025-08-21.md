# Node.js  Build WorkGroup Meeting 2025-08-21

## Links

* **Recording**: https://www.youtube.com/watch?v=bAyjcOBx0Uk
* **GitHub Issue**: https://github.com/nodejs/build/issues/4125
* **Minutes Google Doc**: https://docs.google.com/document/d/1kW79pNiMQpF8Z18i1ud1B9uoN5s3s8-xC0qwsoo2yQM/

## Present

* Build team: @nodejs/build
* Milad Fa @miladfarca
* Richard Lau
* Ryan Aslett
* Duc Thien @iuuukhueeee
* Abdirahim Musse @abmusse


## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Update infrastructure providers list [#4104](https://github.com/nodejs/build/issues/4104)
  * The list of infrastructure providers is outdated.
* Upgrading the compiler toolchain [#4091](https://github.com/nodejs/build/issues/4091)
  * Working on RHEL machines, needed fixes on ppc64 and s390x. Will skip some tests on ppc64 for now to land the PR.
* Machines at OSUOSL at risk [#4073](https://github.com/nodejs/build/issues/4073)
  *  We could fall back to IBM Cloud if needed (at least for a short term).
* Potentially transition to 1password for secrets management [#4039](https://github.com/nodejs/build/issues/4039)
* Replace Works on Arm machines affected by Equinix Metal sunset (June 2026) [#3975](https://github.com/nodejs/build/issues/3975)
  * They haven't shut off the machine yet! We have a bit of budget on Azure which we could make use of.
* Infrastructure for Orka (2024 and beyond) [#3686](https://github.com/nodejs/build/issues/3686)
  * Should close this issue and focus on https://github.com/nodejs/build/issues/4083.
* Extend Azure credits (Long term) [#3672](https://github.com/nodejs/build/issues/3672)
  * We have 20% left. Hopefully will not have any problems with Azure resources in the future.

### nodejs/node

* Enabling Rust support for Temporal [#58730](https://github.com/nodejs/node/issues/58730)
  * Work in progress, will make changes once Clang changes have finalized.

* GitHub Secure Open Source Fund
  * https://resources.github.com/github-secure-open-source-fund/

## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
