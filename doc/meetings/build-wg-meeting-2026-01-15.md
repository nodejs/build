# Node.js Build WorkGroup Meeting 2026-01-15

## Links

* **Recording**: https://www.youtube.com/watch?v=4yOtiGQY5oI
* **GitHub Issue**: https://github.com/nodejs/build/issues/4211
* **Minutes**: https://hackmd.io/@openjs-nodejs/BkgpeATpNZg

## Present

* Milad Fa (@miladfarca)
* Richard Lau (@richardlau)
* Ulises Gascón (@UlisesGascon)


## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Investigate if embargo/lockdown can be better communicated [#4203](https://github.com/nodejs/build/issues/4203)
    * Current security release took longer than usual and we like to better communicate such issues on Jenkins.
    * Added new Jenkins plugin that can display system messages on all Jenkins pages (including the error page if your access has been restricted).
* Standardise web-infra/admins Cloudflare access [#4194](https://github.com/nodejs/build/issues/4194)
    * We can manually grant access when needed but it's not ideal.
* Upgrading the compiler toolchain [#4091](https://github.com/nodejs/build/issues/4091)
    * Maybe ping SmartOS maintainers again.
    * Most Linux platforms have already switched to Clang.
    * Let's create a list of remaining platforms.
* Extend Azure credits (Long term) [#3672](https://github.com/nodejs/build/issues/3672)

### nodejs/node

* Enabling Rust support for Temporal [#58730](https://github.com/nodejs/node/issues/58730)
    * We have code in Node.js and V8 to enable it. Need to update CI machines and install the Rust toolchain.
    * There is a PR to update to V8 14.4 which is failing now.

## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `Add to Google Calendar` at the bottom left to add to your own Google calendar.
