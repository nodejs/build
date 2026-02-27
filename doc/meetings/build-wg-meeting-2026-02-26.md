# Node.js Build WorkGroup Meeting 2026-02-26

## Links

* **Recording**: https://www.youtube.com/watch?v=OfNnrJyQ_5Q
* **GitHub Issue**: https://github.com/nodejs/build/issues/4252
* **Minutes**: https://hackmd.io/@openjs-nodejs/S1YHRQHdZx

## Present

* Milad Fa (@miladfarca)
* Richard Lau (@richardlau)
* Ryan Aslett (@ryanaslett)
* Stewart Addison (@sxa)
* Abdirahim Musse (@abmusse)

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Clarify policy: usage of production tokens in GitHub Actions [#4253](https://github.com/nodejs/build/issues/4253)
    * This still could be an issue, it's still possible for tokens to get leaked.
* Add rust toolchain to CI machines [#4245](https://github.com/nodejs/build/issues/4245)
    * Not all the machines need to have Rust, we need a list of machines which need Rust installed.
* Standardise web-infra/admins Cloudflare access [#4194](https://github.com/nodejs/build/issues/4194)
    * Cloudlfare now has groups and other org management methods which we could make use of.
* Upgrading the compiler toolchain [#4091](https://github.com/nodejs/build/issues/4091)
    * AIX is currently being looked at.
    * Build failed because it was missing header files.
    * Ryan to add Ubuntu 24.04 machines on Hetzner to Ansible inventory.
* Extend Azure credits (Long term) [#3672](https://github.com/nodejs/build/issues/3672)
    * We might be getting more credits to support Windows and Arm.

### nodejs/node

* Enabling Rust support for Temporal [#58730](https://github.com/nodejs/node/issues/58730)
    * Work in progress to put Rust on our machines (tracked by #4245).

## Q&A, Other

* Ryan: Shared storage for macOS is full. Possibly misreporting?
  * Plan to replace shared storage with valkey/redis based ccache.
  * Taking a long time to clean up the existing shared storage.

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `Add to Google Calendar` at the bottom left to add to your own Google calendar.
