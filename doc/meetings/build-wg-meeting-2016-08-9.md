# Node.js Foundation Build WG Meeting 2016-08-09

* GitHub issue: https://github.com/nodejs/build/issues/450
* Meeting video:  http://www.youtube.com/watch?v=EnLoylo8EHI

## Present

* Johan Bergström
* Michael Dawson
* Myles Borins
* Hans Kristian Flaatten

### Agenda
Extracted from `wg-agenda` [issues](https://github.com/nodejs/build/issues?q=is%3Aopen+is%3Aissue+label%3Awg-agenda) and [pull requests](https://github.com/nodejs/build/pulls?q=is%3Aopen+label%3Awg-agenda+is%3Apr) from this repo.

* How can a project qualify for access to the build infrastructure? #448 
* Run and deploy nodejs-github-bot #404
* OS X buildbots/ci: call to action #367 
* rsync endpoint to mirror the releases #55
* Alpine Linux / Docker Build #75

## Standup

* Johan Bergström
  * refactoring to ansible jobs
  * Working with Phillip to deploy bots
  * Updated test/release CI to latest of their versions, doing 
    Background work to update test CI to 2.x which is what release
    is currently running.
  * working on getting tap jobs from our test runs
  * quite a few other things I missed taking down


* Michael Dawson 
 * Keeping eye on PPC machines, now stable
  * Adding new AIX machines along with updates to instructions
  * Added AIX to standard regression job
  * Adding s390/linuxOne release machine and to Release job so that 
    we can get nightlies
  * Working on build presentation for Node Interactive EU
  

* Myles Borins
  * PR to get xml reporter for CITGM (needs LGTM)
  * CITGM job to test abi breakages (different versions of node for compile and test)
  

* Hans Kristian Flaatten
  * Not too much, maintenance on Jenkins Monitor (email issue)
  * Playing with the Jenkins REST API (Electron UI to get a high level overview of Pull Request builds and what breaks)

## Minutes

* How can a project qualify for access to the build infrastructure? #448
  * discussion to be taken back to github issue
* Run and deploy nodejs-github-bot #404
  * jbergstroem/phillipj has made progress. Its now hosted on node.js build 
    group infrastructure and it is currently being tweaked to post PR updates to github
* OS X buildbots/ci: call to action #367
  * send an email to mikeal and explore how we can query the foundation for the
    budget required to set up an account at a vm provider. (Johan)
  * query google if there.s room at their infra (v8, chrome testing) (Myles)
* rsync endpoint to mirror the releases #55
  * michael will create the news item/effort to push through strict tls.
    based on pointers provided by Johan. Will be in a few weeks as Michael is
    on vacation next week.
* Alpine Linux / Docker Build #75
  * discussion to continue in github. Quite a few issues related to having
    an official release so will require more discussion/investigation as to
    what the right thing to do is.  There is quite a lot of interest in Alpine
    so important to keep thinking about this.
* Collectively reviewing the node.js build presentation.
  Michael has prepared ahead of the event in September. Some good
  feedback that Michael will incorporate.


## Next meeting

August 30th, 8pm UTC
