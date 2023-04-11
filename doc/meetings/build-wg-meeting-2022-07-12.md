# Node.js  Build WorkGroup Meeting 2022-07-12

## Links

* **Recording**:  http://www.youtube.com/watch?v=2jX7A1fJZbg
* **GitHub Issue**: https://github.com/nodejs/build/issues/2994

## Present

* Michael Dawson (@mhdawson)
* Stewart Addison (@sxa)
* Niyas Sait(@nsait-linaro)
* Richard Lau (@richardlau)
* Pierrick Bouvier (@pbo-linaro)

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

* No announcements this week

### nodejs/build

* Jenkins will require Java 11 from September LTS release [#2984](https://github.com/nodejs/build/issues/2984)
  * Going to need to update Java on the 2 CI servers
  * Jenkins will drop support for Java 8. Sept LTS release will drop
  * Recommended but don’t have to update the agents
  * They now support Java 11 and Java 17
  * Stewart, 17 is an LTS release, already done at adoptium and went to 17
     saw perf improvements
  * Richard, for release can probably just switch streams, for test we’ll need to pull
     in version.
  * Richard, will want to double check backups are working to be prudent
  * Agreed we should just go to Java 17

* Enable HSTS on website [#2857](https://github.com/nodejs/build/issues/2857)
  * Richard will turn on tomorrow

* Interest in establishing a "Build Helper" role [#2550](https://github.com/nodejs/build/issues/2550)
  * no new progress on that.

* Memory issue on fedora in latest V8 (8.8) requirement [#2527](https://github.com/nodejs/build/issues/2527)
  * no updates on that one. Agreed to take of agenda

* Official Windows on arm support [2540](https://github.com/nodejs/build/issues/2540)
  * Niyas, and Pierrick introduced themselves
    * Niyas is the windows on arm lead
    * Pierrick on Niyas team, working Node.js and resolving test failures
  * next
    * Test machines
      * Access to the test machines
        *  Michael how to give them access
        *  Stewart -> give them the remote desktop password
          * Will do that afterwards.
        * Michael to added Pierrick/Niyas to add to the job
      * Niyas/Pierrick to get up to speed on ansible scripts
        * Make sure current ones are well configured/we know how to recreate
        * Upgrade to Windows 11
        * explore adding additional machines
      * Work down set of test failures
      * Michael will look at collaborators' guides and add ping for team. Also tag in TSC meeting
      * Niyas, asked about how we binaries out there.  Unofficial-builds are already there

## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>


Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
