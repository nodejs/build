# Node.js Foundation Build WorkGroup Meeting 2018-02-27

## Links

* **Recording**: https://www.youtube.com/watch?v=dmbhNNJH9TU 
* **GitHub Issue**: https://github.com/nodejs/build/issues/1142
* **Minutes Google Doc**: https://docs.google.com/document/d/1DGnpPzLv0LyuyVSF_s55G07E0kkbMgMH867WjuJj2Mc/edit

## Present

Michael Dawson (@mhdawson)


### Standup

* gibfahn:
  * Worked on V8 Canary scripts with targos
  * Starting to look at AIX gcc update
* mhdawson
  * Pushing on OSX front (slowly) with George.
  * Scripts/validation/work to let us use both gcc 4.9 and 4.8 on power
    With John Barboza to select based on Node version.
  * Validation of PRs that should fix coverage failures.
  * Investigation of OSX machine that ran out of disk space.
* joaocgreis:
  * Added VS2017 to CitGM
  * keeping on top of issues 
* trott:
  * Busy
* rvagg:
  * Upgraded server
  * Dealing with git updates required for CentOS 5
  * Brought Debian 9 online, removed Fedora 23
  * Wrote a Jenkins plugin to select the correct machines

## Agenda

### Clarify email aliases (e.g. build@iojs.org) [#1084](https://github.com/nodejs/build/issues/1084)

* Rod: We do have different aliases, but there was a need for at least two levels of aliases
* Michael: Might be useful to have a readme in the email repo that documents this.
* Rod: Or a comments section in the aliases json file
* Gibson: I'll document that infra admins should add themselves

### Security: please pay careful attention to code running through CI [#1070](https://github.com/nodejs/build/issues/1070)
* Gibson: I think this is on the agenda to discuss removing the Fedora machines

### New OSX infra walkthrough [#1026](https://github.com/nodejs/build/issues/1026)
* Gibson: We should defer till George gets back
* Rod: What about the macOS 10.8 machine?
* Michael: I responded, we don't actually use that machine
* Rod: Would be good to get a release machine

### Use Foundation resources to support build [1154](https://github.com/nodejs/build/issues/1154)
* Rod: I.m not sure this is a good idea, 

### A novel approach to trimming Jenkins nodes by Node.js version [#1153](https://github.com/nodejs/build/issues/1153)

* ran out of time, discuss through github

## Q&A, Other

## Upcoming Meetings

* **Node.js Foundation Calendar**: https://nodejs.org/calendar

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.

