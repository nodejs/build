# Node.js  Build WorkGroup Meeting 2025-03-27

## Links

* **Recording**:  <https://www.youtube.com/watch?v=VMfqX6dc_2I>
* **GitHub Issue**:<https://github.com/nodejs/build/issues/4047>

## Present

* Michael Dawson (@mhdawson)
* Milad Fa (@miladfarca)
* Richard Lau (@richardlau)
* Nguyen Duc Thien (@iuuukhueeee)
* Ryan Aslett (@ryanaslett)

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Potentially transition to 1password for secrets management [#4039](https://github.com/nodejs/build/issues/4039)
  * Ryan, looking for a 1 password to get access to experiment with, need one where they are
    the owner

* Transition from Digicert keylocker to Azure Trusted Signing [#4036](https://github.com/nodejs/build/issues/4036)
  * Ryan, windows release machine don’t seem to be in build WG inventory
  * Richard they are in the version of the inventory which are in the secrets repo because of the
    way they are defined in azure
  * Ryan, relying on Stefan as windows not in wheel house
    * Suggestion from Stefan was to wait until he finishes his work on moving Windows to clang
      because this won’t be a big issue for a few months
    * Plan is to set it up for Appium who also needs it, so when Stefan is ready the
      infrastructure/setup on the Azure side is ready.

* Equinix Metal sunset, June 2026 [#3975](https://github.com/nodejs/build/issues/3975)
  * Richard, next action was on me, need to get the email chain going to discuss what we can
    get from somewhere else. Have not done that yet but will.
* Infrastructure for Orka (2024 and beyond) [#3686](https://github.com/nodejs/build/issues/3686)
  * Just about to add an issue to the agenda
  * Solved the build issue that was making build take so long. Really weird mount point to share
    ccache cross ephemeral user. Writes have been done such that they are no readable from
    other machines. Added recursive change for all ccache files to make them writable. Takes
    about 15 mins but builds are now down to 45 minutes from 2 hours which should be ok. Test
    should now be ok.
  * Release side is still an issue, as they are taking 5-5.5 hours. The releases don’t current use
    ccache so would be significantly sped up.
    * Good discussion path forward to investigate how to set up on release machines

* New Machine requirement: Replacement for Equinix x64 servers [#3597](https://github.com/nodejs/build/issues/3597)
  * Ryan still the rsync server, plan to rebuild it on mnx
    * Have run into some provision limits

## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.
