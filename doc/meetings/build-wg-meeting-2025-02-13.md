# Node.js  Build WorkGroup Meeting 2025-02-13

## Links

* **Recording**:  <https://www.youtube.com/watch?v=HCSAUDCPqxI>
* **GitHub Issue**: <https://github.com/nodejs/build/issues/4017>

## Present

* Michael Dawson (@mhdawson)
* Milad Farazmand (@miladfarca)
* Richard Lau (@richardlau)
* Michael Zasso (@targos)
* Ryan Aslett (@ryanaslett)

## Agenda

## Announcements

* No announcements this week.

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Equinix Metal sunset, June 2026 [#3975](https://github.com/nodejs/build/issues/3975)
  * Richard, related to works on arm machines
  * Waiting to hear from Ed what this means to the project
  * Michael maybe we should ask for some resources form OSL
    * Richard we already have machines, problem is that they are much smaller
  * Richard will follow up with Ed

* Infrastructure for Orka (2024 and beyond) [#3686](https://github.com/nodejs/build/issues/3686)
  * Ryan
    * everything it transitioned over to the new Orka cluster
    * We have 2 intel nodes and 2 arm nodes, each can host 2 vms
    * Main pain point is that some runs are still way too slow
      * intel build/test
      * release jobs
    * Also still using osx 13 images, but need to move to osx 14 because current setup is not
      really supported
      * Ryan requirement for minimum in project testing?
        * Richard, we’ve been forced into building on what we can get and trust the setting we
          have to set the minimum target based on availability of hw and OS versions.
        * Michael we have never had reported problems with this approach so moving to 14 makes
          sense
        * No objections were raised, agreed we can move to OSX 14 when Ryan has time
    * intel nodes are on older CPUs, 8x slower, which does not make a lot of sense, seems like
      shared file systems are really slow, have been pinging Mac stadium
    * Michael Z, releases are still taking way too long
      * Ryan, ccache is still on enabled, so that explains it
      * Richard, it builds twice, so will be twice as long
    * Ryan, release machines only used a few times a day, but no way to give them priority so we
      can share for use in testing.

* New Machine requirement: Replacement for Equinix x64 servers [#3597](https://github.com/nodejs/build/issues/3597)
  * Ryan, all smartos has been moved, 3 machines are still provisioned, ubuntu 18, grafana,
    and unencrypted which is secondary failover for web site
    * Richard, it is still configured in cloudflare, downloads are mainly served through R2, used to
      get lost of failover messages, only one in the last few months.
    * Maybe its no longer needed, Michael has mentioned that maybe we should do some brown
      outs to test.
    * unencrypted is still used to support rsync
    * Plan
      * turn off ubuntu 18 and grafana
      * for unencrypted, find option to support rsync, plan move
    * Hard deadline of May as somebody has to start paying if not moved before then

* macOS refuses to start `node` when downloaded from the tarball [#3538](https://github.com/nodejs/build/issues/3538)
  * no update

* Discuss state of r2 migration on Build WG meeting [#3508](https://github.com/nodejs/build/issues/3508)
  * no updates but believe it is pretty much finished, we agreed to remove from the build agenda.

## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
