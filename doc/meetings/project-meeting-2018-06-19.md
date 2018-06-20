# Node.js Foundation Build WorkGroup Project Meeting 2018-06-19

GitHub Issue: https://github.com/nodejs/build/issues/1330

### Present

@joyeecheung
@lucalanziani
@maclover7
@refack
@ryzokuken
@Trott


### Topics

* New members
   * Onboarded mmarchini, lucalanziani in a day
   * Ask Rich if more people who wanted to join the WG didn’t end up opening up an issue
   * Steve_p, and mklebrasseur, have shown interest on IRC.
* Ansible upgrades
   * Joyee: Move giant TODO list from ansible/README.md to a meta issue
   * Cleanup ansible/README.md, make it easier to understand (separate out beginner vs advanced stuff)
   * Jon: Move TESTING_LOCALLY.md to a new location (out of setup/)
   * Make a TOC for the docs (Refael)
* Commit queue
   * History
      * At “idea” stage, implementation has not begun
      * https://github.com/nodejs/commit-queue/issues/1
      * “First” implementation: https://ci.nodejs.org/view/All/job/node-accept-pull-request/
   * node-core-utils could be used from Collaborator machine to trigger a Jenkins job, which would actually do the actual landing
      * Like `git cl land`
   * Initial MVP could have all commits squashed down to a single one
      * What if all commits aren’t “fixups”? → Build a GUI for Collaborator
      * Require them to do it manually instead of using the queue if they want multiple commits
      * Give people a checkbox to skip failures (unchecked by default) to work around our flaky CI
      * Make sure we have process ready for quick reverts if people land things that cause genuine failure (just another PR that need to be landed but we can skip failures this time because reverts are not supposed to cause additional failures)
   * Resources needed from Build WG, for commit queue team:
      * For MVP, just a Jenkins job (triggered via node-core-utils) that uses node-core-utils to land and push the PR
      * Squash everything, provide a textbox to input the final commit message
      * For future versions, possibly a server setup similar to github-bot
      * Figure out how to make Jenkins API easier to interact with from node-core-utils
   * From the node-core-utils side
      * Make node-core-utils more CI friendly (logs mode)
      * Autosquashing
* Tracking failures in node-test-commit
   * Joyee has started working on `ncu-ci walk` command
      * Walks a node-test-commit job, and sorts through all failures
   * Build a “Flaky test database” to better track flaky tests over time
      * Stored as JSON file
      * Associate flakes with issues (issue association can be maintained by human, the reproduction can be maintained by the tool)
      * In order to have a better idea about the context of the reproductions and when a flake first starts to appear
      * Let the tool gather all the context to post instead of copying various information from various places
   * Figure out better way to notify people when build failures occur
      * And who to notify!
      * Sending automatic notification does not work because we already do that in the CI and no one really read those emails
      * Let the tool show a troubleshooting guide and id of owners to seek help from when it detects infra failures
   * Run the CI failure parser in the worker post-build to print the relevant information at the end of the log
      * https://github.com/nodejs/node-core-utils/blob/master/lib/ci_failure_parser.js
      * Need a marker between the logs and the results coming out of node-core-utils to make sure node-core-utils do not read its own output
* Three topics from @refack
   * Different repos
   * Automating CI trigger
   * Structured build steps
* Automatic maintenance (allowing scripted kill and rm by anyone)
* Bookmarklet/Browser Extension to trigger CI
* Find out more about existing scripts and plugins to work with Jenkins so we do not need to do the work ourselves
* [Dream] Integrate Node.js With Jenkins so we can write plugins and pipelines in JS
