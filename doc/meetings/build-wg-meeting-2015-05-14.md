# io.js Build WG Meeting 2015-05-14

## Links

**Public YouTube feed**: http://www.youtube.com/watch?v=8dxkM9vHmrY
**GitHub Issue**: https://github.com/nodejs/build/issues/98

## Agenda

* High level convergende plan
* Buld working group membership
* Info on node-accept-pull-request

## Minutes

### Present

* @orangemocha
* @rvagg

### High level convergence plan (work in progress)

* Take io.js as starting point, bring over few things from Node.js
  - What to bring over from node.js?
  - Hardware assets? The list of Jenkins agents is available here: http://jenkins.nodejs.org/computer/.
    * Most agents run on containers or VMs hosted in Joyent's public cloud.
osx-build is a mac machine that is also owned by Joyent.
    * The Windows agents run on an Azure subscription sponsored by Microsoft.
Currently 4 machines running for a total of 28 cores.
  - Repo credentials to ensure we can push to Node LTS repo
  - Users. Grant accounts on io.js Jenkins
  - Distribution site? Shall we unify?
  - Jenkins Domain name?
  - Automatic merge job (node-accept-pull-request)?
  - Other Node.js Jenkins jobs?
* Extend this infrastructure to Node LTS release branches, and convergence
repo?  * Move the build repository (and its issues) to the Node.js foundation
org. Follow the same strategy as per repo convergence plan.
* Release methodologies might differ for a while (Node.js just started doing pre-releases) and are beyond the scope of the CI convergence, even though it might put requirements on CI.

### Build working group membership:

* Does it make sense for some folks from Node.js (eg Julien and/or Alexis) to join, at least for the sake of bringing stuff back together?
* How do you guys collaborate? Do you have meetings? On Australian time? :)

### Info on node-accept-pull-request:

* A bit of documentation is here:
https://nodejs.org/documentation/workflow/#index_md_using_jenkins_to_build_test_and_merge_every_pr
* Pretty much 0 test regressions since we adopted it
* Flaky tests removed in io. PR: https://github.com/iojs/io.js/pull/812
* Need to do a better job at documenting how this works. But let’s first agree
on the high level plan * High priority improvements:
  - Clarify/document process for handling flaky tests
  - Add metadata for issues fixed
  - Make it easier to enter reviewer names. Parse LGTM? Ideally just pre-populate a form
  - Enable simple edits of commit message(s). Maybe just for single-commit PRs.
  - Extend to more branches
  - Comment on PR with link to results

## Discovery

**(mostly for the benefit of Alexis & Julien, can be done asynchronously after
the call)**

* Did you start from the Node.js Jenkins jobs or something else?
* All jobs triggered by commits? On all branches?
* “Commits to the repository are tested on the full set while pull requests to
the Node.js and libuv projects from non-core contributors are tested on a
smaller, more secure subset.” How is this accomplished?
* Where is the process about committing changes (running CI) documented?  *
test-simple vs test-all. Did you define different test configurations, with
overlap? How?
* https://github.com/iojs/build#configurations-all-code So you don’t test
commits from non-team members on all core platforms?  * Do regressions happen?
Some failure on Windows:
https://jenkins-iojs.nodesource.com/job/iojs+any-pr+multi/lastCompletedBuild/nodes=win2012r2/tapTestReport/
* State of the build (https://github.com/iojs/build/issues/77) mentions
automated PR testing. Status?  * Still using VC 2012? I thought io.js’ version
of v8, required 2013.
* Job configuration backups?
* Handling passwords. Should they all be in a centralized spreadsheet?
