# Node.js Foundation Build WorkGroup Meeting 2019-04-02

## Links

*  **Recording**: https://www.youtube.com/watch?v=69eaff4-Uxk  
* **GitHub Issue**: https://github.com/nodejs/build/issues/1744

## Present

* Michael Dawson (@mhdawson)
* Refael Ackermann (@refack)
* Rod Vagg (@rvagg)
* Sam Roberts (@sam-github) (via youtube, zoom was dropping out)
* Rich Trott (@Trott)
 
## Agenda

## Announcements
 
*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Can 'make lint-py PYTHON=python3' be a mandatory Jenkins test? [#1631](https://github.com/nodejs/build/issues/1631)
  * @refack needs a review of [#1745](https://github.com/nodejs/build/pull/1745)

* Request for elevated permissions [#1337](https://github.com/nodejs/build/issues/1337)
  * Is this on agenda to approve @maclover7’s request, or as an ongoing discussion of the 
    Process?
  * A few steps 
    * First step has been taken.  Broke out infra for OSX.  Rafael has access
    * Another step is that people from IBM are getting access to IBM platforms
  * Rod, going to be a challenge to find time to document everything but we can take steps
    like the OSX breakout.
    * Rod: One issue is to make sure we stay within the “soft” limits
    * Michael: maybe ask that people open issue before adding new machines
    * Refael: could also use controls in the infra itself to limit what you can do 

* Use Foundation resources to support build [#1154](https://github.com/nodejs/build/issues/1154)
  * Refael, may be better to ask for larger companies to dedicate resources
  * nodejs/build: 203 open issues, 50 open PRs

* \[#625](Build jobs for node-inspect under auspices of diagnostics WG)
  * Michael agreed to close.

* Build updates for 12.x state:
  * Michael: Sam and I are working on IBM platforms
  * Refack: compiler update to 6.3 involves dependency on new symbol only present in libg++. Redhat developer-toolset deals with this by using static linking to get newer symbols, in a way that works for older platforms.
  * Sam: Michael is trying to find out if Redhat will donate a developer-tools license to Node.js
  * Refack will update issue to show where we are with respect to non IBM platforms.

## Q&A, Other

## Upcoming Meetings

* **Node.js Foundation Calendar**: https://nodejs.org/calendar

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.


