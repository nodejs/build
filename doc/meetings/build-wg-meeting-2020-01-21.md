# Node.js Foundation Build WorkGroup Meeting 2020-01-21

## Links

* **Recording**: https://youtu.be/WEbHTWH_-f8
* **GitHub Issue**: https://github.com/nodejs/build/issues/2132

## Present


* Michael Dawson (@mhdawson)
* Richard Lau (@richardlau)
* Rod Vagg (@rvagg)
* Ash Cripps (@AshCripps)
* Sam Roberts (@sam-github)
* Rich Trott

## Agenda


## Announcements


*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.


* OSX notarization
  * Infra
    * Need newer infra to use later OSX versions, Rod is trying through our contact and support
    * Slowly working on OSX instances an NearForm, Ashley following up this week, need some
      changes to assigned IPs
  * certs
    * Rod is working to figure out how we renew our Developer certs to be able to test out the
      notarization flow.  
    * New apple membership. Membership is tied to a single physical machine or ipad, etc.
      should be able to have team and their apple teams. 2 factor (sms), 2 factor authentication
      need higher level to renew, not sure if needed to be members of team.  
  * Build changes?
    * Once Rod has the certs he’s going to work on a proposal


* Tracking Jenkins changes
  * Discussion, about how to we keep revision history. Pipelines could do that, but they way we
    used them we were not doing that. UI also seemed much less direct.
  * Used to have plugin that would track changes, but only tracked changes through the UI. 
    seems to work for some jobs but not others
  * Rod has proposal to check jenkins config xmls into private repo. Cron job that runs every 5
    mins on both jenkins machines. Copy config.xml to git repo, if any changes commit and push
    up to github.
  * Michael to open issue in admin repo to ask for two repos
    * jenkins-config-test
    * jenkins-config-release

* Update on build resource request
  * Michael: Earlier suggested people from Board don’t have time to participate so will have to go
    back and renew the request for help.

* Node 14, build infra requirements
  * Richard to create issue and tag for agenda.

* Ashley, should we audit membership? 
  * Agreed, Ashley will start the membership review process.

## Q&A, Other


## Upcoming Meetings


* **Node.js Foundation Calendar**: https://nodejs.org/calendar


Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
