# Node.js Foundation Build WG Meeting 2017-07-11

- [GitHub issue](https://github.com/nodejs/build/issues/787)
- [Meeting video](https://www.youtube.com/watch?v=N5YxsZvkMiY)
- [Previous meeting](https://github.com/nodejs/build/issues/766)

Next meeting: 1 August 2017

## Present
* Michael Dawson (@mhdawson)
* Michele Capra (@piccoloaiutante)
* Kunal Pathak (@kunalspathak)
* Kyle Farnung (@kfarnung)
* João Reis (@joaocgreis)


## Standup
* Michael Dawson
  * Backup raspberry pi 1 for release builds. Running and configured with ansible. Next step is to establish tunnel into CI
  * Creating based OSX machines in MAC provided infrastructure
  * Working on connecting z/OS machines to CI for use in testing libuv
  * Candidate for tweet thanking donators
  * Discussion with 2nd OSX donator
* Michele Capra
  * Sent out a PR for NODE_TEST_DIR in Ubuntu https://github.com/nodejs/build/pull/785
* Kunal Pathak
  * Sent out PR for test-v8 https://github.com/nodejs/node/pull/13992
  * Fixing Jenkins CI job to analyze cctest.tap failures
* Kyle Farnung
  * Worked on FreeBSD clang upgrade script, PR still in progress since the code fails to build under clang 3.4.2 and 3.5.2. The issue also doesn’t repro in V8 6.1 (https://github.com/nodejs/build/issues/723)
* João Reis
  * Created a new Jenkins job to update and reboot Windows machines everyday if needed
  * Added a crontab entry in all SmartOS workers to clean old core dumps



## Minutes
### Proposed test for regular tweet thanking sponsors [#771](https://github.com/nodejs/build/issues/771)
- The team agreed on move forward with the proposed text for donators tweet.

## Questions

No questions have been asked.
