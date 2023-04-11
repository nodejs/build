# Node.js Foundation Build WorkGroup Meeting 2018-03-20

## Links

* **Recording**: https://www.youtube.com/watch?v=Am1xqE2Wxao
* **GitHub Issue**: https://github.com/nodejs/build/issues/1183

## Present

* Michael Dawson @mhdawson
* Gibson Fahnestock @gibfahn
* Rod Vagg @rvagg
* Joao Reis @joaocgreis

## Standup

* Michael Dawson
  * Support on Linux on P for 4.9 and 4.8 concurrently.  Next will be doing the
  same for linuxOne.
* Gibson Fahnestock:
  * Implemented node-test-pull-request as a pipeline, got feedback on it, need
  to see if pipelines are the right way forward.
  * Working on AIX Ansible support, seems to be possible for AIX 7.1.
* Joao:
  * Not enough time to do too much, a few calls.
* Rod Vagg
  * Took most of last week off
  * This week did a lot of stabilisation work on Jenkins, which seems to have
  fixed most of the instability issues.

## Agenda

* When adding new targets, can we ensure they work on all release lines [#1182](https://github.com/nodejs/build/issues/1182)
* Updating admin lists [#1107](https://github.com/nodejs/build/issues/1107)
* New OSX infra walkthrough [#1026](https://github.com/nodejs/build/issues/1026)

### nodejs/build

### When adding new targets, can we ensure they work on all release lines [#1182](https://github.com/nodejs/build/issues/1182)
* Gibson: Would be good to document "what to check" going forward.
* Rod: We should work out what to do here, when something fails. Do we skip on
  other release lines?
* Gibson: Okay with skipping as long as we leave an issue open to fix flaky
  tests and unskip, otherwise we'll never unskip.
* Gibson: We can continue discussion in issue, but would be good to agree on a
  plan with releasers.

### Updating admin lists [#1107](https://github.com/nodejs/build/issues/1107)
* Rod: My suggestion is to split out jenkins out for test and release, then give
  broader access.
* Rod: Just needs adding a new team and then changing the ci matrix
* Gibson: I’ll raise an issue for it later, just need to make sure that existing
  admins can still access ci-release.
### New OSX infra walkthrough [#1026](https://github.com/nodejs/build/issues/1026)
* Michael: I can give a quick overview, though I won’t be able to
* Michael: Docs are available in secrets/build/infra/macstadium.md
* Rod: I recall that you have to add a new host first before you can get Vsphere
  access for it.
* Rod: Shall we table this until the next meeting?
* All: No objections

## Q&A, Other

* Gibson: FYI I’ve been seeing SSL certificate errors with the git we have one
  some internal RHEL 6 machines, something to watch out for.
* Rod: I had to build git from source on CentOS 5, I’m working on an ansible
  script for it.

## Upcoming Meetings

* **Node.js Foundation Calendar**: https://nodejs.org/calendar

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
