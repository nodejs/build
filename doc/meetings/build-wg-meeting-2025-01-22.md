# Node.js  Build WorkGroup Meeting 2025-01-22

## Links

* **Recording**:  <https://youtube.com/live/YLXqRv0LfDY>
* **GitHub Issue**: <https://github.com/nodejs/build/issues/4003>

## Present

* Michael Dawson (@mhdawson)
* Richard Lau (@richardlau)
* Michael Zasso (@targos)
* Joshua M. Clulow (@jclulow)
* Milad Fa (@miladfarca)
* Matthew Benson (Matt Benson)

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Equinix Metal sunset, June 2026 [#3975](https://github.com/nodejs/build/issues/3975)
  * This is equinix metal as a whole is being sunset 2026
  * We have already moved the x86 machines out based on their request
  * We are working to figure out if that affects the ARM machines. Losing those would be
    a significant impact.
  * Richard has already pinged our contact, and he is going to check into it.

* Infrastructure for Orka (2024 and beyond) [#3686](https://github.com/nodejs/build/issues/3686)
  * No update this week
  * This is now the biggest long term issue blocking PR’s working in the project
  * LF IT now has an issue tracking system, we may need to create issues there
  * We should ask Ryan if he wants to add those
    * There are a number of issues blocked on the MacOS upgrades
      * They need a newer compiler which we can only get from the OS upgrade

* New Machine requirement: Replacement for Equinix x64 servers [#3597](https://github.com/nodejs/build/issues/3597)
  * Still 2 machines that were planned for migration (grafana host, unencrypted)
    * might be able to see if we still need unencrypted, via brownouts

* macOS refuses to start `node` when downloaded from the tarball [#3538](https://github.com/nodejs/build/issues/3538)
  * Nobody is looking at it right now.
  * We sign/whatever the installer, but the tarball throughs up the “can’t be opened because the
    identity of the developer cannot be confirmed”
  * only happens if you download with browser, not with a tool
  * Michael Z, my use case is downloading builds from jenkins, not sure
    how to use a tool to get it.

* Discuss state of r2 migration on Build WG meeting [#3508](https://github.com/nodejs/build/issues/3508)
  * Richard, believe this is done
  * Michael Z, 2 pages still being served from DO server, the ones that show the
    download links. There is work to change that.
  * Most requests are now from the broken artifactory systems trying to download npms from
    Nodejs.org

* Meeting time?
  * Discussed and created issue to propose a new time -<https://github.com/nodejs/build/issues/4006>

* SmartOS management
  * Josh and team are going to work towards managing the SmartOS machines
  * Michael, any concerns with working towards that?
    * Richard, the more the merrier
    * No concerns, from anybody else
  * Josh, cannot seem to label and assign issues

### nodejs/node

* These are on the WG agenda as they are being blocked by the MacOS infra
  * src: implement whatwg's URLPattern spec   [#56452](https://github.com/nodejs/node/pull/56452)
  * deps: update simdjson to 3.11.6 [#56250](https://github.com/nodejs/node/pull/56250)
  * \[do not land\] update ada to v3.0-pre [#56218](https://github.com/nodejs/node/pull/56218)
  * V8 updates are also blocked on this

## Q&A, Other

* After we discuss with Ryan, Michael will open an issue on nodejs/build to cover adding
  illumos/SmartOS folks to build WG

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
