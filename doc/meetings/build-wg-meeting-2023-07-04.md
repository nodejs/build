# Node.js  Build WorkGroup Meeting 2023-07-04

## Links

* **Recording**:  https://www.youtube.com/watch?v=LxUP44zAawM
* **GitHub Issue**: https://github.com/nodejs/build/issues/3405
* **Minutes Google Doc**: https://docs.google.com/document/d/1l0rtHesVkymetXOXYitQJFDnFN6UPYNh-uehiSCgg2E/edit

## Present

* Build team: @nodejs/build
* Ulises Gascon: @ulisesGascon
* Richard Lau: @richardlau
* Michaël Zasso: @targos
* Stewart Addison: @sxa

## Agenda

## Announcements

* Extracted from **build-agenda** labeled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* DNS Wildcard problem?[#3404](https://github.com/nodejs/build/issues/3404)
  * Wildcard was implemented in the past and we don’t have the full context 
  * This topic was added to the agenda for awareness
  * Richard is planning to remove the wildcard and add explicit DNS records, this should not be a breaking change (Cloudflare level change not Nginx)
  * This is not currently a worry scenario, but the community found it surprising, so we will patch it.
* NearForm Benchmarking Servers [#3390](https://github.com/nodejs/build/issues/3390)
  * NearForm is scaling back, this will potentially impact Benchmarking machines only (two intel servers).
  * We can rebalance the impacted machines into other infra available spots but this will make the relocated machines potentially slower and less reliable.
  * We are following up in the issue
* Action required by Apple: Transition to the notarytool command-line utility [#3385](https://github.com/nodejs/build/issues/3385)
  * There is a script migration needed in order to fulfill the requirements.
  * Notarytool requires Xcode 13, so mac 10.15 can be affected.
  * Currently we use [Gon](https://github.com/mitchellh/gon), there is a [pull request](https://github.com/mitchellh/gon/pull/70) with a WIP proposal to add support. This might solve the issue, but the project seems inactive.
  * As we only use notarization, it might we a easier way to use directly Notarytool and update our script with that
  * Historically we used Gon to wait for the confirmation from Apple about the notarization, but seems like Notarytool provides already this feature
  * This can be a risk for the project if we don’t solve the situation before November
  * Node.js 16 will be EoL by Sep’23
  * Node.js 18 will need to build on macOS 11 since September/November’23 (To be confirmed any incompatibility)
  * Ulises will lead this initiative with the support from Richard and Michaël
  * Ulises will need to get an Apple Developer Account and might need access to certificates (TBC). The team seems comfortable with this idea, we will open an issue for the permission if needed
* Terraform 
  * Related: Setup Terraform Cloud account [#3370](https://github.com/nodejs/build/issues/3370)
  * Ulises has created a PR for supporting Terraform: https://github.com/nodejs/build/pull/3391
  * Ulises will re-sync the terraform files to match the current Cloudflare state
  * Richard / Michaël will add the token missing for the PR in order to properly run the new Github actions pipeline
  * Any change from terraform files won’t trigger any real change in Cloudflare as we are using read only tokens, we agree to keep this approach until we feel ready to enable write access.
  * In order to prevent accidental deployments or similar, we agreed to update the logic in the pipeline and do `terraform apply` only when there is an event like new release/deployment created, Ulises will update the logic
  * Michaël will add the Terraform Cloud Token to the secrets repo
* Experiment with Node.js Website Traffic on Vercel [#3366](https://github.com/nodejs/build/issues/3366)
  * Claudio is checking with Cloudflare Support
  * This is ongoing and blocking Vercel initiative
  * It is important to protect the download server and avoid funky setups
  * Maybe we can ask for support from the Linux foundation (Sovereign Tech Fund initiative)
* Infrastructure for MacOS 12.x [#3240](https://github.com/nodejs/build/issues/3240)
  * Not a lot of news
  * ulises will ask for support if he is still stuck with Ansible playbooks.
  * There are empty spots (2-3 potentially) in Orka that we might we able to reuse.
  * Images without Xcode installed can be quite limited. Ulises to confirm if new images can include xcode properly installed. 
  * The Orka Snapshots are not properly restored (since the beginning of the year)
* Membership audit [#3144](https://github.com/nodejs/build/issues/3144)
  * Skipped due time
* Support for llnode builds [#3017](https://github.com/nodejs/build/issues/3017)
  * Skipped due time
* Interest in establishing a "Build Helper" role [#2550](https://github.com/nodejs/build/issues/2550)
  * Skipped due time
* Related: Access to Cloudflare [#3220](https://github.com/nodejs/build/issues/3220)
  * We agree to provide read access level to Claudio


## Q&A, Other

## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.

