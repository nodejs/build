# Node.js  Build WorkGroup Meeting 2020-07-07

## Links

* **Recording**: https://youtu.be/j9cidHnBwn8
* **GitHub Issue**: https://github.com/nodejs/build/issues/2373

## Present

* Richard Lau (@richardlau)
* Rich Trott (@Trott)
* Johan Bergström (@jbergstroem)
* Ash Cripps (@AshCripps)
* John Kleinschmidt (@jkleinsc)
* Michael Dawson (@mhdawson)

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

* Align on biggest concerns

* Michael
  * Download metrics (Ash working on)
  * Responsiveness on issues
  * Additional build resources
  * Better documentation of website etc.

* Ash -> biggest issue when infra machines have gone done
  * advance notice will help significantly here

* Rich
  * Access to machines, ex debug on raspberry pi
  * monitoring would be huge
  * in the past issues with vendor specific outside of IBM machines
  * not enough windows experts

* Johan
  * Set up grafana, to monitor our machines
  * Want to achieve red/green dashboard. Something needs to be done or not
  * challenge is in gradient, machine does not go down,
  * how to collect info on “not working as intended”
  * Cloudflare load balancer issue


* Jenkins ecosystem: timely responses to issues like things going offline

* Call with Brian (https://github.com/nodejs/build/issues/2354)
  * Should be a call scheduled  this week or next
  * Has some ideas in mind for people on the Linux IT side who might be able to help us think
    about some of these things.


* What’s new since last time
  * Richard Lau (@richardlau)
    * Working on IBM i ansible/getting machines into the infa
    * Job to test, looking to add to run nightly
  * Rich Trott (@Trott)
    * Opening a file on rpi in ci keeps event loop open (nodejs issue: )
    * Looking and thinking about debug
    * Supporting Matheus in using github actions for a commit queue
  * Johan Bergström (@jbergstroem)
    * Cleaning old jenkins jobs / backup
    * Check old backup jobs
    * Monitoring
    * Cloudflare logs
    * Split downloads and handle storage/caching differently
  * Ash Cripps (@AshCripps)
    * Orka Setup
    * Macstadium vsphere migration
    * Restoring Download metrics
  * John Kleinschmidt (@jkleinsc)
    * Looking into Apple Silicon for CI (electron)
  * Michael Dawson (@mhdawson)
    * Nothing interesting, mostly talking to Ash/Richard on the items they
      are working on.
    * Back and forth on Build resources with Foundation team


## Q&A, Other
* None this week

## Upcoming Meetings


* **Node.js Foundation Calendar**: https://nodejs.org/calendar


Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
