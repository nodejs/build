# node.js Build WG Meeting 2015-05-25

## Links

* **Public YouTube feed**: http://www.youtube.com/watch?v=8dxkM9vHmrY
* **Google Plus Event page**: https://plus.google.com/hangouts/_/g77deac75xhp62i62uzoa4oopea
* **GitHub Issue**: https://github.com/nodejs/build/issues/98
* **Original Minutes Google Doc**: https://docs.google.com/document/d/1rKyZ4gJKkK7IOL9qg3jvmW7ghA-4sot5d51oRhr_Q3E

## Agenda

* Make io.js CI infra work with joyent/node
  - Tests - Alexis
  - Releases - Julien + Rod
* Hardware
  - PowerPC (IBM)
  - Azure
* Jenkins + Windows uncertainty
  - Flakey tests?
* Secrets and asset management
* Group interaction going forward

## Present

* Alexis Campala
* Forrest Norvell
* Rod Vagg
* Johan Bergström
* Hans Kristian Flaatten
* Jeremiah Senkpiel
* Michael Dawson

## Make io.js CI infra work with joyent/node

* Alexis to make a test job work. Make a copy of iojs-any-pr-multi, to work with
  joyent\node
* Rod to work with Julien towards releases
* Rod: note ignore the build labels prefixed with “iojs-”, we’re migrating to
  plain names, like “ubuntu1404-64”

## Hardware

* Michael requested two machines from IBM - PowerPC le and be
* Build machines to be managed by the build team
* Ideally make setup ansible
* Johan to help out with Michael on Ansible setup
* `next` branch on io.js has V8 4.3
* Would be good to have these machines testing that create a list of hardware we
  would be interested in adding (additional architectures or improve
  parallelism) - Johan to work on updating README

## Jenkins + Windows uncertainty

* A few tests failing when Jenkins runs as a service . Sometimes it takes a few
  days before the issue surfaces. Can’t replicate outside of Jenkins .
  Environmental issue- Alexis to investigate
*  File an issue in the build repo to collect details of consistent failures
  - johan will collect all possibly “jenkins”-related failures
  - johan to collect data on -J / parallel test failures on the machines
* Flaky tests: bring node-accept-pull-request over to the io.js CI

## Secrets and asset management

* Rod to work on maintaining a secrets document / spreadsheet for io.js infra
* Rod to work on maintaining an assets list for build infra
* Rod to push forward with signing keys for Windows, Apple Mac Developer Program
  account
* Rod to push forward with ssl certs / wildcard or otherwise for nodejs.org
  iojs.org move jenkins to nodejs.org domain

## Group interaction going forward

* GitHub issues
* https://gitter.im/nodejs/build

## Next meeting

* In 8 days, one hour earlier

## Agenda items for next meeting

* node accept PR (Alexis to integrate with io.js Jenkins for joyent/node)
  - flakey tests
* npm integration - how it’s being tested on both sides and how to improve it
  (Forrest, Jeremiah)
* testing for website (Robert)
