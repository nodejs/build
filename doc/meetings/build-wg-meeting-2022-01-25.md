# Node.js  Build WorkGroup Meeting 2022-01-25

## Links

* **Recording**:  http://www.youtube.com/watch?v=7JbJp2kRCXg
* **GitHub Issue**: https://github.com/nodejs/build/issues/2852

## Present

* Michael Dawson (@mhdawson)
* Richard Lau (@richardlau)
* Rich Trott (@trott)

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.


### nodejs/build


* Platform requirements for Node.js 18 [#2815](https://github.com/nodejs/build/issues/2815)
  * Planned to last until ~ April 2025, so looking at what platforms which still be in support
    at that time
  * Main change is that CentOS 7 will EOL before then so planning to move to RHEL 8
  * Applying for no cost RHEL subscription from Open Source program. 
  * For most architectures at least one provider we can install versus provide templates, for the
    others we can likely build our own images.

* Certificate expiry 18 January 2022 [#2811](https://github.com/nodejs/build/issues/2811)
  * One report on OSX Monterey of not being able to download headers? But seems strange
    since have not seem issues on other OSX levels or any other reports.
  * Remaining issue is to update the documentation. Richard has action to land those
    instructions.
  * Even though we have a 5 year cert we still need to re-issue and re-install every 13 months.

* Rename primary branch to main [#2761](https://github.com/nodejs/build/issues/2761)
  * no progress on this yet

* Interest in establishing a "Build Helper" role    [#2550](https://github.com/nodejs/build/issues/2550)
  * nothing to report on this front.
  * Ash did some hand over to Richard and Stewart but have not progressed since.
    
* Memory issue on fedora in latest V8 (8.8) requirement [#2527](https://github.com/nodejs/build/issues/2527)
  * Been ok since Richard added swap
  * Need to add to ansible before closing out

* Enable HSTS on website [2857](https://github.com/nodejs/build/issues/2857)
  * Plan is to turn it on unless we can find some reason why non-encrypted downloads would be
     an issue.

### nodejs/unofficial-builds

* Rename primary branch to main [#35](https://github.com/nodejs/unofficial-builds/issues/35)
  * no progress to report this week.

### nodejs/snap

* chore: change default branch to main [#17](https://github.com/nodejs/snap/pull/17)
  * no progress to report this week.

## Q&A, Other


## Upcoming Meetings


* **Node.js Foundation Calendar**: <https://nodejs.org/calendar>


Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
