# Node.js Build WorkGroup Meeting 2026-03-19

## Links

* **Recording**: https://www.youtube.com/watch?v=KHAy1ZhhtPg
* **GitHub Issue**: https://github.com/nodejs/build/issues/4271
* **Minutes**: https://hackmd.io/@openjs-nodejs/BkrzACx5bg

## Present

* Milad Fa (@miladfarca)
* Richard Lau (@richardlau)


## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

- CI restricted for security releases: https://github.com/nodejs/build/issues/4276

### nodejs/build

* Certificates expiring on 2026-04-12 [#4274](https://github.com/nodejs/build/issues/4274)
    * Let's not touch the infra until the security releases are done.
    * We need to talk to the foundation on whether the certs will get extended again or a different approach is needed (for the time after this).
* Clarify policy: usage of production tokens in GitHub Actions [#4253](https://github.com/nodejs/build/issues/4253)
* Add rust toolchain to CI machines [#4245](https://github.com/nodejs/build/issues/4245)
    * Not much has changed since our last meeting.
    * We might need to upgrade the version on RHEL, more details: https://github.com/nodejs/build/issues/4265
* Standardise web-infra/admins Cloudflare access [#4194](https://github.com/nodejs/build/issues/4194)
* Upgrading the compiler toolchain [#4091](https://github.com/nodejs/build/issues/4091)
    * Focusing on getting this work on AIX.
    * We might need to upgrade the version on RHEL, more details: https://github.com/nodejs/build/issues/4265
* Extend Azure credits (Long term) [#3672](https://github.com/nodejs/build/issues/3672)

## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `Add to Google Calendar` at the bottom left to add to your own Google calendar.
