# Node.js Foundation Build WorkGroup Meeting 2018-04-10

## Links

* **Recording**: https://youtu.be/mlnbOhGZlRU
* **GitHub Issue**: https://github.com/nodejs/build/issues/1209

## Present

* Michael Dawson (@mhdawson)
* Gibson Fahnestock (@gibfahn)
* Refael Ackermann (@refack)
* Rod Vagg (@rvagg)

## Agenda

### New OSX infra walkthrough [#1026](https://github.com/nodejs/build/issues/1026)

* Rod: Is the jumpbox in the Ansible inventory?
* Michael: No, not yet
* Rod: Would be good to have that so it’s in the ssh config

### Infra compatibility discussion

- Reference to `detvools` magic
  https://github.com/nodejs/build/pull/809#issuecomment-339799600
- (building with any `devtools` version is officially backwards and forwards
  compatible with OS’es glibc)
- Docker containers help us with coverage of compilers and libraries, but need
  to remember the the kernel is a constant

## Q&A, Other

### Moving from TAP to JUnit

- Motivation - the Jenkins JUnit plugin uses much less resources, and has a much
  better UI experience (easy to find failing test, and find logs. Test results
  propagate to parent job)
- Attempting 2 approaches in parallel
- Migrating a JUnit reporter from V8 code base, so that our test harness will
  generate JUnit reports - Needs changes to the codebase, and backporting
- Activating the `tap2junit` script so that Jenkins could consume JUnit reports
  - Runs completely in CI and is opt in

## Upcoming Meetings

* **Node.js Foundation Calendar**: https://nodejs.org/calendar

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
