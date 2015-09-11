# io.js Build WG Meeting 2015-04-15

## Links

**Public YouTube feed**: http://youtu.be/801v7zcUOBE
* **GitHub Issue**: https://github.com/iojs/build/issues/74

## Agenda

* Discussion of State of the Build doc
* Access to machines for io.js collaborators

## Minutes


### Present

* Johan Bergström @jbergstroem
* Rod Vagg @rvagg

### State of the Build

* Rod presented his State of the Build doc as written in https://github.com/iojs/build/issues/77
* Some discussion about ARMv7 - agreed that the move to Debian Wheezy builds is a first step on solving this problem.

### Access to machines for io.js collaborators

* Johan: TIMEOUTs on Windows are still a problem but are Jenkins-specific, it would be good to allow access to io.js collaborators so they can reproduce.
* Rod: we can give access to collaborators fairly easily but even nicer might be to make disk images of Windows machines so we can spin up dedicated environments for them.
* ACTION: Johan to document something for the io.js repo regarding hardware access, COLLABORATOR_GUIDE.md would be the obvious place for this to go.
* ACTION: Rod to investigate disk images for Windows machines.

### State of libuv

* Johan: how much should we care about libuv? the state of their test suite across platforms isn't so great.
* Rod: visibility into what's failing is key IMO, giving feedback on PRs will be a good step to helping solve this.
* Johan: moving closer to packagers (for OSs / distros) should be helpful here because they are often the first to pick up problems.
* ACTION: Rod to continue work on automation of PRs including feedback to GitHub.

### Scope of responsibility

* Rod: should we explicitly expand our scope to include the build resources inside iojs/io.js, like `configure`, `Makefile` and `vcbuild.bat`.
* ACTION: Rod to adjust Build WG docs to explicitly state that we take responsibility for build resources in iojs/io.js. Also need to PR against WORKING_GROUPS.md in iojs/io.js and have discussion there.

### Test platform permutations

* Johan: we have a history of being able to build against shared libraries. Test suite/setup doesn't take shared library permutations into account. Would be good to uphold the quality of shared builds.
* Rod: maybe one solution is to have a second CI set so we can do more complex testing and only do it on the master branch.
* Johan: splitting up our build sets so we can have a controller application orchestrate which CI sets are run and make those decisions _outside_ of Jenkins.
* Johan: some permutations for shared libraries we need to care about are shared libuv, http_parser, zlib, openssl. c-ares has diverged from upstream so it doesn't make sense for it to be separate. Start off for now with current bundled versions of zlib and openssl, install shared libuv and http_parser and try to build against those.




