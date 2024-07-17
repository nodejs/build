# Node.js  Build WorkGroup Meeting 2024-07-16

## Links

* **Recording**:  <https://www.youtube.com/watch?v=xFzHCaNru54>
* **GitHub Issue**: <https://github.com/nodejs/build/issues/3831>

## Present

* Michael Dawson (@mhdawson)
* Richard Lau (@richardlau)
* Ryan Aslett (@ryanaslett)
* Abdirahim Musse (@abmusse)

## Agenda

## Announcements

*Extracted from **build-agenda** labeled issues and pull requests from the **nodejs org** prior to the meeting.

* No announcements this week

### nodejs/build

* Planning/requirements for Node.js 23 [#3807](https://github.com/nodejs/build/issues/3807)
  * Richard need to decide what infra changes we need/want. Good to have in place for Sep
    to be ready for 23 in Oct.
    * for example proposal is to move up to gcc 12
    * only question would be for 32 bit arm binaries, did find that moving on this shifted glibc level
      (others are compiled with RHEL toolset which preserves the glibc level)

* Infrastructure for Orka (2024 and beyond) [#3686](https://github.com/nodejs/build/issues/3686)
  * Ryan, met with MacStadium twice.
  * They would like us to upgrade the clusters to Orca 3, they can then move slightly larger arm
    nodes into the cluster
  * Once we have images, then images can be stood up/spun down on demand
  * Should be able to support 12, 13 going forward
  * Understand that we need 10.15 until April 2025 when 18.x goes out of support.
    * Richard we have had times where we could not test minimum level supported, but better if
      we can
  * Michael, can we image the existing machines, Ryan possibly
  * Michael, will the infra be ready a month or more before 23, Ryan will be priority after equinix
    move so should be

* New Machine requirement: Replacement for Equinix x64 servers [#3597](https://github.com/nodejs/build/issues/3597)
  * Backup instance is up and running, believe this is ready to give back (Michael/Richard agreed)
  * 2 Workspace machine should be ready to give back
  * smartos machines, have not seen progress
    * need to turn them off, should reach out to Briana again
    * Michael, suggested we should set up a meeting with them
  * 3 more instances after those
    * unencrypted, hot standby for the www
      * seems to flaps regularly
      * Ryan, good ansible? Michael don’t think so.
      * Michael, there is an effort to use cloudflare workers
    * grafana,
      * Richard slack integration, monitoring disk space for 4-5 machines
      * Richard, likely not in ansible
      * Will do if simple
    * Last one is node cross compiling container server
      * Richard
        * only release container machines. Ubuntu 1804 - docker host
        * does not need to be 1804
        * Should be ansible playbook for it

* macOS refuses to start `node` when downloaded from the tarball [#3538](https://github.com/nodejs/build/issues/3538)
  * No update

* Discuss state of r2 migration on Build WG meeting [#3508](https://github.com/nodejs/build/issues/3508)
  * A change was merged, broke release workflow. It was partially backed out to allow the security release to happen. 
  * Subsequent fix has been applied but looks like there might be an issue promoting nightlies in R2.

## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
