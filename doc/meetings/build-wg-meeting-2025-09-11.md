# Node.js  Build WorkGroup Meeting 2025-09-11

## Links

* **Recording**: https://www.youtube.com/watch?v=l1fNAp62efw
* **GitHub Issue**: https://github.com/nodejs/build/issues/4143
* **Minutes Google Doc**: https://docs.google.com/document/d/1-XViuo7OtGFdX_F-YxGh-hLuB0b_Y6bu7LwPw1b6kl4

## Present

* Milad Fa @miladfarca
* Richard Lau @richardlau
* Michael Zasso @targos
* Abdirahim Musse @abmusse

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Update infrastructure providers list [#4104](https://github.com/nodejs/build/issues/4104)
  * Ryan will be working on this issue.
* Upgrading the compiler toolchain [#4091](https://github.com/nodejs/build/issues/4091)
  * Most Linux machines apart from Ubuntu have Clang installed now. Currently looking at the V8 CI. V8 passes --target during compilation and on RHEL upstream right now we are not passing it. We like to build with the custom libcxx that comes with chromium.
* Add macOS 15 CI images with Xcode 16.4 Add macOS 15 CI images with Xcode 16.4 [#4083](https://github.com/nodejs/build/issues/4083)
  * Ryan is working on this issue.

### nodejs/node

* Enabling Rust support for Temporal [#58730](https://github.com/nodejs/node/issues/58730)
  * Focus right now is on building with Clang, will get back to this item once it’s done.

## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
