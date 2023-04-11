# Node.js Foundation Build WG Meeting 2015-11-10

## Links

* **Meeting video:** http://www.youtube.com/watch?v=jOHgYCt0N1E
* **Meeting minutes:** https://docs.google.com/document/d/1zTS3dc--ziFdRJrqQqzH6el0pir0EgQBq2cCCUT7VxU
* **Previous meeting:** https://docs.google.com/document/d/1pYpM_9LkhrvyUTOQZei1jdS1Y55RW7Z_i5STCWxzQM4

## Present

* Alexis Campailla (@orangemocha)
* Hans Kristian Flaatten (@starefossen)
* Johan Bergström (@jbergstroem)
* João Reis (@joaocgreis)
* Michael Dawson (@mhdawson)
* Myles Borins (@TheAlphaNerd)
* Rod Vagg (@rvagg)
* Ryan Graham (@rmg)

## Standup

* Michael Dawson
  * ppc added to regression tests
  * away at conferences
  * focused on getting IBM 4.X release out
  * Some time keeping PPC machines live
  * Still working on trying to get AIX machines (item 237).

* Johan
  * Looking at backing up Jenkins CI hosts, done nightly.
  * Looking to find continued support for FreeBSD.
  * Posting build progress to GitHub (item 236).
  * Setting up new CI, found smaller things to clean up in ansible as well as
    larger refactor.
  * Added a new smartos 13.3.1 base that’s intended to be used for 0.10/0.12
    smartos binary releases

* Alexis
  * Working on native module service (item 151) researching and about to write
    up proposal.

* Hans Kristian
  * Working on mostly Docker WG stuff
  * Preparing for reporting Jenkins Slaves downtimes to IRC (pending the switch
    from Gitter to IRC for the Build WG)

* João Reis
  * Adding windows 10 servers to CI, and other variants.
  * Created fan jobs to address speed issues.
  * Create ansible scripts to setup windows machines.
  * Working on issue to check if job is flaky or not.
  * Looking at using ssh to connect to windows machines.

* Rod Vagg
  * Working on items mentioned by Johan, OSX machines can now ssh into them via
    proxy tunnel.
  * Private node fork, where security patches can be tested, repository is now a
    parameter for test jobs.
  * Working on 0.10.X and 0.12.x support.

* Myles Borins
  * Looking at ansible scripts
  * Working on CITGM (related https://github.com/nodejs/LTS/issues/48#issuecomment-152666451).

* Ryan Graham
  * Helped out with some of the connectivity issues.

## Minutes

### Option to run V8 test suite \[#199]

Running tests should be fairly easy, hardest part is to figure out how to
configure all the prerequisites. Michael to follow up and report on progress.
First deliverable: a quick and dirty job in Jenkins to run this daily. We can
improve the process as we go.

### PPC platforms as part of standard release \[#205]

### Jenkins downtime

Security vulnerability discovered in Jenkins. No evidence that our server was
compromised but we chose the safe route and assumed the worst, reprovisioned
everything.  ETA to be back online: Wednesday.

## Previous meeting review

## Follow-ups

* [ ] Can FreeBSD run on SoftLayer or Azure?
* [ ] Figure out support for OSX
* [ ] IRC vs. Slack vs. Gitter #247
* [ ] Connectivity to Jenkins Slaves
* [ ] We need to secure testing of private repo. Don’t push sources to binary repo.
* [ ] Build 0.10, 0.12 binaries.
* [ ] GitHub API status.. reporting flaky tests #236
