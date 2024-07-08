# Node.js  Build WorkGroup Meeting 2024-06-26

## Links

* **Recording**:  <https://www.youtube.com/watch?v=BZfXjR5wuYM>
* **GitHub Issue**: <https://github.com/nodejs/build/issues/3777>

## Present

* Michael Dawson (@mhdawson)
* Ryan Aslett (@ryanaslett)
* Richard Lau (@richardlau)
* Michael Zasso (@targos)

## Agenda

## Announcements

* Richard: migrated 1 Jenkins workspace machine in IBM cloud. Migrated easily. - <https://github.com/nodejs/build/issues/3772>

*Extracted from **build-agenda** labeled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Infrastructure for Orka (2024 and beyond) [#3686](https://github.com/nodejs/build/issues/3686)
  * Ryan reached out to Greg at MacStadium with proposal.
    * Have requested an Orka 3 cluster with arm and x86 in parallel with existing cluster so we
      can migrate machines more easily
    * Issue related to cert, MacOS needs 1 hour downtime to update the cert, they proposed July
      2.  But later noticed they say we might lose some intel nodes.
      * Michael in past they are shut down versus lost, but then they don’t come back in the
        existing slots
      * Richard at one point believe they also sometimes revert to base image, do believe that
    * Deadline for cert update is July 9
    * Ryan will ask to delay the update until July 3th.
  * Richard, there has been a request to update our MacOS version for, will open an issue on versions for Node.js 23 in next week or so, this could be discussed/agreed as part of that.
    * Michael Z, request to drop macOS 12 is harder, since it is still supported.

* New Machine requirement: Replacement for Equinix x64 servers [#3597](https://github.com/nodejs/build/issues/3597)
  * Ryan, focussed on backup server. Old backup was zfs which does more compress, new is
    ext 4 so not enough space.  Proposal to stash data in digital ocean as temporary palace to
    hold it. Workspace are both provisioned with ansible, but shut off.
  * Need to catch up with Richard in how to set up git server. Should likely shut down Jenkins for
    a period of time.
  * Michael any reason not to turn on the new machines ?
  * Ryan no reason, believes it should be working ok.
  * Michael, Richard was it after the security release lockdown, do switch over.
    * Richard yes,
  * Still need to build docker host, replicate unencrypted and grafana
  * Smartos waiting for patches to fix builds on newer Smartos hosts

* macOS refuses to start `node` when downloaded from the tarball [#3538](https://github.com/nodejs/build/issues/3538)
  * No updates (Ulises not present)

* Discuss state of r2 migration on Build WG meeting [#3508](https://github.com/nodejs/build/issues/3508)
  * Believe to be progressing
  * OpenJS Foundation has new agreement with CloudFlare

## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
