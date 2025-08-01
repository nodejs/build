# Node.js  Build WorkGroup Meeting 2025-07-31

## Links

* **Recording**: https://www.youtube.com/watch?v=x_dJPNOWBQ0
* **GitHub Issue**: https://github.com/nodejs/build/issues/4112
* **Minutes Google Doc**: https://docs.google.com/document/d/116SigWWkmHIj-d-4RD1cZAMqIxQ8c_5Jn3z-Jn-agro

## Present

* Build team: @nodejs/build
* Milad Fa (@miladfarca)
* Ryan Aslett (@ryanaslett) (LF Cloudops)
* Stewart Addison (@sxa)
* Abdirahim Musse (@abmusse)

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Update infrastructure providers list [#4104](https://github.com/nodejs/build/issues/4104)
  * openjs foundation has been trying to unify all the agreements and infrastructure providers.
* Machines at OSUOSL at risk [#4073](https://github.com/nodejs/build/issues/4073)
  * They are still looking for a new home as they are moving datacenters.
* Require Physical 2fa for Build WG & Web Infra members 
[#4063](https://github.com/nodejs/build/issues/4063)
  * Does this still need to be here? Having better security and auth is good, requiring HW keys is not possible. Do we need to push it to TSC to enforce it?
* Potentially transition to 1password for secrets management [#4039](https://github.com/nodejs/build/issues/4039)
  * The main issue is keys are not rotated when we offboard people. Should we create a new vault? Maybe we should ask TSC about this.
* Replace Works on Arm machines affected by Equinix Metal sunset (June 2026) [#3975](https://github.com/nodejs/build/issues/3975)
  * Our usage is unique. We have massive machines that need to replace them very soon. An interim solution is to create some machines on Azure. Next on the agenda.
* Infrastructure for Orka (2024 and beyond) [#3686](https://github.com/nodejs/build/issues/3686)
  * We had to upgrade Orka to support xcode 16. Now we can make all the changes for Node 25 and 26. Trying to determine what versions of osx can we build with.
* Extend Azure credits (Long term) [#3672](https://github.com/nodejs/build/issues/3672)
  * We got less credits this year compared to the past, we are on the path to potentially run out of credits before the renewal. Only about 10 months away. We can also try to reduce costs. We are not using “the cloud” properly. Maybe we need an “on demand” methodology. Same applies to Arm servers. Let's open an Epic to track this.

### nodejs/node

* Enabling Rust support for Temporal [#58730](https://github.com/nodejs/node/issues/58730)
  * We should reach out to SmartOS. Validate and make sure they can support this.


## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
