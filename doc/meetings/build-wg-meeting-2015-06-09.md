# Node.js Build WG Meeting 2015-06-09

## Links

* **Public YouTube feed**: N/A
* **GitHub Issue**: N/A
* **Google Docs:** https://docs.google.com/document/d/1zuUujd6XEdOJnvT6E_TzveZ8LGanhHGaOds69IyaVIw

## Minutes

### Present

* Julien
* Rod
* Alexis
* Michael
* Johan Bergström (@jbergstroem)

### Standup

### Testing joyent\node with io.js CI

* Latest results:
  https://jenkins-iojs.nodesource.com/job/orangemocha-any+pr+multi/4/
* We can remove arm (though armv7 works, we might make it work), freebsd,
  raspberry pi. All others should work TODO: add v0.10 support

### Flaky Tests

* https://gist.github.com/jbergstroem/d16518d38ef6ddc0e697)
* Johan: Look at reaping lingering processes when a test run is finished (or
  before starting)
* Johan: Update the list and remove tests that we considered being fixed
  (windows timeouts, …)

### Testing Releases

* continue discussing -- explore options for verifying a release process
* Julien: documenting existing Jenkins setup and release process for
  joyent/node.
* Michael: working to build io.js next in IBM internal ci, 6 failures in crypto
  for ppc, once I resolve those will add machines to converged node ci and
  similar jobs to build io.js next.
* Alexis: to work on node-accept-pr
* Johan: will continue updating the README.md.

### make test-npm

* Forrest, Jeremiah, and Michael Dawson met this morning
* to keep things simple, the tests will run bin/npm-cli.js run-script
  test-legacy && bin/npm-cli.js run-script test
* it is the responsibility of those landing deps/npm to update the test-npm
  stanza when npm’s test infrastructure changes
* the npm CLI team will run test-npm on their side before pushing the PR, with
  somebody other than the person who assembled the patch pulling the branch for
  testing

### smoke-testing Docker containers for io.js

* Docker WG has been discussing this in nodejs/docker-iojs#46
* status? (for Rod)
* should something similar be done for Node.js?
* Julien: joyent/node does smoke tests after builds on supported platforms, but
  that’s only 4 so it doesn’t scale, how to automate?

### Rod to work on:

* secrets file to share with group
* table containing details of infrastructure in wiki (or repo if it’s too large)
* ssl & signing certs from foundation

### Release Procedures

* Jphan: want to test the release procedure without doing a release, there’s
  logic that only gets executed when there it’s tagged and ready to run
* Julien: joyent/node only tags after a release, io.js should do this too but it
  would mean needing to fix the jenkins workflow
* Julien: started documenting release process for joyent/node
  * https://github.com/joyent/node/wiki/CI-platform
  * https://github.com/joyent/node/wiki/CI-servers-administration-guide
  * https://github.com/joyent/node/wiki/Node.js-release-guide
* Julien: would like to enable more people doing releases, so needs more
  documentation and maybe tooling
* Rod: want to document the io.js release process from a systems view including
  tooling used
