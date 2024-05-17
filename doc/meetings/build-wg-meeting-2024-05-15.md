# Node.js  Build WorkGroup Meeting 2024-05-15

## Links

* **Recording**:  https://www.youtube.com/watch?v=CVmBq_wFd-8
* **GitHub Issue**: https://github.com/nodejs/build/issues/3716
* **Minutes Google Doc**: https://docs.google.com/document/d/1PFqf2H5gW12K92QEcoiDjH9Y2l_oFEZ-VOjEhtkZlN8/edit

## Present

* Ulises Gascon: @UlisesGascon
* Michael Dawson: @mhdawson
* Richard Lau: @richardlau
* Moshe Atlow: @MoLow

## Agenda

## Announcements

Github bot is currently not working. There is an issue with the dependencies. It will require some manual work as not everything can be done via the current Ansible scripts. Note that this is a legacy service (Node@14). https://github.com/nodejs/build/issues/3720
Code static analysis is broken and we have an alternative in place
We needed to update the Python version on the release machines due the new version of gyp-next.



*Extracted from **build-agenda** labeled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Infrastructure for Orka (2024 and beyond) [#3686](https://github.com/nodejs/build/issues/3686)
  * Path has been defined in the issue
  * Onboarding with Ryan complete, he will take ownership of adding MacOS 13 nodes
 * Right now our physical arm machines are down. The only arm testing on OSX is in
 GitHub actions
* Extend Azure credits (Action prior May 10th) 
[#3672](https://github.com/nodejs/build/issues/3672)
  * assume this has been handled and machines are still running.
  * Ulises will add a comment to the issue to confirm it’s been handled. https://github.com/nodejs/build/issues/3672#issuecomment-2112514820
* New Machine requirement: Replacement for Equinix x64 servers [#3597](https://github.com/nodejs/build/issues/3597)
  * Some progress
  * Richard will open an issue to extend the permissions for Ryan
* macOS refuses to start `node` when downloaded from the tarball [#3538](https://github.com/nodejs/build/issues/3538)
  * plan to work on after back from vacation in a few weeks
* Discuss state of r2 migration on Build WG meeting [#3508](https://github.com/nodejs/build/issues/3508)
  * leave on agenda for discussion next time as we don’t have enough context
  * Michael: would like to get this on the LinuxIT list to help with as well as overall release downloads.

## Q&A, Other

* Ulises will ask LFIT to define a process on how to collaborate in practical terms (tickets, tracking , etc..)  

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.

