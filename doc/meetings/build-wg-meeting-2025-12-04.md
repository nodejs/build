# Node.js Build WorkGroup Meeting 2025-12-04

## Links

* **Recording**:  
* **GitHub Issue**: https://github.com/nodejs/build/issues/4192
* **Minutes**: https://hackmd.io/@openjs-nodejs/ByvbRvUWWx

## Present

* Build team:
* Milad Fa (@miladfarca)
* Richard Lau (@richardlau)
* Stewart Addison (@sxa)
* Ulises Gascón (@ulisesGascon)

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Standardise web-infra/admins Cloudflare access [#4194](https://github.com/nodejs/build/issues/4194)
    * Seems like a great opportunity to revive the Terraform initiative [#3270](https://github.com/nodejs/build/issues/3270). It will require some work to see the current state of the stack and the potential risks of using production tokens on GitHub Actions.
    * If we conclude that we can trust Github Actions to handle production tokens then we can revive also the initiative to automate the promotion of email alias changes [nodejs/email#222](https://github.com/nodejs/email/pull/222)
* Upgrading the compiler toolchain [#4091](https://github.com/nodejs/build/issues/4091)
    * Working on installing Clang on AIX.
    * Might need to reach out to SmartOS team.

### nodejs/node

* Enabling Rust support for Temporal [#58730](https://github.com/nodejs/node/issues/58730)
    * Work in progress to figure out what needs to be pulled from Chromium third_party.

## Q&A, Other

* Azure Credits status from the GH Security program:
    * No new emails yet received (Ulises confirmed)
    * Ulises will ask MS to transfer unused credits from Express project to Node

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `Add to Google Calendar` at the bottom left to add to your own Google calendar.

