# Node.js Foundation Build WG Meeting 2016-06-28

GitHub issue: https://github.com/nodejs/build/issues/438

Meeting video: http://www.youtube.com/watch?v=0yRT8h2WDJw

Previous meetings: https://docs.google.com/document/d/165tby7jyuYo4cXVrwQxUAQAzZMAJVj_UD4vnBmodu_4/edit


## Present

* Joao Reis
* Michael Dawson
* Myles Borins

## Standup

* Joao Reis
  * Investigated Raspberry Pi CI failures, no conclusion yet.
* Michael Dawson
  * Chasing PPC issues, VMs have been moved to a new node,
    ran a number of tests both v8 and node BVT tests and
    they look good so added back to regular runs and will
    watch for the next few days.
* Myles
  * Working on improving speed of CITGM. Current experiments
    showing a 200 - 400% improvement
  * Research electron alternative to installer
  * Backport V8 test runner to v4.x


## Minutes

Talked through/reviewed this issues:

 * OS X buildbots/ci: call to action \[#367]
 * rsync endpoint to mirror the releases \[#55]
 * Run and deploy nodejs-github-bot \[#404]

Not many updates so we did not discuss them in depth.  On 404 will
see if we can find a time people are around as opposed to just
waiting until the next meeting.

Talked about installers
  * Myles working on electron based installer
  * Wanted feedback from this group
  * Joao mentioned that msi is really the right thing to use for Windows,
    but some wrapper installer to install the msi could make sense.

## Next meeting
July 19th, 8pm UTC
