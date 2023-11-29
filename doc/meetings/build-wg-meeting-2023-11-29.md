# Node.js  Build WorkGroup Meeting 2023-11-29

## Links

* **Recording**:  https://www.youtube.com/watch?v=VmecT3jHhIA
* **GitHub Issue**: https://github.com/nodejs/build/issues/3574
* **Minutes Google Doc**: https://docs.google.com/document/d/1T-XgotW8hhC1DJjIWrVwp_aAzj5ybsueaB1ZvhUOvRk/edit

## Present

* Build team: @nodejs/build
* Ulises Gascon: @ulisesGason
* Michael Dawson: Michael Dawson
* Michael Zasso: @targos


## Agenda

## Announcements

* No announcements

*Extracted from **build-agenda** labeled issues and pull requests from the **nodejs org** prior to the meeting.

### nodejs/build

* Discuss state of r2 migration on Build WG meeting [#3508](https://github.com/nodejs/build/issues/3508)
  * Michael Z
     *  current state is that we tried a few times to synchronize releases during publish, but that fails, possibly because cloudflare is hitting machine due to cache invalidation
     * had thought it was openssl machine, but not fixed by updating ubuntu version, so don’t believe it was.
     * That is the main problem we need to figure out to proceed (the failure of the sync to R2 as part of doing a release)
     * Richard could be load due to invalidation of cache due to nightly or canary builds
       * Possibly try to avoid the nightly/canary builds during publish to rule that out
  * Ask Moshe if he can look at implementing the suggested approach
    * Richard will update the issue with the approach
  * Had been a different issue with the download page where scraping was broken, this was fixed to present the index in similar format to previous way. May be better to find a better/safer way to parse

* ansible: add cloudflare-deploy role [#3501](https://github.com/nodejs/build/pull/3501)
  * was original proposal to add the R2 clients onto the release machines, took a different approach, but related to discussion above.

* Your DigiCert Code Signing certificate expires in 90 days [#3491](https://github.com/nodejs/build/issues/3491)
  * Underway, worked with Foundation to buy the certificate  and Stephen is working on using the new certificate and signing mechanism - https://github.com/nodejs/node/pull/50956

* \[DigiCert\] 2FA will be turned on for your account [#3453](https://github.com/nodejs/build/issues/3453)
  * @mentioned bensternthal to confirm that the account used to create the new certificates are a different account.

* Almost all the windows machines are DOWN [#3435](https://github.com/nodejs/build/issues/3435)
  * Machines have been restored, added to agenda to ask Stefan for post-mortem
  * Close and we’ll see if it re-occurs

* Self-nomination, @ovflowd to the Build WG [#3426](https://github.com/nodejs/build/issues/3426)
  * Discussed in the last meeting
  * Suggested that Claudio start joining the meetings as a first step
  * Agreed we can add him at test level, but Michael confirm with him in advance that he’s interested given that won’t give access to some of the things he might have wanted to be modifying directly.

* DigitalOcean www server [#3424](https://github.com/nodejs/build/issues/3424)
  * Top level issue to track the flakiness of the DO server
  * Michael Z, when updated to ubuntu 22, also bumped to premium CPUs
  * Agreed to remove from build agenda

* NearForm Benchmarking Servers [#3390](https://github.com/nodejs/build/issues/3390)
  * Discussed in meeting added comment to issue

* Setup Terraform Cloud account [#3370](https://github.com/nodejs/build/issues/3370)
  * Have the permissions
  * Need to refresh the Terraform,should we wait until after the R2 migration ?
    * We agreed to wait until after R2 migration to make things easier for everybody.

* Infrastructure for MacOS 12.x [#3240](https://github.com/nodejs/build/issues/3240)
  * Now news, Ulises will work back on this in January after v21.6.0 release.

* Membership audit [#3144](https://github.com/nodejs/build/issues/3144)
  * Needs somebody to go through the offboarding steps
    * https://github.com/nodejs/build/blob/main/OFFBOARDING.md
    * @UlisesGascon will do the GPG steps
    * @ Michael will do the other steps

* Interest in establishing a "Build Helper" role [#2550](https://github.com/nodejs/build/issues/2550)
  * skip for this week

### nodejs/admin

* Cloudflare access for @nodejs/web-infra [#833](https://github.com/nodejs/admin/issues/833)
  * Preferred option is to go down Terraform path
  * Read access was provided as temporary step

## Q&A, Other
- Adding production tokens to Github Actions (seek for agreement) (Ref: jenkins alerts for releases, email alias update, terraform project...)
Notarization on MacOS (https://github.com/nodejs/build/issues/3538)
  - This will be discussed offline.
  - The biggest issue is how to prevent the tokens from being leaked in the Github Actions logs, malicious PRs, etc.. Research needs to be done.
- Tarballs will need to be notarized (this is an issue for some combination of MacOS version and architectures)
  - This has being an issue for a while.
  - We need to find a way to notarize the tarballs.
  - We need to check if we can retroactively notarize the tarballs.

	 
## Upcoming Meetings

* **Node.js Project Calendar**: <https://nodejs.org/calendar>

Click `+GoogleCalendar` at the bottom right to add to your own Google calendar.