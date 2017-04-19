# Node.js Foundation Build WG Meeting 2017-04-18

GitHub issue: https://github.com/nodejs/build/issues/683
Meeting video: Link for participants: http://youtu.be/gnE1dBTNWTw
Previous meeting: https://docs.google.com/document/d/1j_wYeNgRxywx7GvJSbRDUWkkNeGCzdog4OMO3IKu6KY/edit

Next meeting: 9 May 2017

## Present
* Michael Dawson (@mhdawson)
* Johan Bergström (@jbergstroem)
* João Reis (@joaocgreis)
* Gibson Fahnestock (@gibfahn)
* Michele Capra (@piccoloaiutante)
* Kyle Farnung (@kfarnung)

## Standup

* Michael Dawson (@mhdawson)
  * minor AIX main issues
  * starting to look at bringing in z/OS machines
  * worked to land supported platforms section in BUILDING.md for master,
    v6.x-staging and v4.x-staging
  * initial cut of coverage areas
* João Reis (@joaocgreis)
  * Fixed building V8 5.7 on x86 and added x86 to the Windows CI matrix
  * Added Ubuntu and OSX to the CI for node-chakracore
* Gibson Fahnestock (@gibfahn)
  * AIX on CitGM
  * test-npm on Linux/Win
  * tested @phillipj’s CitGM CI from comment, works really well
* Johan Bergström (@jbergstroem)
  * nodejs.org downtime -> cloudflare LB/unencrypted.nodejs.org
  * jenkins ci security issues
  * minor work on the refactor
* Michele Capra (@piccoloaiutante)
   * Worked on adding V8 test to windows build script.

## Agenda

* Request to join the jenkins-admins team (gibfahn) [#667](https://github.com/nodejs/build/issues/667)
* adding nodejs-foundation user to npm modules managed by build team
* Create matrix of "coverage" areas for build team [#662](https://github.com/nodejs/build/issues/662)
* Transfer Jenkins OAuth Application to nodejs [#687](https://github.com/nodejs/build/issues/687)
* thumbs up/thumbs down for meeting attendance status

## Minutes

### Request to join the jenkins-admins team (gibfahn) [#667](https://github.com/nodejs/build/issues/667)
* Agreed, no concerns. Michael will add Gibson.

### adding nodejs-foundation user to npm modules managed by build team

* Johan to add `nodejs-foundation` user to
  [nodejs-dist-indexer](https://www.npmjs.com/package/nodejs-dist-indexer) and
  [nodejs-nightly-builder](https://www.npmjs.com/package/nodejs-nightly-builder).

### Create matrix of "coverage" areas for build team [#662](https://github.com/nodejs/build/issues/662)

* We discussed, added some entries and all took the action to add ourselves
  into the areas Where we are covering.
* Also discussed allowing people to request areas where they'd like to be
  involved.

### Transfer Jenkins OAuth Application to nodejs [#687](https://github.com/nodejs/build/issues/687)

* We discussed and will ask Rod to do the transfer.

### thumbs up/thumbs down for meeting attendance status https://github.com/nodejs/build/issues/689

* We discussed and all agreed.
* Johan to make an issue to document.

## Questions

* No questions for today.

