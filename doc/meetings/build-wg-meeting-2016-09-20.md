# Node.js Foundation Build WG Meeting 2016-09-20

* GitHub issue: https://github.com/nodejs/build/issues/498
* Meeting video: https://www.youtube.com/watch?v=qFJh5Wagdhs

## Present

* Johan Bergström
* Rod Vagg
* Michael Dawson
* João Reis
* Gibson Fahnestock
* Myles Borins

## Agenda

Extracted from wg-agenda issues and pull requests from this repo.

* Invite @Trott to the build team #497
* build group membership reminder! #489
* Create proposal for list of officially supported platforms #488
* TAP Plugin issues on Jenkins #453
* How can a project qualify for access to the build infrastructure? #448
* rsync endpoint to mirror the releases enhancement infra #55

## Standup

* Johan Bergström
  * Compilation issues on freebsd and AIX.
  * Working on ansible refactor
  * Updates to readme
* Rod Vagg
  * Raspberry Pi stuff
* Michael Dawson
  * Swapping in PPC machines from new production cluster and cleaning
    up old ones
  * Adding linuxOne to release CI/jobs
  * Adding AIX to release CI/jobs
  * Starting to work on code coverage job starting with Anna.s
    scripts.
* João Reis
  * Added release servers with VS2015
  * Created a job to clean the workspaces on Raspberry Pi.s
* Gibson
  * Now a collaborator in node.js

## Minutes

* Invite @Trott to the build team #497
  * discussed and all voted in favor

* build group membership reminder! #489

  * discussed regularly confirming continued participation
  * recycle keys as people leave, perhaps have a look at
    https://code.facebook.com/posts/365787980419535/scalable-and-secure-access-with-ssh/
    as a way to make this easier.
  * Once we come the current canvas of who is still involved
    we should refresh the keys across test and release machines

* Create proposal for list of officially supported platforms #488
  * posted draft on issue, will plan to put on CTC agenda next week.

* TAP Plugin issues on Jenkins #453

  * Myles: we need to update the node test runner to report tap using
    YAMLish for the stack traces. Once that is done the tap -> junit
    converter should work using an off the shelf module.

* How can a project qualify for access to the build infrastructure? #448

  * No change. Remove from agenda.

* rsync endpoint to mirror the releases enhancement infra #55

  * Read the issue and +1/-1

* os x update:

  * We might have a hardware donator, meaning we will carry the hosting cost.


## Next Meeting

October 11th, 8pm UTC
