Node Test and Build Infrastructure
==================================
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/iojs/build?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Wut?
----

This repository contains information used to set up and maintain the **io.js** and **libuv** CI infrastructure. It is intended to be open and transparent, if you see any relevant information missing please open an issue.

io.js and libuv are tested on a specific set of hardware / operating system / configuration combinations. Commits to the repository are tested on the full set while pull requests to the Node.js and libuv projects from non-core contributors are tested on a smaller, more secure subset. Build and test output is collected and success or fail status is reported back to GitHub.

Test Configurations
-------------------

The set of build configurations is divided into three main categories:

* **All code**: configurations where code compilation and test execution can be performed in an isolated and transient containerized environment. These configurations will allow the testing of untrusted code submitted by untrusted individuals to the main repositories via pull requests.

* **Core platforms**: configurations deemed to be primary build targets of the io.js and libuv projects. Failures on these configurations will cause a failure report to GitHub on pull requests and commits. Core contributors should aim for all commits to be able to pass on these configurations. Additionally, these platforms will initially split up into two sub-categories:

  - **Core & easy**: configurations that are simple to set up and maintain.
  - **Core & difficult**: configurations that require a level of yak shaving to set up and maintain, such as very old versions of Linux (e.g. EL5) and very new tooling (e.g. XCode 6). This set of configurations may not be initially (and fully) available to the project as they may take time to set up in a reliable enough way.

* **Non-core platforms**: configurations that are secondary build targets of the io.js and libuv projects. These platforms are of interest to the community and core contributors will be given insight to the success of their commits on these platforms but failure will be reported as advisory-only. However, it is expected that project releases will pass on all of these platforms.


### Configurations: All code

All commits and pull requests will be submitted for compilation and execution of the **test-simple** test suite on the following platforms:

  * Containerized 64bit image of the current oldest Ubuntu LTS Release (10.04, Lucid Lynx)
  * Containerized 64bit image of the current latest Ubuntu LTS Release (14.04, Trusty Tahr)

### Configurations: Core & easy

Additionally, all commits by core contributors will be submitted for compilation and execution of the **test-all** test suite on the following platforms:

  * CentOS 6 64-bit (EL6)
  * CentOS 6 32-bit (EL6)
  * CentOS 7 64-bit (EL7)
  * Ubuntu 10.04 LTS (Lucid Lynx) 64-bit
  * Ubuntu 10.04 LTS (Lucid Lynx) 32-bit
  * Ubuntu 12.04 LTS (Precise Pangolin) 64-bit
  * Ubuntu 12.04 LTS (Precise Pangolin) 32-bit
  * Ubuntu 14.04 LTS (Trusty Tahr) 64-bit
  * Ubuntu 14.04 LTS (Trusty Tahr) 32-bit
  * Debian stable (wheezy) 64-bit
  * Debian stable (wheezy) 32-bit
  * Windows Server 2008 R2 + Visual C++ 2012 64-bit
  * Windows Server 2008 R2 + Visual C++ 2012 32-bit
  * Windows Server 2012 R2 + Visual C++ 2013 64-bit
  * Windows Server 2012 R2 + Visual C++ 2013 32-bit
  * Mac OS X 10.8 (Mountain Lion) + XCode 5
  * Mac OS X 10.9 (Mavericks) + XCode 5

### Configurations: Core & difficult

The following platforms will eventually be included in the "Core" set when properly stabilized as build platforms (i.e. the yaks are bald):

  * CentOS 5 64-bit (EL5)
  * CentOS 5 32-bit (EL5)
  * SmartOS
  * ARMv6 32-bit (Linux)
  * ARMv7 32-bit (Linux)
  * ARMv8 32-bit (Linux, one day, when suitable hardware & OS is available)
  * ARMv8 64-bit (Linux, one day, when suitable hardware & OS is available)
  * Ubuntu 14.10 (Utopic Unicorn) 64-bit (preferably prior to official release)
  * Mac OS X 10.10 (Yosemite) + XCode 6

### Configurations: Non-core

The following platforms will eventually be included in the build and **test-all** set for core-contributors but failure will be advisory-only as they do not constitute core release targets.

  * FreeBSD stable/9 *(maybe)*
  * FreeBSD stable/10
  * MinGW 32-bit
  * MinGW 64-bit
  * POWER8 (pending V8 changes and acceptance by the core team)


CI Software
-----------

Build and test orchestration is performed by [Jenkins](http://jenkins-ci.org). You can find a summary of build status [here](https://jenkins-iojs.nodesource.com).

Our ambition is to invest in io.js-specific CI infrastructure and tooling while leaning on existing, proven technologies where appropriate. We hope to slowly replace Jenkins as orchestrator and build-slaves throughout our CI ecosystem.


Hardware Sponsors
-----------------

The following companies are contributing hardware to this project:

* [DigitalOcean](http://digitalocean.com/) (via Mikeal Rogers)
* [Rackspace](http://rackspace.com/) (via Paul Querna)
* [IBM](http://www.ibm.com/) / [Softlayer](http://www.softlayer.com/) (via Dave Ings and Andrew Low)
* [WalmartLabs](http://www.walmartlabs.com/) (via Wyatt Preul)


People
------

**Rod Vagg** of [NodeSource](https://nodesource.com) will be initial project lead

Additional assistance to be provided by the Node.js and libuv core team members and other interested and experienced parties:

* TJ Fontaine [@tjfontaine](https://github.com/tjfontaine) (Joyent)
* Saúl Ibarra Corretgé [@saghul](https://github.com/saghul)
* Trevor Norris (NodeSource) [@trevnorris](https://github.com/trevnorris)
* Fedor Indutny (Voxer) [@indutny](https://github.com/indutny)
* Ben Noordhuis (StrongLoop) [@bnoordhuis](https://github.com/bnoordhuis)
* Maciej Małecki [@mmalecki](https://github.com/mmalecki)
* Chris Lea (NodeSource) [@chrislea](https://github.com/chrislea)
* Ryan Graham (StrongLoop) [@rmg](https://github.com/rmg)
* Andrew Low (IBM) [@andrewlow](https://github.com/andrewlow)
* Mark Wolfe (Ninjablocks) [@wolfeidau](https://github.com/wolfeidau)
* William Blankenship (NodeSource) [@wblanenship](https://github.com/wblankenship)
