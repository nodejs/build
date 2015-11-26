# Node.js Foundation Build WG Meeting 2015-07-28

## Links

* **Meeting video:** http://www.youtube.com/watch?v=t3DGYdoNIIU
* **Meeting minutes:** https://docs.google.com/document/d/17mLp9yTS2JIpPxDWf6Ategmkgn6FhM59KGnWpeErprI
* **Previous meeting:** https://docs.google.com/document/d/1oiRIhDmEorqAEQdW1-im3BKRL1o7CBjYf3V1hW80yE8

## Present

* Alexis
* Hans Kristian
* Michael
* Rod

## Standup

* Rod
  * upgrade Jenkins for more storage space
* Hans Kristian
  * smoke testing drivers, using Docker because of external dependencies -
    redis, postgres, memcache, pull requests to each of these projects to allow
    the server to _not_ be running on localhost
* Michael
  * landed PPC changes on `next`
* Alexis
  * CI convergence close to complete
    * node-test-pull-request to replace iojs+any-pr+multi
    * node-accept-pull-request work in progress
    * https://github.com/nodejs/io.js/issues/2263

## Previous meeting review

## Minutes

### Merging collaborators

* Alexis to get a list of joyent/node collaborators who aren’t in the io.js README list so we can get some onboarding
* Rod to get Chris & Jeremiah to do a speedy onboarding for these folks, add Michael to the list

### Secrets

* Rod set up https://github.com/nodejs/secrets using https://github.com/ConradIrwin/dotgpg and is adding build team members to it, need keys for everyone, preferably verifiable by GitHub in some way (i.e. github handle -> GPG key)

### Smoke testing

* Hans Kristian: test coverage is spotty for io.js across some of these drivers, they don’t seem to be caring much. 0.10 is the baseline, some have moved to 0.12.

### Benchmarking machine

* Michael: benchmarking WG needs dedicated machine for consistent benchmarks.
* Rod: suggested Michael follow up with Dave Ings @ IBM to provision a SoftLayer (real) machine (or two) to handle this, loop in the build WG to help maintain it
* Michael to follow up

### CI robustness

* Alexis: we have a lot of machines that are not redundant in CI, mainly Linux, this will become a problem when we move collaborators across from joyent/node and start using Jenkins to land pull requests.
* Discussed redundancy and monitoring needs for CI, also expanding the list of people
* Alexis to look in to monitoring
  * Jenkins monitoring Plugin: https://github.com/jenkinsci/monitoring-plugin




