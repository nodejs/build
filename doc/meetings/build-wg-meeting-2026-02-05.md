# Node.js Build WorkGroup Meeting 2026-02-05

## Links

* **Recording**: https://www.youtube.com/watch?v=zqaO4tnDFl8
* **GitHub Issue**: https://github.com/nodejs/build/issues/4228
* **Minutes**: https://hackmd.io/@openjs-nodejs/SktekFYLZe

## Present

* Milad Fa (@miladfarca)
* Richard Lau (@richardlau)
* Ryan Aslett (@ryanaslett)
* Ulises Gascón (@UlisesGascon)
* Stewart Addison (@sxa)
* Chengzhong Wu (@legendecas)

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Standardise web-infra/admins Cloudflare access [#4194](https://github.com/nodejs/build/issues/4194)
    * A lot of changes has happened in Cloudflare.
* Upgrading the compiler toolchain [#4091](https://github.com/nodejs/build/issues/4091)
    * Rust and Clang are now on RHEL machines and there is an open PR https://github.com/nodejs/build/pull/4231 which updates the containers.
    * For Rust V8 is a lot more picky but Node.js seems to be more fleixible.
* Extend Azure credits (Long term) [#3672](https://github.com/nodejs/build/issues/3672)
    * Hoping to have everyting in the same tenant.

### nodejs/node

* Enabling Rust support for Temporal [#58730](https://github.com/nodejs/node/issues/58730)
    * not enabling by default until V8 14.4 or 14.5
    * installed 1.84
    * minimum https://github.com/nodejs/node/blob/main/BUILDING.md#building-nodejs-with-temporal-support 1.82 (LLVM 19)
    * GitHub Action Linux build has been enabled. macOS and Windows to come.
    * would platforms other than linux/windows/macos be a _blocker_ to enabling general support of Temporal?
    * `cargo` could be an aliased name on some platforms, like `cargo-*`.
    * no other rust library dependencies at the moment, but there might be more to come (like amaro is looking to transition to a pure rust library).

## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `Add to Google Calendar` at the bottom left to add to your own Google calendar.
