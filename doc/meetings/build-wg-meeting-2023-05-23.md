# Node.js Build WorkGroup Meeting 2023-05-23

## Links

* **Recording**:  https://www.youtube.com/watch?v=D2Qi3bRH-0s
* **GitHub Issue**: https://github.com/nodejs/build/issues/3362
* **Minutes Google Doc**: https://docs.google.com/document/d/1ZkdfObzP6x5q_wRagoCSGQnF6gPR7Tje9B8tCtnT2m4/edit

## Present

* Build team: @nodejs/build
* Richard Lau @richardlau
* Stewart Addison @sxa
* Ulises Gascon @ulisesgascon


## Agenda

## Announcements

* No announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Infrastructure for MacOS 12.x and 13.x [#3240](https://github.com/nodejs/build/issues/3240)
  * With the current setup in Orka only Intel MacOS 12.x supported by the Nodes.
  * MacOS 12.x for ARM can potentially fit in the Macstadium Bare Metal machines if we manage to do a proper virtualization as they are already running MacOS 11.x ARM (2 tests and 1 for release)
  * As we are running out of space in Orka, we will erase images and keep only 2 images per MacOS version (with the test keys and with the release keys). See: https://github.com/nodejs/build/issues/3257 
  * We decided to focus on MacOS 12.x for now, and work in MacOS 13.x when MacOS 10.15 or MacOS 11.x got decommissioned.
  * We discarded to ask for changes in the sponsorship, so we will keep the infra as it is now. So this will discard the plan to convert Bare Metal instances into Orka Nodes.
  * Ulises will calculate the Disk size needed for the MacOS VMs (MacOS running, updates and Build jobs)
  * Ulises will work on a new draft plan for Orka in the issue with the input from the meeting.
  * Ulises will explore how the virtualization can be done (including licenses) for the Bare Metal machines.
* Access to Cloudflare [#3220](https://github.com/nodejs/build/issues/3220)
  * Richard managed to add individual accounts, so now it is easier to add members with specific access level and the audit logs will be clear
  * There are many possible roles in Cloudflare (as there are many products, etc..)
  * Ulises will ask Cloudflare access with read only level to follow with the Terraform DNS project: https://github.com/nodejs/build/issues/3270 and ask permissions to create a project for it in the Node.js Org
* Membership audit [#3144](https://github.com/nodejs/build/issues/3144)
  * No news
* Improve Jenkins alerts and reporting [#3088](https://github.com/nodejs/build/issues/3088)
  * Since the deployment the Cron Job was changed to avoid generating false positive down alerts when machines have a reboot cron job
  * The alerting seems useful
  * Ulises will add support to auto-closing issues when the machines are up again
  * Ulises will add alerts for disk usage
  * Ulises will add Slack notifications integration
* Support for llnode builds [#3017](https://github.com/nodejs/build/issues/3017)
  * We need to check if this issue still relevant
* Interest in establishing a "Build Helper" role [#2550](https://github.com/nodejs/build/issues/2550)
  * No news since previous discussions
  * We will need to identify repetitive tasks that we can fit into this initiative (like website rebuild)
  * We will need to provide training in order to make it accessible


## Q&A, Other

* Richard is starting to dismantling some infrastructure related to benchmarking (more CI / pipelines than machines itself). The old coverage website stopped working last year.

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.