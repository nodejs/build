# Node.js  Build WorkGroup Meeting 2025-03-13

## Links

* **Recording**:  <https://www.youtube.com/watch?v=Uf37Cvw6ka8>
* **GitHub Issue**: <https://docs.google.com/document/d/1dFhfvyQf6VLpHEBUbftG4-zKaMOb-FZnm_ypXw0itVI/edit?tab=t.0>

## Present

* Michael Dawson @mhdawson
* Milad
* Richard Lau @richardlau
* Ryan Aslett @ryanaslett
* Nguyen Duc Thien @iuuukhueeee

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Certificates expiring on 2025-03-30 [#4029](https://github.com/nodejs/build/issues/4029)\
  * Ryan has already update, close
  * Existing purchase is good for 2027, just need to issue every 13 months

* Automate SSL Cert infrastructure [#4038](https://github.com/nodejs/build/issues/4038)
  * Ryan, not necessarily any need to pay for certificates
  * Recommended approach is LetsEncrypt with certbot
  * No objections from those in the meeting
  * Some discussion about libuv, Richard confirms the project does not host any libuv assets any
    more
  * Ryan are there other certs ?
    * Seems like we have iojs.org/download

* Equinix Metal sunset, June 2026 [#3975](https://github.com/nodejs/build/issues/3975)
  * confirmation that arm servers are going to go away, before sunset date
  * Richard has reached out to arm, they have indicated that they have other provides, we
    should pursue those. Best bet is to add Ryan to thread discussing alternatives and find
    more technical contact so that we can figure out which option is the best.
    * biggest challenge is that our existing h/w is super powerful so replacement may not
      be as powerful.
  * Ryan, we don’t necessarily need access to the openstack level, access to the specific
    machines would be fine. If we can just get ssh key added that should be fine.
  * Richard will loop in Ryan as next action.

* Infrastructure for Orka (2024 and beyond) [#3686](https://github.com/nodejs/build/issues/3686)

* New Machine requirement: Replacement for Equinix x64 servers
[#3597](https://github.com/nodejs/build/issues/3597)
  * Everything except unencrypted has been replaced
  * Rsync logs show there is a significant amount of downloads
  * Michael 2 things that likely motivated separate machine
    * security (more sensitive things are on www server)
    * load
  * Richard might be better on the load from on www server, but from the security perspective we
    should retain a separate machine.
  * Ryan will move somewhere, could move over to MNX, could look at the other service
    providers. Do we have effective ansible for unencrypted.
    * Richard, have been trying to mirror over but have not tested/run the ansible scripts so
      probably not.
    * Michael, ideally this is the time to make sure we can with fallback to existing machine
  * Ryan mentioned saw issue related to running out of file descriptors in logs
    * Richard, this is a known long running issue which we could never figure out

* Transition from Digicert keylocker to Azure Trusted Signing #4036
<https://github.com/nodejs/build/issues/4036>
  * Sounds like there is a plan, make sure Stephan knows plan as he has the most context

* Potentially transition to 1password for secrets management #4039
<https://github.com/nodejs/build/issues/4039>
  * build not using it
  * Michael issue before has been the the automatic use of secrets
  * ok to experiment,

* Ryan, for release builds not using cached
  * might be why intel builds are taking so long

## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
