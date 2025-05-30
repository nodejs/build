# Node.js  Build WorkGroup Meeting 2025-05-29

## Links

* **Recording**:  <https://www.youtube.com/watch?v=HTVMRyjd-Bk>
* **GitHub Issue**: <https://github.com/nodejs/build/issues/4086>

## Present

* Michael Dawson (@mhdawson)
* Milad Farazmand (@miladfarca)
* Richard Lau (@richardlau)
* Ryan Aslett (@ryanaslett)

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Require Physical 2fa for Build WG & Web Infra members [#4063](https://github.com/nodejs/build/issues/4063)
  * Michael, we chatted about it last time
  * Richard, what I remember is that we were going to ask if there were other projects that had
    used it, some discussion in the issue, but references were just for requiring 2FA but not
    necessary hardware which this issue is proposing
  * Ryan can ask if there are still hardware tokens available through Great 2FA effort
  * Sounds like require is too strong, but encourage and recommend does make sense
    * Michael will comment on the issue to that effect

* Potentially transition to 1password for secrets management [#4039](https://github.com/nodejs/build/issues/4039)
  * Ryan opened this up as changing the infra from our current secret repo which has some challenges, hard to track, offboarding is hard to do.
  * This may not solve all issues but the primary value of it would be to have a log of changes.
  * Richard, one aspect is that using 1 password may widen who has access to the secrets (all
     TSC members as owners) so we should make that decision on purpose versus just
     accidentally expanding.

* Transition from Digicert keylocker to Azure Trusted Signing
[#4036](https://github.com/nodejs/build/issues/4036)
  * keylocker is too expensive.
  * Pull request opened: <https://github.com/nodejs/node/pull/58502>

* Replace Works on Arm machines affected by Equinix Metal sunset (June 2026) [#3975](https://github.com/nodejs/build/issues/3975)
  * Sent a followup and got a response.
  * We can get a replacement and that's all we know at the moment. Not sure about the timeline right now.

* Infrastructure for Orka (2024 and beyond) [#3686](https://github.com/nodejs/build/issues/3686)
  * Should close this issue. Happily running on Orka now.
  * Follow on in <https://github.com/nodejs/build/issues/4083>.

* New Machine requirement: Replacement for Equinix x64 servers [#3597](https://github.com/nodejs/build/issues/3597)
  * There was an outstanding machine, didn't want to touch it due to it being old.
  * Built a new machine under the OpenJS Azure account (Not the Node.js Azure account). It is setup and it works.
  * We can probably remove the load balancer situation.
  * Ultimately would like to remove this unencrypted machine entirely.

## Q&A, Other

* Might need to upgrade compilers soon from gcc 12 to gcc 13 to be able to support new features (i.e std::format). Will also look into using Clang down the road.

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
