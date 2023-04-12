# Node.js  Build WorkGroup Meeting 2023-04-11

## Links

* **Recording**: https://www.youtube.com/watch?v=nz1Pl-sAHbg
* **GitHub Issue**: https://github.com/nodejs/build/issues/3297
* **Minutes Google Doc**: https://docs.google.com/document/d/1gOIwx3gswuYWF4CkZIJfW9q6wjqcnWDtGh4O-C1rXuw/edit

## Present

* Build team: @nodejs/build
* Ulises Gascon @ulisesGascon
* RIchard Lau @richardlau
* Michaël Zasso @targos
* Moshe Atlow @MoLow
* Stewart X Addison @sxa

## Agenda

## Announcements

*Extracted from **build-agenda** labelled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Terraforming Cloudflare [#3270](https://github.com/nodejs/build/issues/3270)
  * We want to use Terraform to consolidate the Cloudflare configuration in the repository so it will be more transparent and easy to manage any new change
  * There are concerns as Terraform is a new tool for the team and Cloudflare is very sensitive infrastructure for Node.js as a bad configuration can break the Node.js downloads
  * Cloudflare has many settings/rules that are in place but we don’t have all the knowledge to understand them in detail
  * Ulises will prepare a POC in a pet project to present to the team how the configuration is made (Github actions, PR, Terraform plans…) and then we will decide if the approach is valid for Node.js
  * Overall we want the infra config in code as much as possible  
* Infrastructure for MacOS 12.x and 13.x [#3240](https://github.com/nodejs/build/issues/3240)
  * This issue is related to Node 20
  * In macstadium we use Orka and Bare Metal machines, we agree that using only Orka will be beneficial for the infra as it will simplify things
  * Current nodes in Orka cluster doesn’t support ARM vms or macos 13.x
  * We will use Macos 11 to build Nodejs in the Release machines (drop macos10.x) as we need it for Node 20 (c++ version compatibility). This will require some changes in the tags and potentially creating a new release machine for (macos11 Intel)
  * We will need to clarify if we can get extra resources (ARM/intel nodes for Orka and deprecate Bare Metal machines) and also if we have any specific contact in the Macstadium Org to discuss changes in the sponsorship HW.
  * There are no MacOs 12 machines in the CI, just one VM in Orka.
  * Bare metal machines can not be migrated to Orka, so the process will be to decommission bare metal machines and recreate them as VMs in Orka using the images from January last backup.
  * We don’t need to test Node.js in all the Mac versions, so we can potentially ignore MacOS 12.x or 13.x 
  * Ulises will contact Orka support to get a clear idea on how much disk space do we have in the cluster and do some calculations to clarify if we need to reduce the VM disk size and check if we can remove old snapshots
* Access to Cloudflare [#3220](https://github.com/nodejs/build/issues/3220)
  * We need to change how we access to Cloudflare from a single account to a individual accounts (so it will be easier to revoke access)
  * We need to explore how to flexible is the Cloudflare system in order to grant read/write access to specific individuals to avoid accidental changes or modifications as it is hard to rollback changes
  * The access to Ovflowd won’t be granted yet, as we will first need to provide support for individual accounts.
  * Richard potentially can lead the initiative
* Membership audit [#3144](https://github.com/nodejs/build/issues/3144)
  * We are not ready to make any changes
  * We will keep the topic in the Agenda
* Disk full on downloads server [#3125](https://github.com/nodejs/build/issues/3125)
  * The server was full due nightly builds
  * Stewart made a script to manual clean the builds (PR ongoing)
  * The server currently is half full (not a risk currently)
  * Ulises will remove this topic from the agenda
* Retiring the Raspberry Pi cluster [#3102](https://github.com/nodejs/build/issues/3102)
  * Only the Inventory clean up is pending
* Improve Jenkins alerts and reporting [#3088](https://github.com/nodejs/build/issues/3088)
  * This issue was related to a POC that monitors the inventory machine by doing a ping and expose the data in Grafana
  * Ulises changed the approach to follow something similar as what has been implemented in the Security WG for the OpenSSF Scorecard Monitoring with GitHub actions but using directly the Jenkins API.
  * There is a [demo](https://github.com/UlisesGascon/jenkins-status-alerts-and-reporting-demo) repository that includes the [reporting](https://github.com/UlisesGascon/jenkins-status-alerts-and-reporting-demo/blob/main/monitor/jenkins-report.md), [database](https://github.com/UlisesGascon/jenkins-status-alerts-and-reporting-demo/blob/main/monitor/database.json) and the [issues](https://github.com/UlisesGascon/jenkins-status-alerts-and-reporting-demo/issues/65) when machines are down.
  * There is an opportunity also to implement alerts via issues when the Disk usage is in a specific threshold.
  * We agree that this idea can work for the Working Group and we can disable the workflow if we detect any bug
  * Ulises will be assigned to the issues auto-generated by the github action so he can triage them.
  * Ulises will open an issue to transfer the demo repository to the Node.js org to avoid polluting the build team repository
* MacOS 10.x deprecation [#3087](https://github.com/nodejs/build/issues/3087)
  * We need a plan to retire 10.15 machines when Nodejs 18 expires
  * We can deprecate soon 10.14 machines when Nodejs 14 expires (at the end of this month)
  * Ulises will create an issue to map the next step to deprecate the machines dedicated to 10.14 and check how we can reuse that HW for 10.15, 11 or 12
* Jenkins agents need newer Java (11+) [#3030](https://github.com/nodejs/build/issues/3030)
  * We will remove this item from the agenda
  * We are in the newest version for most of the machines already
  * Richard will close the issue soon
* Support for llnode builds [#3017](https://github.com/nodejs/build/issues/3017)
  * We need additional information to see if we can provide support
* Onboarding F3n67u to the build wg [#3003](https://github.com/nodejs/build/issues/3003)
  * It was a misunderstanding on the onboarding process
  * Ulises will close the issue
* Interest in establishing a "Build Helper" role [#2550](https://github.com/nodejs/build/issues/2550)
  * There is an ansible tower/AWX instance that can be used to run ansible playbooks against the jenkins agents.
  * You can restart machines currently and the users needs to be added to the AWX.
  * There are other potential tasks that can be added, but that will require some extra work if we want to avoid running ansible in the user’s machine
  * There is potential to articulate manual task that we do quite often like clean macos disk, etc… and let other people that we trust to manage this rutinary executions/jobs with a good UI.
  * We keep this item in the agenda

### nodejs/node

* Request for large-runners on Github CI [#45345](https://github.com/nodejs/node/issues/45345)
  * This is a TSC decision
  * We need to discuss with Github deeper or pay for this  if we want it as our current account settings does not allow it


## Q&A, Other


## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.

