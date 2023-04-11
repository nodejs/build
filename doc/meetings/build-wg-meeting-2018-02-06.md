# Node.js Foundation Build WorkGroup Meeting 2018-02-06

## Links

* **Recording**:
* **GitHub Issue**: https://github.com/nodejs/build/issues/1096
* **Minutes Google Doc**: https://docs.google.com/document/d/1zMzNvTNunkVzk6u27mm8LaMXtkm9SDPsx2-3ruBlri4/

## Present

* Michael Dawson (@mhdawson)
* Jon Moss (@maclover7)
* Kyle Farnung (@kfarnung)
* Rod Vagg
* Rich Trott
* Jordan Harband

## Agenda

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

## Announcements

* Rod looking at Raspberry PI issues, some strange things going on, may need to take offline
Until Rod has time to figure what is going on.

### nodejs/build
* https://github.com/nodejs/build/issues/1093#issuecomment-363309237,
  * odroid machines are regularly an issue. Rich often has to take offline.
  * They are similar to Raspberry PI 3’s, at this point we have a fair amount of modern arm
     coverage. It’s ubuntu which is not that different.
  *  Rod will chat with Dave from Mininodes about issues and if we can’t resolve them we will
      remove as we don’t have the cycles to keep them up and running.
* Remove Fedora 22, 23, 24 [#962](https://github.com/nodejs/build/issues/962)
  * remove tag
  * Rod has action to PR in proposal
* CI statuses not posting [#1045](https://github.com/nodejs/build/issues/1045)
  * Related to this we have capacity issues with Jenkins. Once it reaches a certain amount of
    jobs it seems to stop accepting jobs reliably. The extra jobs to post the status updates
    seems to add to the jobs significantly which makes the problem worse.
  * Jon will open up new issue to consider moving the post-status-update job to dedicated
     machines, to avoid jenkins-workspace and general queue clogging issues.
  * Last issue related to this one is making sure we have individual emails.  Being covered in
    different issue, will close this one.
* Security: please pay careful attention to code running through CI [#1070](https://github.com/nodejs/build/issues/1070)
  * Discussed and Jon will consolidate into issue that targets remaining things to do.

* New OSX infra walkthrough [#1026](https://github.com/nodejs/build/issues/1026)
  * defer until next time

* Provide read access to our ci.nodejs.org configs [#972](https://github.com/nodejs/build/issues/972)

* suggestion: investigate a commit-queue solution [#705](https://github.com/nodejs/build/issues/705)

* file and directory names for downloads [#515](https://github.com/nodejs/build/issues/515)
  * Jordan working in version management team.
  * First step would be to define where where to install.  This would allow
    different version managers to find installs from other version managers.
  * Currently each version manager uses its own locations.
  * Rich: can version management team suggest these locations as not necessarily under
    build jurisdiction?
  * Jordan yes, provided build team thinks its a good idea.  Would cover per user build as well
    as system level install.
  * Rich one issue is how to deal with old installations, etc.
  * Michael/Jon in agreement with Rich that version management team make initial suggestion.
  * Rich, if path to where official installers will install there will be discussions, but version
     management team is right team to deal.
* Flaky tests,
  * Rich, issue in node.js with tag indicating flag.
  * Add to collaborator guide, maybe already there just need to check.
  * Open issue to discussion,
* Michael, find or open issue about paid resources for build, restart discussion and get onto
   agenda

## Q&A, Other

## Upcoming Meetings

* **Node.js Foundation Calendar**: https://nodejs.org/calendar

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
