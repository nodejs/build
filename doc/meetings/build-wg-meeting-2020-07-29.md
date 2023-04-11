# Node.js  Build WorkGroup Meeting 2020-07-28

## Links

* **Recording**: https://youtu.be/HwfGrhbskjQ
* **GitHub Issue**: https://github.com/nodejs/build/issues/2391

## Present

* Michael Dawson (@mhdawson)
* Johan bergström (@jbergstroem)
* Rod Vagg (@rvagg)
* Richard Lau (@richardlau)
* Ash Cripps (@AshCripps)

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

* Ash
  * Donated to use DTKs by mac stadium
  * Once we land PR with updates we can start building/testing
  * Many thanks

### nodejs/build

* Auditing @nodejs/platform-windows [#2389](https://github.com/nodejs/build/issues/2389)
  * Underway, 5 people have mentioned they’d like to stay on the list

* Ash, in process of completing audit of build team members, 4 people going emeritus

* Grafana update: we are in talks to get the enterprise team license, allowing us to sync github teams with grafana (so we don’t have to maintain this manually) [#2370](https://github.com/nodejs/build/issues/2370)
  * had gotten access for oauth app, but that was not enough to inherit the auth info
  * had reached out to Grafana about getting access to plugin to sync with Github as it requires
    enterprise licence.  Will let us have more people create dashboards that help us keep track
    of what’s going on
  * One step will be adding agents to the workers to collect info
  * Second step is to create more dashboards
  * Should have good setup for disk usage, cpu etc.
  * Michael, ansible templates ? Johan have some work in progress ones

* Processing download metrics in GCP
  * Ash, have worked with Bethany a few weeks ago and got the general flow going
  * Remaining issue is that after at 10-15 minutes getting and write after end error
  * Trying to catch the exception in the code but have not yet been able to
  * If redeploy the function it starts working again

* osx binaries, benchmarks ?
  * Rod, in the transition to intel, Node.js was shipped as a fat binary. Guess most projects
    will ship fat binaries for a few years. More, some will want the fat binaries so they don’t
    even have to worry about it
  * Johan, nvm would likely have the same approach and adding exceptions is likely not
  * Will likely need to update xcode 12 version.
  * Looking at old make files we should be able to see how we built fat binaries in the past and
    we may be able to use that as a starting point.
  * How to handle finding regressions?
    * one action is to ask if people are interested in running benchmarks and reporting issues

* Issue about increasing permissions for the github bot increased permissions
* Richard, suggested can we make the github bot a “collaborator”
  * https://github.com/nodejs/admin/issues/536

*Ash will raise issue for moving other meeting to be earlier, doodle will be coming soon.

## Q&A, Other

* No questions


## Upcoming Meetings


* **Node.js Foundation Calendar**: https://nodejs.org/calendar


Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
