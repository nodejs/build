# Node.js Foundation Build WG Meeting 2015-12-22

## Links

* **GitHub issue:** https://github.com/nodejs/build/issues/283
* **Meeting video:** http://www.youtube.com/watch?v=PKFUFWGHF48
* **Meeting minutes:** https://docs.google.com/document/d/1zScaSAUZiGrbhEk9mFxA8l3isoDq34p3J8TwNnpG5xg
* **Previous meeting:** https://docs.google.com/document/d/1zFMmIYUP1tA_YS_sx7P0-vZQ3zy3sOYGSG73otRvoSc

## Present

* Alexis Campailla (@orangemocha)
* Johan Bergström (@jbergstroem)
* Rod Vagg (@rvagg)

## Standup

* Johan Bergström
  * Redeploying our infrastructure.
  * Reusing resources at Joyent, expose networking issues not suitable for test
    suite. We can still use it for linting, etc
  * Redeploying PPC machines to have more smaller instances
  * Investigating network issues on PPC
  * New version of GitHub poller
  * Big ansible refactoring, due in January, will require ansible 2.0

* Alexis Campailla

* Rod Vagg
  * Chasing log files for nodejs.org. Logs going back to May 2014. WE have a gap
    from September

## Minutes

### Option to run V8 test suite [#199]

No updates.

### PPC platforms as part of standard release [#205]

Machines not available. Adding machines to release job.

### How to add node-gyp and nan in Jenkins

Alexis: Nan runs with appveyor and travis [#206], will follow the pattern of
[serialport-test-commit-windows](https://ci.nodejs.org/job/serialport-test-commit-windows/build)

Rod: best to run a variety of versions of node. Same deal for node-gyp and nan.
Also add node-gyp and nan to node tests.

### Test coverage on ARM hardware

Rod: I've been pondering our ARM hardware and would like to discuss how we might
go about ensuring that we have hardware test coverage that is as close as
possible to what is being used in the wild for Node—for IoT, hobbyist, etc.
users. Consider how newer platforms like Pi Zero have the potential to change
the landscape. Also think of MIPS and how we have zero coverage there. It might
be something we can defer to the Hardware WG, maybe they can do some surveys or
perhaps they have existing data.

Rod: We have no data on which platforms are popular. Ask for help from the
hardware WG to provide us with data.

Alexis: add telemetry to Node?

Rod: might not go down well

## Getting resources OSX

Rod: hosting is the biggest problem. We need donations or buy OSX infrastructure
service

Alexis: ask for donations and if target not reached, ask for foundation budget?

Rod: what would make a good hosting setup? A big company?

Alexis: are there any virtualization providers? We need to do some research.

Rod: MacMiniColo.net or MacStadium. We need to extend the versions we test on.
Might need board meeting approval.

## Cutting our own builds of Jenkins

Alexis: to fix low hanging fruit, improve our CI system. Instead of starting
from scratch with CI, try to start with what we have and fix what’s wrong.

Johan: suitable for CI WG. Hoping for upstream to get more responsive.  Might be
preferable to avoid the burden of maintaining. Let’s start by getting our feet wet.

Johan: some issues might be inherent to the platform (Java)

Alexis: let’s get our feet wet: build, install, fix a bug

## Setting up Jenkins secondary masters

Alexis: would be useful for testing updates to jenkins itself and plugins, and
for redundancy.  What is the blocker?

Rod: switching connection to use SSH is the blocker. Might be better for other
reasons anyway.

Alexis: On Windows it was not trivial.

Rod: we could run multiple slaves.jar on Windows

Multiple slaves.jar would complicate management, so we would want to do it only
the platforms where we cannot use SSH

Joahn: any prior best practices for master replication? Let’s do quick research

## Previous meeting review

Skipped

## Follow-ups

* [ ] ARM hardware test coverage: open an issue on the hardware WG repo and see
  if they can help
* [ ] Mac OS X resources: open an issue, listing platform needs and prioritize
  them. Experiment on colocation providers.
