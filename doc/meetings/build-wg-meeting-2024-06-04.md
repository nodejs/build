# Node.js  Build WorkGroup Meeting 2024-06-04

## Links

* **Recording**:  https://www.youtube.com/watch?v=zgKX48phZOY
* **GitHub Issue**: https://github.com/nodejs/build/issues/3748

## Present

* Abdirahim Musse (@abmusse) 
* Michael Dawson (@mhdawson)
* Michael Zasso (@targos)
* Richard Lau (@richardlau)
* Ryan Aslett (@ryanaslett)
* Ulises Gascon (@UlisesGascon)


## Agenda

## Announcements

*Extracted from **build-agenda** labeled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Infrastructure for Orka (2024 and beyond) [#3686](https://github.com/nodejs/build/issues/3686)
  * Richard asked about upgrade to Orka 3
  * Ryan, wants to propose a new Orka 3 cluster, move to that and then shut down the older one.
    * Agreement to the proposal from Ryan from those in the meeting
  * We agreed to remove support for macos 10.15 and support 11 as the minimum version.
  * Discussion around ephemeral node strategy

* New Machine requirement: Replacement for Equinix x64 servers [#3597](https://github.com/nodejs/build/issues/3597)

  * Ryan started to generate the new machines (SmartOS for now)
  * Discussion around SmartOS patches related to v8 (https://github.com/nodejs/build/issues/3731)
  * Discussion around the current infra and priorities for the migration 

* Discuss state of r2 migration on Build WG meeting [#3508](https://github.com/nodejs/build/issues/3508)
  * No time to cover this topic

* macOS refuses to start `node` when downloaded from the tarball [#3538](https://github.com/nodejs/build/issues/3538)
  * No time to cover this topic

## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.

