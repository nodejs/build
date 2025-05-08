# Node.js Build WorkGroup Meeting 2025-05-08

## Links

* **Recording**:  <https://www.youtube.com/watch?v=U7gUsDzUj8c>
* **GitHub Issue**: <https://github.com/nodejs/build/issues/4076>

## Present

* Michael Zasso @targos
* Ryan Aslett (@ryanaslett)
* Michael Dawson (@mhdawson)
* Richard Lau (@richardlau)
* Duc Thien (@iuuukhueee)
* Abdirahim Musse (@abmusse)
* Milad

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Require Physical 2fa for Build WG & Web Infra members [#4063](https://github.com/nodejs/build/issues/4063)
  * Some discussion
  * Michael, any existing Open source projects that have enforced that requirement.

* Potentially transition to 1password for secrets management [#4039](https://github.com/nodejs/build/issues/4039)
  * 2 things, would be better to rotate more often but a different issue/discussion
  * The other access to past commits in the private repo
  * Michael, main thing is the part about running ansible using some of the data
    from the secrets

* Transition from Digicert keylocker to Azure Trusted Signing [#4036](https://github.com/nodejs/build/issues/4036)
  * Azure infrastructure is in place, continuing to make progress
  * Plan is still to get moved before we run out of signatures
  * Ryan - May be worth buying another 1000 signatures if we run out

* Replace Works on Arm machines affected by Equinix Metal sunset (June 2026) [#3975](https://github.com/nodejs/build/issues/3975)
  * [RL] email sent out to ask about alternatives, need to follow up

* OSU machines at Risk [4073](https://github.com/nodejs/build/issues/4073)
  * Would affect all arm machines that are not in works on arm
  * ½ AIX machines
  * All PPCle Power machines
  * Ryan will try to get some feeling of how much notice we might have

* Infrastructure for Orka (2024 and beyond) [#3686](https://github.com/nodejs/build/issues/3686)
  * Ryan has resolved the x64 file system permissions issue with ccache.
  * Need to tidy up and capture everything done in the Packer set up.

* New Machine requirement: Replacement for Equinix x64 servers [#3597](https://github.com/nodejs/build/issues/3597)
  * Everything migrated except unencrypted.
  * Deadline has passed and credits are no longer available.
  * Ryan will prioritise.

## Q&A, Other

None

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
