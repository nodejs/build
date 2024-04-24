# Node.js  Build WorkGroup Meeting 2024-04-23

## Links

* **Recording**:  https://www.youtube.com/watch?v=mhUpD1BEKCc
* **GitHub Issue**: https://github.com/nodejs/build/issues/3689
* **Minutes Google Doc**: https://docs.google.com/document/d/1TTpO99g7x7UcCO3c6irH8-2WeQQyBLW50I8xXvw42kg/edit

## Present

* Build team: @nodejs/build
* Ulises Gascon (@UlisesGascon)
* Michael Dawson (@mhdawson)
* Michael Zasso (@targos)
* Abdirahim Musse (@abmusse)
* Richard Lau (@richardlau)


## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Infrastructure for Orka (2024 and beyond) [#3686](https://github.com/nodejs/build/issues/3686)
  * Firewall was updated, as they had suggested a while back
  * Ulises, working on allocation of machines. Plan is to put more resources into Orca
    * we should get 3 arm Nodes, discussion is if the Foundation will pay for them. Each node
      should host 2 machines
    * Discussion, how do we distribute the machines
      * Missing from migration from Nearform 2 MacOs 11 for test
      * Michael, Z would be good to have second release machine
    * Michael, thoughts on newer version ?
      * lots of intel space, but would still be tight on MX
      * Richard, GitHub actions provide some coverage as they now support MacOS 14 on MX
    * Ulises will create a PR to provide access to Ryan for infra-mac and release in the secrets repo.

* Extend Azure credits (Action prior May 10th) [#3672](https://github.com/nodejs/build/issues/3672)
  * Stefan said he would take care of it
  * Ben will talk with João about the foundation getting involved in doing routine renewals
    like this. 

* Nearform can no longer host machines [#3615](https://github.com/nodejs/build/issues/3615)
  * Lets take off agenda, still some discussion about what to do with old machines.

* New Machine requirement: Replacement for Equinix x64 servers [#3597](https://github.com/nodejs/build/issues/3597)
  * No recent update, agreed Michael D would add comment in issue asking for update

* macOS refuses to start `node` when downloaded from the tarball [#3538](https://github.com/nodejs/build/issues/3538)
  * tarballs are not notarized, was not a requirement in the past, now is that is cause of the
    refuse to start
  * Ulises, have started looking at them, and experimenting.

* Discuss state of r2 migration on Build WG meeting [#3508](https://github.com/nodejs/build/issues/3508)
  * waiting on 22 before we do some more changes/test

* Interest in establishing a "Build Helper" role [#2550](https://github.com/nodejs/build/issues/2550)
  * No updates
  * Remove from agenda

### nodejs/admin

* Cloudflare access for @nodejs/web-infra [#833](https://github.com/nodejs/admin/issues/833)
  * agreed to remove from agenda.


## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.

