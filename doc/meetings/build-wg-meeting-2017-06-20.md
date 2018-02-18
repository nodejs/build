# Node.js Foundation Build WG Meeting 2017-06-20

- [GitHub issue](https://github.com/nodejs/build/issues/766)
- [Meeting video](https://www.youtube.com/watch?v=8B_XgEvIQt8)
- [Previous meeting](https://github.com/nodejs/build/issues/737)

Next meeting: 11 July 2017

## Present
* Michael Dawson (@mhdawson)
* João Reis (@joaocgreis)
* Gibson Fahnestock (@gibfahn)
* Michele Capra (@piccoloaiutante)
* Kunal Pathak (@kunalspathak)
* Kyle Farnung (@kfarnung)

## Standup
* Michael
   * Working on ansible scripts for zOS
   * Reaching out to second mac provider (need to follow up)
   * Building mac images at MacStadium
   * Ordered parts for ARM 6 build machine backup.
   * Talked to Tracy/Foundation team about regular tweets (just need to open issue agree on text now)
   * Talking to Tracy/Foundation about logo/text infra donators can use.
* João Reis
  * Added chakracore-nightly support to nodejs-nightly-builder
* Gibson
  * Looked at the 8.1.1 issue
  * Raised issue on nodejs.org re/ sponsorship page
  * Working on getting AIX ansible scripts
  * Added some new machines to the Ansible inventory.yml
* Michele
  * getting setup with secrets and machine access
  * getting up to speed on existing issue
* Kyle
  * Keeping up on issues, looking for the next one to take on
* Kunal
  * Working on porting test-v8 for windows.
  * Configuring CI benchmarking job for node-chakracore

## Minutes

### update clang on FreeBSD 10 [#723](https://github.com/nodejs/build/issues/723)

- Michael: Kyle this might be a good issue for you
- Gibson: should be similar to  https://github.com/nodejs/build/pull/650, you can raise a PR, and if you need a machine to test on (and can’t get a FreeBSD one) you can comment in the Issue or PR.

### VS2015 and VS2017 install issues [nodejs/node#13641](https://github.com/nodejs/node/issues/13641)

- Gibson: maybe we should have a machine in CI with multiple VS versions installed.
- João: This is a very specific edge case that does not affect end users. I don't think we
need to add this configuration to CI just for this. I will take a better look at the issue.

## Questions

- Gibson: Can anyone think of any issues with keeping the Jenkins configuration scripts in a GitHub repo rather than just in Jenkins xml files?
- Michael: No, there shouldn’t be anything special in the files. Doing it has been brought up before. The important thing would be to make sure only the right people have push access.
- Joao: The problem previously is that there is no really good way to store and view/review config.xml files.
- Gibson: I’ll raise an issue.
