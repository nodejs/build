# Node.js Foundation Build WorkGroup Meeting 2019-11-19

## Links


* **Recording**:  https://www.youtube.com/watch?v=pm3fuQM5Yow&feature=youtu.be
* **GitHub Issue**: https://github.com/nodejs/build/issues/2046

## Present


* Michael Dawson
* Richard Lau
* Sam Roberts
* Ashley Cripps
* Rod Vagg
* Dave Ings

## Agenda

## Announcements
 
*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.


* Experiment with Docker
  * Allow collabs to more easily manage setup, shrink the set of virtual machines that we 
    need to maintain
  * Problem was with parallel compiles, we get occasional failures. Something about make
    in docker that hits race condition.  
  * Michael different dockers hosts? Rod, all ubuntu 18.04 so possibly related to that.
  * New version of docker might help.
  * Some bugs on make issue tracker related to parallelism, but different versions used.
  * Occurs across different containers versions
  * To recreate, start docker, clone, run make build with -j4.  Often in about 1/20. But could
    related to running under jenkins


* Compressed pointers
  * Google switching chrome over to use compressed pointers.
  * May re-start discussion of multiple versions of binaries
    * significant memory benefits
    * build time flag, so a potential concern to make compressed version only option
  * Google has not said they are removing option, but there is concern we’ll get 
    a lot less test coverage as only the compressed option will be used in Chrome were
  * PR to add build option to Node.js to enable compressed pointers: https://github.com/nodejs/node/pull/30463
  * Background doc on compressed pointers in V8 https://docs.google.com/document/d/10qh2-b4C5OtSg-xLwyZpEI5ZihVBPtn1xwKBbQC26yI


* Metrics collection
  * Started hitting 2G traffic limit on website, caused slowdowns of binary downloads
  * Droplet was moved to new hardware, not sure if that was the issue as we worked
    to enable caching for downloads with cloudflare 
  * Johan worked with his contacts got logpush enabled (typically enterprise feature).
    We have to have S3 compatible storage location for logpush.  Johan setup bucket
    in GCP and set up.
  * Rod confirmed we can get the same log data based on what is being pushed
  * So downloads which were previously bypassed, are now cached
  * Storage cost is not so bad, but synchronization to server to run scripts is more
    Clostly. Myles is providing credits to cover cost
  * Metrics are not being updated, more work to be done. 
  
* Update and request to board to help find resources.
  * Brainstormed and sent “Job role” to board a couple of weeks ago
  * Michael will present some slides to provided additional context/background
    at board meeting this Friday.


## Q&A, Other


## Upcoming Meetings


* **Node.js Foundation Calendar**: https://nodejs.org/calendar


Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
