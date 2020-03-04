# Node.js  Build WorkGroup Meeting 2020-03-03

## Links

* **Recording**:  https://youtu.be/hWoJNQ4Q4ys
* **GitHub Issue**: https://github.com/nodejs/build/issues/2198

## Present

* Richard Lau (@richardlau)
* Michael Dawson (@mhdawson)
* Ash Cripps (@AshCripps)
* John Kleinschmidt (@jkleinsc)
* Rod Vagg
* Rich Trott

## Agenda

## Announcements
 
*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* workflow: add stale action [#2196](https://github.com/nodejs/build/pull/2196)
  * No objections from those in the meeting, we should move forward with it.

* suggestion: we enable the "stale" bot on nodejs/build 
[#2190](https://github.com/nodejs/build/issues/2190)
  * covered under the discussion on #2196.


* Platform requirements for Node.js 14 [#2168](https://github.com/nodejs/build/issues/2168)
  * reviewed what has been discussed, general agreement
  * Richard to capture summary of current proposal for requirements for 14.x

* provision mac minis at nearform as osx machines in jenkins CI 
[#1695](https://github.com/nodejs/build/issues/1695)
   * 95% there, have been added to all jobs except libuv
   * may need to get PR cmake in ansible for the macs.
   * Rod has worked on Release machine and quite lot to get it working, need full xcode the only   
  way you can do that is with GUI. Have added manual steps to the doc and need space (takes 
  7+9G to get it setup)  Current Mac stadium machines are 20G so that would be hard.
  Have first notarised build on CI - Yay!.  Lets get this merged into master, and enable 10.15
  For master, then switch the rest of the release lines to 10.15, then backport to other lines.
* Michael, notarization sooner than later?
* Richard, release cadence may naturally drive flow.
  * 12 is slated for the mid this month, then next is 14 of next month.

* TODO list to make this happen[#1] (https://github.com/nodejs/commit-queue/issues/1)
  * Rich: there was an attempt about 5 years ago. CI/testing was not stable enough and pitchforks 
    came out, quickly backed off of requiring commit queue.
  * For next 2 years any mention of commit queue was not well received
  * Now is probably time to revisit scaled back commit queue. Github action that would run
    node-core utils on simple commits (one commit) action to rebase, run on platforms that we 
    can easily run with github actions, then based on comment, would then add meta data and 
    auto land if no changes since tests,  CI run in advance would still be required
  * Rod, in the past the problem was that it was all or nothing. Does current solution take that
    in account.
  * Rich, no requirement to use queue.  Github action will not land if there were changes.
  * Rod, our infra does a lot more rebasing so may work better.
  * Rich, main issue could be things like lint rule changes, failures.
  * Rich 
    * Right now different commit queue repo/team
    * Would like to just do it in the build WG.
    * Michael, big +1
    * Rod good for build to have insight into it. +1
  * Rod biggest concern is with the state of tests, “Issue about CI is unusable”, seems to be
    Issues with tests not CI or infra. What is the state of tests?
  * Rich tests not as stable as they were 2 years ago, but better than 5 years ago.
  * Could still really help with Windows people who might be able to dive in and help out
  * Michael, John K -> since from Electron/Windows anybody you know who might be able to 
    help on that front.

## Q&A, Other

## Upcoming Meetings

* **Node.js Foundation Calendar**: https://nodejs.org/calendar

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
