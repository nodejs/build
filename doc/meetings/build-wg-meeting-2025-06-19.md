# Node.js  Build WorkGroup Meeting 2025-06-19

## Links

* **Recording**: https://www.youtube.com/watch?v=-JyPB70rN3U
* **GitHub Issue**: https://github.com/nodejs/build/issues/4094

## Present

* Milad Fa (@miladfarca)
* Michael Zasso (@targos)
* Richard Lau (@richardlau)
* Abdirahim Musse (@abmusse)
* Joyee 
* Build team: @nodejs/build


## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Upgrading the compiler toolchain [#4091](https://github.com/nodejs/build/issues/4091)
  * Upstream V8 change required gcc 13(.1?)/clang 14.
  * Direction is either upgrade to gcc 13/14 or switch to clang. Google only officially supports clang for V8.
* Require Physical 2fa for Build WG & Web Infra members [#4063](https://github.com/nodejs/build/issues/4063)
  * Disable some of the less secure 2fa auth methods (i.e sms messages). 
  * Do we want to enforce this? Or just leave it as a recommendation.
* Potentially transition to 1password for secrets management [#4039](https://github.com/nodejs/build/issues/4039)
  * There are some secrets that would make sense to be saved there. Also may need to convert some of the automation.
* Replace Works on Arm machines affected by Equinix Metal sunset (June 2026) [#3975](https://github.com/nodejs/build/issues/3975)
  * Ryan is working on it. Some stuff still needs to be resolved. We will lose a large amount of our Arm capacity. Right now we don’t know if/when we will get replacements.
* Infrastructure for Orka (2024 and beyond) [#3686](https://github.com/nodejs/build/issues/3686)

### nodejs/node

* Enabling Rust support for Temporal [#58730](https://github.com/nodejs/node/issues/58730)
  * it’s unavoidable and we will need to add Rust to our toolchain.
  * It needs to be converted to gyp for building within the node project.
  

## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
