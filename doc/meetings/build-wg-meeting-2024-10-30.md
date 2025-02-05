# Node.js  Build WorkGroup Meeting 2024-10-30

## Links

* **Recording**:  https://www.youtube.com/watch?v=MnMWg2sIlNI
* **GitHub Issue**: https://github.com/nodejs/build/issues/3942
* **Minutes Google Doc**: https://docs.google.com/document/d/1V4iwMa_fX6CWw1C3XpjjeAWQb4iHhsb2w3MmVnDpf5g/edit?tab=t.0

## Present

* Build team: @nodejs/build
* Abdirahim Musse @abmusse
* Michael Zasso @targos
* Milad Farazmand @miladfarca
* Richard Lau @richardlau
* Ryan Aslett @ryanaslett
* Ulises Gascon @UlisesGascon



## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Infrastructure for Orka (2024 and beyond) [#3686](https://github.com/nodejs/build/issues/3686)
  * Requested 2 new nodes that are now part of the infra
  * CI testing will be running on these machines from now on
  * Next step we can decommission the old nodes
  * Release CI is running already in the new cluster
* New Machine requirement: Replacement for Equinix x64 servers [#3597](https://github.com/nodejs/build/issues/3597)
  * New strategy in place for smartOS
  * Need to work out plan for unencrypted
  * Ryan is working on it now 
* macOS refuses to start `node` when downloaded from the tarball [#3538](https://github.com/nodejs/build/issues/3538)
  * No news
  * Ulises plan to work on it before Christmas
* Discuss state of r2 migration on Build WG meeting [#3508](https://github.com/nodejs/build/issues/3508)
  * We had a long standing issue for a while related to the promotion of releases.
    * This is fixed now for future releases
  * The are some issues with the aws s3 client and Cloudflare’s R2
    * Someone mentioned in PR that rclone might be an alternative tool
  * Currently we have some missing releases in R2 (WIP manual sync)
  * It was requested to install GH cli:  https://github.com/nodejs/build/pull/3931#issuecomment-2426435390
    * We reject the idea due security concerns
    * Currently this server is not connected to GitHub and we don’t plan to enable this communication.
  

## Q&A, Other

* Michael did the migration of the release server
  * The SSH configuration was solved and the backups are working again
* Investigate alternative jenkins access for backups[#3939](https://github.com/nodejs/build/issues/3939)
  * The backups server is using a personal token for the Jenkins connection
  * We thinking on moving this a service account
  * Discussion around current service accounts
    * We need to check that this info is disclosed to the security WG (threat model)
* 2024 Annual OSUOSL Survey (https://github.com/nodejs/build/issues/3923)
  * Discussion around the resources that we have there
  * Richard: technical info has been sent but we need to fulfill additional information (funding, CLA, etc..)
  * The expectation is that the foundation can manage this communications in the future
  * The survey will close tomorrow
  * Ryan will provide support on this

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.

