# Node.js Foundation Build WG Meeting 2015-08-18

## Links

* **Meeting video:** http://www.youtube.com/watch?v=4_oM-B6YTII
* **Meeting minutes:** https://docs.google.com/document/d/1Kz0f0tFnt-0ahba_u-mr1w_5-8-DMzNjyiAN7a1eG3s
* **Previous meetings:** https://docs.google.com/document/d/17mLp9yTS2JIpPxDWf6Ategmkgn6FhM59KGnWpeErprI

## Present

* Alexis Campailla @orangemocha
* Hans Kristian Flaatten @starefossen
* Michael Dawson @mhdawson
* Rod Vagg @rvagg
* Ryan Graham @rmg

## Standup

* Michael
  * worked on PR for changes to allow compilation on AIX, submitted need to
    address comments. Allows Node to compile cleanly on AIX but requires
    additional changes to npm and libuv to pass all tests.
* Ryan
  * just getting up to speed
* Alexis
  * adding flaky tests to nodejs/node
  * support for splitting test runs so we can split up the builds
* Hans Kristian
  * worked on getting monitoring of Jenkins nodes in place -
    [jenkins-monitor](https://github.com/Starefossen/jenkins-monitor)
* Rod
  * pushing on resources from the foundation (certs etc.)
  * [node-memtest](https://github.com/rvagg/node-memtest)

## Previous meeting review

* Merging collaborators
* Secrets
   * set up but not heavily used yet
* Smoke testing
  * [citgm](https://github.com/nodejs/citgm) making good progress, we need to
    set it up on Jenkins and ideally have a default set of modules to test that
    anyone can PR to add new modules
* Benchmarking machine
  * still pushing on this to find the right person to make it happen
* CI robustness
  * Hans Kristian has been making progress on this in
    [jenkins-monitor](https://github.com/Starefossen/jenkins-monitor)

## Minutes

* nothing new to discuss
