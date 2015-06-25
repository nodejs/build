# io.js Build WG Meeting 2015-02-19

## Links

* **Public YouTube feed**: http://www.youtube.com/watch?v=OKQi3pTF7fs
* **Google Plus Event page**: https://plus.google.com/hangouts/_/hoaevent/AP36tYdM5W875vX5xRYouREWZkfLnVzw9nkYGmibICbeim4W7J3Mcw
* **GitHub Issue**: https://github.com/iojs/build/issues/43
* **Original Minutes Google Doc**: https://docs.google.com/document/d/1vRhsYBs4Hw6vRu55h5eWTwDzS1NctxdTvMMEnCbDs14

## Agenda
* Introductions
* Purpose of the WG/list of things to thank Rod for doing all alone
* Scope? (build vs performance wg?) // probably clarified above

## Minutes

### Present

* Forrest L Norvell @othiym23
* Johan Bergström @jbergstroem
* Ken Perkins @kenperkins
* Ryan Graham @rmg
* William Blankenship @wblankenship
* Rod Vagg @rvagg


### Governance stuff

https://github.com/iojs/io.js/blob/v1.x/WORKING_GROUPS.md

* Will agreed to take this item and submit a PR as a first pass at this

### Discuss the relationship between "Build" and "Docker"

* Discussed Docker and possible Performance sub-WG and how these relationships work
* Scope:
  - Test infra
  - Release infra and facilitation
  - Docker
  - Potentially _perf_ activity
  - Website infra (includes releases)

### Roadmap discussion

Rod proposed some roadmap items:

* Make more progress towards automatic testing of pull requests to iojs/io.js and libuv/libuv via the build-containers work (these are already running on jenkins).
* Automatic testing of merged commits via the full CI build set
* Reporting status to iojs/io.js and libuv/libuv. I have a nice custom badge for the READMEs in my head that would show status across the various platforms.
* Easier test triggers for io.js and libuv collaborators so they can request containerised or full CI runs on any fork & branch/commit without having to log in to Jenkins to do it.
* Longer-term plans to replace Jenkins with our own solution.

Ken added:

* HA for iojs.org and tarball downloads, load balancers, CDN, etc.
* All infra should be deterministic and describable in ansible or other tooling
 - provisioning included, don’t need to hardwire IP addresses - Ken interested in tackling this

Rod added:

* Provide pre-built binaries for npm installs of native addons

* Rod put up his hand to PR in a roadmap doc

### List of platforms

Rod’s original platform:
 * Discuss the current list of platforms and how we might want to extend it and a timeframe for extending it. I know that the libuv folk are interested in a broader set of test platforms than io.js but we're not doing much to oblige that yet.
 * We also need to discuss how we might expand the list of cloud/hosting companies providing hardware. We're leaning pretty heavily on DigitalOcean and Rackspace at the moment and I wouldn't mind diversifying a little and even bringing in providers of other platforms.

* Rod outlined the platforms we are currently supported
* Johan discussed build permutations
* Rod to PR to update the README with current platforms

### ARM

* Discuss bedded/single-board applications. I've been considering putting out a call for hardware donations so we can get better coverage of hardware how ARM fits into the picture. I'm quite interested in ramping up our ARM testing and nightly/release builds to make io.js perfect for IOT/emthat people are actually using.

* Rod to PR a call for comment and contributions

### Access

* Rod to create an issue to discuss access permissions

### npm

* Rod: there is an npm-specific job in Jenkins for Forrest to use, he just needs access and he can begin testing `make test-npm` to get it right across platforms.

### Jenkins

* Rod: have a big list of usernames & passwords to send out to new Jenkins users (io.js Collaborators mainly), just need to get documentation sorted out. See https://github.com/iojs/build/pull/48 for WIP.

### Next meeting

* Not next week, will figure it out on GitHub

