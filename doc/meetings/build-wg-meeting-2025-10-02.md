# Node.js Build WorkGroup Meeting 2025-10-02

## Links

* **Recording**: https://www.youtube.com/watch?v=wBxzhXwPDMM 
* **GitHub Issue**: https://github.com/nodejs/build/issues/4162
* **Minutes Google Doc**: https://hackmd.io/@openjs-nodejs/B1LfqRvnll

## Present

* Milad Fa @miladfarca
* Richard Lau @richardlau
* Ryan Aslett @ryanaslett 


## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Update infrastructure providers list [#4104](https://github.com/nodejs/build/issues/4104)
    * Did a bit of a cleanup. The Build working group needs to figure out who is on that list and work with the Openjs marketing team and ask them to rewrite it
    * [Parallel work going on in website repo](https://github.com/nodejs/nodejs.org/pull/7991)
* Upgrading the compiler toolchain [#4091](https://github.com/nodejs/build/issues/4091)
    * Upgrading the remaining Ubuntu machines
    * AIX and SmartOS remains
* Add macOS 15 CI images with Xcode 16.4 [#4083](https://github.com/nodejs/build/issues/4083)
    * We are done with Xcode 16.4. Images are built and deployed
    * Packer files have been reworked
    * Workflow that lints Packer files needs to be updated
* DigitalOcean usage [#3563](https://github.com/nodejs/build/issues/3563)
    * Let's figure out if we are using or need all the resources
    * Old snapshots can also be removed

### nodejs/node

* Enabling Rust support for Temporal [#58730](https://github.com/nodejs/node/issues/58730)
    * Work is in progress

## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
