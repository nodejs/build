# Node.js  Build WorkGroup Meeting 2021-01-12

## Links

* **Recording**: https://youtu.be/qFq4IvGHxR8  
* **GitHub Issue**: https://github.com/nodejs/build/issues/2513

## Present

* Richard (@richardlau)
* Ash (@AshCripps)
* Michael Dawson (@mhdawson)
* Rod Vagg

## Agenda

## Announcements
 
*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Apple silicon builds [#2474](https://github.com/nodejs/build/issues/2474)
  * One more test that needs to pass before it can be added to the CI
    * Ash will open issue in core to see we can help find a volunteer to fix, don’t think it’s a build issue. 
  * Target is 16.x for binaries that support both without Rosetta 2.

* Metrics
  * First stage of metrics is working now! Ran over the weekend.
  * New PR opened - https://github.com/nodejs/build/pull/2518
  * Discussion around where to generate summaries
    * Summaries can be handled outside of GCP
  * Discussion around merging existing data, first GCP file is 29th Oct 2019
  * Storage alternatives
        * Github
            * Just store in GCP itself
            * Possibly move to metrics.nodejs.org

## Q&A, Other

## Upcoming Meetings

* **Node.js Foundation Calendar**: https://nodejs.org/calendar

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
