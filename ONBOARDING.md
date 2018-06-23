# Node.js build WG onboarding

This document is an outline of the things we tell new Build WG members at their
onboarding session.

### Before the onboarding session

* Email the new member and obtain their public GPG key
* Add them to the `test` group in `nodejs-private/secrets`
* Add them to the `nodejs/build` and `nodejs-private/build` GitHub teams
* Ask them to start looking over `services.md` and `jenkins-guide.md`,
  and to try and have any questions ready
* Ask the onboardee to install:
  * Ruby and the `dotgpg` gem
  * Python 2.7 and Ansible

### General information

* Responsibilities: The Build WG manages everything in
  [`doc/services.md`](doc/services.md)
* Members/"who does what"/interest areas
* Technologies and software in use

### CI/Jenkins

* Public CI (ci.nodejs.org)
  * `nodejs/jenkins-admins` are administrators
  * Tests Node.js itself, and several other Foundation projects
* Release CI (ci-release.nodejs.org)
  * `nodejs/jenkins-release-admins` are administrators
  * What creates and publishes all releases of Node.js
* General trend is try and use Jenkins pipelines as much as possible,
  store all bash scripts within `jenkins/scripts`. Make sure that any
  refactoring done to the jobs does not play with the job UI, such as
  making it more difficult to view job results.

### Secrets

* All production secrets are stored in the `build` directory of the
[`nodejs-private/secrets` repository][]
* The access groups are explained in [`doc/access.md`](doc/access.md)
* Say you want to decrypt the file `a.txt`, you'd run `dotgpg cat a.txt`
* Follow the instructions in [`doc/ssh.md`](doc/ssh.md) to setup the secrets
  repo and SSH access locally

### Ansible

* Ansible scripts are used to setup and maintain all machines
* See [`doc/services.md`](doc/services.md) for which playbooks
  correspond to different machines
* Go over [`ansible/README.md`](ansible/README.md) for Ansible setup
  instructions
* Have the onboardee practice running the `jenkins/worker/create.yml` playbook
  on one of the machines in the test CI cluster
* Windows access

### Communication

* GitHub Issues are used to manage tasks within the Build WG
* Try and use PRs to land changes: Keep open for at least 48 hours during the
  week (72 hours on the weekend), and get at least one approval from another WG
  member.
* Try and land PRs with the same commit metadata you'd use in
  `nodejs/node`
* IRC (specifically `#node-build` is important for communicating with
  other Node.js project members, and how we receive many initial signals
  of downtime
    * IRC logs are maintained at http://logs.libuv.org/node-build
* Build WG meetings are every 2-3 weeks, and you should try and attend
  as many as possible. The meetings are listed in the [Node.js
Foundation calendar][].

[`nodejs-private/secrets` repository]: https://github.com/nodejs-private/secrets
[Node.js Foundation calendar]: https://nodejs.org/calendar
