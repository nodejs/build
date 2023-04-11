# Node.js Foundation Build WG Meeting 2015-09-29

## Links

* **Meeting video:** http://www.youtube.com/watch?v=lgDa-r9F37s
* **Meeting minutes:** https://docs.google.com/document/d/1pYpM_9LkhrvyUTOQZei1jdS1Y55RW7Z_i5STCWxzQM4
* **Previous meetings:** https://docs.google.com/document/d/1GYPt7igqna-lL1_LWs4xHCp0Gik-p-z2nOyaPdu-rtA

## Present

* Michael Dawson (@mhdawson)
* Johan Bergström (@jbergstroem)
* Alexis Campailla (@orangemocha)

## Standup

* Michael Dawson
  * Getting softlayer resources from the Build WG
  * Working on AIX build
  * Added to ansible inventory for the power big endian machine
* Johan Bergström
  * Reworking how we download ICU in CI. Replaced pythong with wget/curl to do
    resumable downloads. Working on freebsd slaves. Dealing with limitations
    for jenkins slaves running in jails
* Alexis Campailla
  * Working on reintroducing the merge-pr jobs
  * Ansible support for Windows slaves
  * Added windows 10 machines in CI

## Previous meeting review

*

## Minutes

### CI reliability

We need to improve redundancy for some of our jenkins slaves. Use
`ansible-inventory` as a starting point. A secondary goal would be to distribute
the redundancy between different hosts, eg. Azure and Rackspace. There’s also
available resources at Softlayer we could use for the same purpose.

Johan will open an issue for this so we can start tracking what needs to be
done.

### Benchmarking machines (https://github.com/nodejs/benchmarking/issues/18)

Getting the machines set up. Need to work on the benchmarking.

### Release unification (https://github.com/nodejs/build/issues/164)

We need Rod to drive this. The information for how to do v0.x releases is
available, we need someone familiar with the new release system to drive the
process. Old Jenkins is still available.

## Follow-ups

* [ ] Add Windows machines to Azure subscription, freeing some resources from
  RackSpace \[Alexis]
* [ ] Extract or build an inventory of slaves per label (ansible inventory?
  Jenkins UI)?
* [ ] Make CI slaves redundant / ensure at least 2 slaves of each type
* [ ] Give more people access to machines at Voxer for improved redundancy

### Release

* [ ] Remove dangling processes, reset to a “normal state” -- suggestively
  invoking `make clean` on successful build/test runs. \[Alexis, Johan]
* [ ] Look for possible tests that uses common.PORT in parallel. \[Johan]
* [ ] Open an issue about improving redundancy for slaves \[Johan]
* [ ] Open an issue for introducing release builds for ppc \[Michael]
