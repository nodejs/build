# Node.js  Build WorkGroup Meeting 2024-10-09

## Links

* **Recording**:  https://www.youtube.com/watch?v=e6b5ZBKTacs
* **GitHub Issue**: https://github.com/nodejs/build/issues/3926

## Present

* Ulises Gascón (@UlsiesGascon)
* Richard Lau (@richardlau)
* Michael Dawson (@mhdawson)
* Milad Farazmand (@miladfarca)

## Agenda

## Announcements

* No announcements this week.

### nodejs/build

* Planning/requirements for Node.js 23 [#3807](https://github.com/nodejs/build/issues/3807)
  * Richard - believe it’s done except for macOS infra which is underway and covered by 3686

* Infrastructure for Orka (2024 and beyond) [#3686](https://github.com/nodejs/build/issues/3686)
  * Ryan working on it, Ulises quick summary
    * old cluster has some issues, Ryan mostly fixed those, 18-22 can continue to build on those
      and testing was added back.
    * In TSC meeting we discussed using old infra to release 23, answer seems to be that is not
      possible as we need newer versions of Xcode which requires a newer version of macOS. 
      See nodejs/55181 for more details.
   * Working on new macOS infra, but will not likely be available for the first release of 23. We
     have agreed to ship without it and then will add back in a later point release.


* New Machine requirement: Replacement for Equinix x64 servers
 [#3597](https://github.com/nodejs/build/issues/3597)
  * unencrypted is last critical x86 one, there are a few others like grafana that are more
    “nice to migrate”
  * and also the smartos machines
  * likely no progress, Ryan focussed on the MacOS migration

* macOS refuses to start `node` when downloaded from the tarball [#3538](https://github.com/nodejs/build/issues/3538)
  * No progress

* Discuss state of r2 migration on Build WG meeting [#3508](https://github.com/nodejs/build/issues/3508)
  * Main issue is getting somebody with access to test things. Bit of a challenge
    around testing since you don’t want to push real releases except when doing real
    Releases.  
  * Richard we have to migrate the release Jenkins, but as part of that translation
    maybe we can use the new machines temporarily for testing.

### nodejs/node

* Heads-up: Potential Delay in macOS Infrastructure for Node.js v23 [#55181](https://github.com/nodejs/node/issues/55181)
  * Already discussed above.

## Q&A, Other

* Jenkins LTS will drop support for Java 11 in October: https://github.com/nodejs/build/issues/3916
* Dicussion around issues clean up

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.

