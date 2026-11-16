# Node.js Build WorkGroup Meeting 2026-11-05

## Time

**UTC Thu, Nov 05, 2026, 04:00 PM**:

| Timezone | Date/Time |
| -------- | --------- |
| US / Pacific | Thu, Nov 05, 2026, 08:00 AM |
| US / Mountain | Thu, Nov 05, 2026, 09:00 AM |
| US / Central | Thu, Nov 05, 2026, 10:00 AM |
| US / Eastern | Thu, Nov 05, 2026, 11:00 AM |
| EU / Western | Thu, Nov 05, 2026, 04:00 PM |
| EU / Central | Thu, Nov 05, 2026, 05:00 PM |
| EU / Eastern | Thu, Nov 05, 2026, 06:00 PM |
| Moscow | Thu, Nov 05, 2026, 07:00 PM |
| Chennai | Thu, Nov 05, 2026, 09:30 PM |
| Hangzhou | Fri, Nov 06, 2026, 12:00 AM |
| Tokyo | Fri, Nov 06, 2026, 01:00 AM |
| Sydney | Fri, Nov 06, 2026, 03:00 AM |

Or in your local time:

* https://www.timeanddate.com/worldclock/fixedtime.html?msg=Node.js+Foundation+Build%20WorkGroup+Meeting+2026-11-05&iso=20261105T160000
* or https://www.wolframalpha.com/input/?i=04%3A00%20PM+UTC%2C+Nov%205%2C%202026+in+local+time

## Links

* **Recording**: <https://www.youtube.com/watch?v=dc6NyAFj5SQ>
* Minutes: <https://hackmd.io/@openjs-nodejs/rJv6LPWpze>
* GitHub Issue: <https://github.com/nodejs/build/issues/4548>

## Present

* Build team: @nodejs/build

### Observers/Guests

_None._

## Agenda

### Announcements

_No announcements._

### Issues and Pull Requests

Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

#### nodejs/build

* \[NEXT-SECURITY-RELEASE\] Heads up on upcoming Node.js security release 2026/11/11 [#4555](https://github.com/nodejs/build/issues/4555)
  * Richard will not be available
* Check and backfill notarization of darwin tarballs [#4549](https://github.com/nodejs/build/pull/4549)
  * Ryan has approved Ulises' change and it is ready to go
* Reallocate orka resources now that macos15-x64 is unsupported in v27? [#4540](https://github.com/nodejs/build/issues/4540)
  * No objections to disabling in CI for Node 27 and main. Will also look at reducing jenkins so that it can only provision 1 nodes instead of 3 in test CI.
* Adjust free space threshold for jenkins and allow it to bring machines offline [#4536](https://github.com/nodejs/build/issues/4536)
  * Agreement to trial
  * Concerns around when precisely jenkins performes the check - does it check part way through the job? Shouldn't be too problematic if it does but we should keep an eye on it after enabling.
* jenkins: drop x64 macOS from regular CI testing [#4532](https://github.com/nodejs/build/pull/4532)
  * No objections to disabling in CI for Node 27 and main. Will also look at modifying orka plugin in jenkins so that it can only provision 1 nodes instead of three which will mean we can handle one physical orka x64 node (2 VMs - one for use by test CI, one for release)
* Request for `openssl` on Alpine Linux [#4526](https://github.com/nodejs/build/issues/4526)
  * No objections - will proceed with adding it
* Rethink download metrics processing? [#4519](https://github.com/nodejs/build/issues/4519)
  * Needs someone to be identified to potentially move to CloudFlare in order to remove the need for it
  * What information do we want to retain? Ensure we handle any GDPR etc concerts appropriately. Data migration.
  * To continue discussion in the issue
* Update to clang 21 [#4509](https://github.com/nodejs/build/issues/4509)
  * simdjson was the reason for the original ask, but simdjson has now been patched not to require the newer clangit
  * Remove from build-agenda
* Is gzemnid still required? [#4501](https://github.com/nodejs/build/issues/4501)
  * Machine has been shut down
  * Decide whether to back it up and then delete it
  * Noting that the `nodejs/Gzemnid` repository was last committed to ten months ago
  * gzemnid provides a source level search rather than CitGM's "See what breaks"
* Solidify Digital Ocean Partnership [#4499](https://github.com/nodejs/build/issues/4499)
  * Will remove from build agenda - issue will be closed when formal reply given by LF but our understanding is that we will retain the DigitalOcean services as they are just now.
  * Look at having an "optimise machine usage" issue.
* Node.js 20 End-of-Life action items [#4306](https://github.com/nodejs/build/issues/4306)
  * github bot server is now running on Node 26 LTS
* re-evaluate the containered builds that we run [#4543](https://github.com/nodejs/build/issues/4543)
  * debug builds were moved to arm when we had the Equinix systems with hugea mounts of RAM as they were exhausting memory on x64
  * `ubi81_sharedlibs_openssl111fips_x64` can be removed - already turned off in build
  * Rod experimented with dynamically starting containers but hit some problems with docker itself. Needs to be re-tried
  * Might allow reduced load on the machine if we started the containers as needed, by allowing us to reduce parallelism
  * 3 x64 dockerhosts - one on DigitalOcean and one on IBM Cloud, plus some on arm at Azure
  * Ryan mentioned that there may still be some Azure credits available which we could use for ephemeral builds or other experiments.
  * Node up to 22 still support openssl 1.1.1 e.g. Ubuntu. Support for 1.1.1 has been turned off in Node 27.
  * BoringSSL is currently closer to 1.1.1 in its APIs
  * All of them are using shared libraries build from source in the containers and use a fixed version of the dependency.
  * zlib one is a version built from source to verify that the non-chromium fork of zlib works
  * Some github actions use NIX packages to provide similar functionality. We should look at whether they have enough coverage to remove some of the jenkins jobs.
  * ICU tests explicitly verify builds on the minimal level of ICU that we list as supported.

#### nodejs/node

* darwin tarball binaries are not notarized at release time [#67140](https://github.com/nodejs/node/issues/67140)

#### nodejs/TSC

* Proposal: use Node.js sponsorship funds for additional CI/build capacity on Hetzner [#1903](https://github.com/nodejs/TSC/issues/1903)

## Q&A, Other

## Upcoming Meetings

* **Calendar**: <https://nodejs.org/calendar>

Click `Add to Google Calendar` at the bottom left to add to your own Google calendar.
