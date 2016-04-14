# Node.js Foundation Build WG Meeting 2016-03-15

## Links

* **GitHub issue:** https://github.com/nodejs/build/issues/351
* **Meeting video:** http://www.youtube.com/watch?v=5cuOabjxEUY
* **Meeting minutes:** https://docs.google.com/document/d/1kwN7aNBrF257yxBaSYtQyerxXZnfmu7hOjdJiAFKqbo
* **Previous meeting:** https://docs.google.com/document/d/1srGblqnYaC5k-lHCSy08ar4aiq02lV2zWPA4vtzp5KQ

## Present

* Alexis Campailla (@orangemocha)
* Joao Reis (@joaocgreis)
* Johan Bergström (@jbergstroem)
* Michael Dawson (@mhdawson)
* Myles Borins (@TheAlphaNerd)
* Rich Trott (observing only) (@Trott)
* Rod Vagg (@rvagg)

## Standup

* Johan Bergström
  * splitting out release jenkins so we have more secure environment for
    releases
  * Work on configuration to allow per job access control. In place for libuv
    now.
  * Ccache on aix.
  * Backup jobs and servers.

* Alexis Campailla
  * Not much to report

* Joao Reis
  * VCBT issue, made away by itself.
  * Check in CI for git files not committed

* Rod Vagg
  * Working on splitting out release jenkins
  * per-job acl
  * some issues on os x slaves downloading stuff from the internet

* Michael Dawson
  * working on test job for v8 tests in node tree
  * working on x and ppc linuxes
  * issue on arm
  * Landed initial ansible configure for AIX machines, ccache for AIX, release
    machine for PPC, currently machine is behaving blocking investigation of
    compile issue.

* Myles Borins
  * More work on citgm, making it more robust. Should work on release down to
    0.10. Running into download issues on OSX. Tests that need to download fail
    due to that issue.

* Rich Trott (observing only)
  * Here for test group ratification.

## Minutes

### Ratify Testing WG Charter [nodejs/node#5461]

Discussion about the scope, longer term mandate for test working group. Key
part is that access to jenkins and machines is still through build working group
and will be worked out between the 2 teams.

No objections. No abstains. All in favor.

### Per-job acl at ci.nodejs.org

We need to define who has access to jenkins and how new jobs/tests can be
created. Libuv is an example where we can delegate running/modifying job.
Since split off of release jenkins, more relaxed about who has access.

Create a script that monitors changes to job configs?

Michael will write up strawman as to when we’d be comfortable giving access to
machines.

### Do we want a benchmark security group (share access to machines)?

Detaching group membership from team. Eg: @infra-testing, @infra-build
Should be a subset of benchmarking people who have access.

### ARM additions, do we want a Pi3 cluster? Also Pi1B+ donations needed.

Rod: Rpi primary ARM target for Node. Test coverage is important. Pi3 is a
completely different platform (ARM64)

We do need more help on figuring out which platforms should be supported.
Hardware WG has gone inactive. What platforms do we actively support? [alexis
to open an issue on github]

Rod: is going to do call for P1’s

### OSX donations & hosting, not expecting a resolution but let's talk options that are being worked on so far.

Voxer not to actively help us anymore. We need to find a transition. Which
releases of OSX do we support?

Johan talked a bit about efforts so far. MacStadium can provide 10.7 and up if
we co-locate or virtualize with them.

We should open an issue on repo. Looking to see if we can get contributors but
can fall back to foundation funding if necessary.

### Download page

Proceed with the latest iteration of the design.

## Previous meeting review

Skipped.

## Follow-ups
