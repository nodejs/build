# Node.js Foundation Build WorkGroup Meeting 2018-06-12

## Links

* **Recording**: https://www.youtube.com/watch?v=juQ53qvh1l8 
* **GitHub Issue**: https://github.com/nodejs/build/issues/1317

## Present
  * Luca Lanziani (@lucalanziani)
  * George Adams (@gdams)
  * Michael Dawson (@mhdawson)
  * Daniel Bevenius (@danbev)
  * Adam Miller (@amiller-gh)
  * Jon Moss (@maclover7)
  * Johan Bergström (@jbergstroem)
  * Joyee Cheung (@joyeecheung)
  * Kyle Farnung (@kfarnung)
  * Matheus Marchini (@mmarchini)	

## Agenda

## Announcements
 
*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Discussion about current state of WG membership
  * Security release problems @maclover7 and @refack
    * issues with testing repo, uses https to pull down repo, but does not work with private repo
    * Michael -> what have we done in the past.
    * Filled PR to open issue to give a heads up.
    * switched to use ssh instead of https
  * Sub teams for build? [#1331](https://github.com/nodejs/build/issues/1331)
    * Proposed action: action  
      - [action 1](https://github.com/nodejs/build/issues/1331#issuecomment-396250757) 
      - [action 2](https://github.com/nodejs/build/issues/1331#issuecomment-396252793)
      - No objections
      - Description of jenkins-release-admins is missing, fix in 
        https://github.com/nodejs/build/pull/1336
* New Build WG members
  * Build WG self-nomination: mmarchini [#1308](https://github.com/nodejs/build/issues/1308)
  * Build WG self-nomination: amiller-gh [#1305](https://github.com/nodejs/build/issues/1305)
  * request to join the build group [#1303](https://github.com/nodejs/build/issues/1303)
  * Request to join the team [#1299](https://github.com/nodejs/build/issues/1299)
    * Daniel - main motivation is to be able to help trouble shoot issues 
    * amiller - CI stability, and getting the fail rate down, but happy to help out everywhere else
    * Luca - interest on helping out on the ci side, but also happy to help out in other areas
    * Mattheus - Interested in helping improve the CI infra reliability and usability.
  * Refack:
    * Key things that need to be done for CI help
    * wipe workspace from the Jenkins GUI
    * kill processes through script console
    * restart jenkins agent (needs ssh)
    * disk space cleanup
    * Could setup a number of ansible tasks which can do the cleanup, then could use ansible
     tower to provide GUI to all collab to run when necessary
    * Improve tests 
    * Can also improve the overall user experience in using the CI
  * Next steps
    * Jon - working on guide - https://github.com/nodejs/build/blob/master/doc/jenkins-guide.md
      * volunteers to review the jenkins-guide.md, ask Jon for clarity where necessary
      * ask volunteers to join node-build on freenode, start responding to issues  
      * ask volunteers to start reading through the documentation.
    * Schedule onboarding for new members.
    * Johan has a number of stubs/knowledge transfer with Jon. Will also contribute
      over the next few weeks
    * George to work on getting ansible tower instance in place
      * Refack, idea of tower is smaller playbooks like kill processes on machine, wipe workspace
      * George smaller ones will be easier to get in so we should start with them.
      * Refack if we can make the playbooks safe/predictable then we can make those more 
        broadly available. 
      * Johan difficulty is mostly in packaging.  On some package managers will be able to handle
        others may required compilation from script.
      * George to demo tower

* State of Ansible [#1277](https://github.com/nodejs/build/issues/1277)
  * Open issue about JDK for PowerPC download 404’ing
* Discuss: upgrade required clang to 3.9 [#1264](https://github.com/nodejs/build/issues/1264)
  * Refack, because we support old release versions we need to figure out a way to 
    have side by side versions of clang. George on mac can use xcode select.

Ran out of time, tabled to next time:

* Use of Docker in Build CI [#1226](https://github.com/nodejs/build/issues/1226)
* Release infrastructure post mortem [#1212](https://github.com/nodejs/build/issues/1212)
* Dropping 32-bit builds [#885](https://github.com/nodejs/build/issues/885)

## Q&A, Other

## Upcoming Meetings

* **Node.js Foundation Calendar**: https://nodejs.org/calendar

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
