# Node.js  Build WorkGroup Meeting 2024-09-18

## Links

* **Recording**:  https://www.youtube.com/watch?v=QUV3Rsp1AuU
* **GitHub Issue**: https://github.com/nodejs/build/issues/3912
* **Minutes Google Doc**: https://docs.google.com/document/d/1MCOs0mYz2HdYT1jIOHkaK0iIGhENxnWtLk_oRWSvFa8/edit

## Present

* Build team: @nodejs/build
* Ulises Gascon (@ulisesGascon)
* Michael Zasso (@targos)
* Richard Lau (@richardlau)


## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* NodeJS STF Future State [#3854](https://github.com/nodejs/build/issues/3854)
  * No updated
* Planning/requirements for Node.js 23 [#3807](https://github.com/nodejs/build/issues/3807)
  * GCC 12 is installed on all Linuxes except SmartOS which will hopefully be taken care of by the migration off Equinix work (as we’ll need to move to a newer version of SmartOS which have a later version of gcc by default).
  * Windows seems ok. We are not yet ready to switch to ClangCL
  * macOS depends on [#3686](https://github.com/nodejs/build/issues/3686)
* Infrastructure for Orka (2024 and beyond) [#3686](https://github.com/nodejs/build/issues/3686)
  * Most updated info: https://github.com/nodejs/build/issues/3686#issuecomment-2278119351
  * Need to discuss with macStadium adding more nodes.
* New Machine requirement: Replacement for Equinix x64 servers [#3597](https://github.com/nodejs/build/issues/3597)
  * No updates
* macOS refuses to start `node` when downloaded from the tarball 
[#3538](https://github.com/nodejs/build/issues/3538)
  * No Updates
* Discuss state of r2 migration on Build WG meeting [#3508](https://github.com/nodejs/build/issues/3508)
  * Current challenges on promoting the releases (hard to debug).

## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.

