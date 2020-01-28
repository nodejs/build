# Access to Node.js Infrastructure

* [Resource Access](#resource-access)
  * [Ansible configuration](#ansible-configuration)
  * [Test servers](#test-servers)
  * [Infra servers](#infra-servers)
    * [IaaS services](#iaas-services)
    * [Other services](#other-services)
    * [Certificates](#certificates)
  * [Release servers](#release-servers)
    * [Certificates](#certificates-1)
  * [Nodejs.org](#nodejs.org)
  * [ci.nodejs.org](#cinodejsorg)
    * [Jenkins admins](#jenkins-admins)
  * [ci-release.nodejs.org](#ci-releasenodejsorg)
  * [GitHub Bot](#github-bot)
  * [email](#email)
* [NPM Management](#npm-management)

This document describes resources and assets are managed by the
Build Working Group.

_Note that links to `@nodejs/` teams in this document are not visible to people
who aren't in the Nodejs organization, and the [secrets repo][] is only visible
to people who have read access to the nodejs-private organization._

For technical details on getting SSH access to the machines, see the
[SSH guide][].

## Resource Access

For a list of servers, see the Ansible [inventory.yml][]. Secrets are stored in
the [secrets repo][], which [@nodejs/build][] (and [org owners][]) have access
to. Secrets are encrypted and accessible only to a pre-defined set of personal
GPG keys, so access to the repo does not itself give access to any of the
secrets within. Individuals with different levels of access are able to use
their GPG keys to decrypt a broader range of secrets.

### Ansible configuration

Ansible is the tool used to managed all machines that the Build WG is responsible for.

Secrets for Ansible scripts live within the `build` directory of the [`nodejs-private/secrets`](https://github.com/nodejs-private/secrets/tree/master/build) repository. Access to credentials is granted upon joining the build team.

### Test servers

The most basic level of access is also the most expansive. All Build WG have
(or should eventually have where a gradual onboarding process is in place) have
root access to the test CI servers that connect to our primary Jenkins server.
These Jenkins node servers are listed under the `test` block in the Ansible
inventory, and also listed at https://ci.nodejs.org/computer/.

The primary means of access to test servers is through the `nodejs_build_test`
SSH key which is made available in the secrets repository.

The Test servers serve our main Jenkins instance which serves contributors to
the Node.js project (and some related projects, including [libuv][]). Root
access is granted to allow for the greatest flexibility in solving problems
encountered with these servers. This is not a small amount of trust and
individuals should be conscious of the impact of their activities and **always
ask for assistance where there is uncertainty**.


### Infra servers

A small subset of Build WG members have access to infrastructure ("infra")
servers. These are listed under the `infra` section in the Ansible inventory.
The current list of Build WG members with infra access is listed in the
[README][Infra Admins].

We consider infra to be our "crown jewels". Members with infra access are able
to access all protected resources managed by the Build WG. We are therefore
very careful with this group and do not hand out membership liberally. Because
of the security and legal implications of mishandling of the resources managed
at the infra level, we keep the group relatively small and have a strong
preference for robust trust relationships and a high level of demonstrated
competence. For this reason we are more likely to add employees of OpenJS
Foundation member companies who already contribute to Node.js to the infra group
than individuals who don't have a strong contractual relationship with a company
who has a vested interest in Node.js.

The `nodejs_build_infra` SSH key grants access to infra servers.

In addition to infra servers, infra has access to:

#### IaaS services
- [DigitalOcean Droplets][] (individual accounts)
- [Joyent][]
- [MacStadium][]
- [Packet.net][] (individual accounts)
- [Rackspace][] (individual accounts)
- [Scaleway][]
- [SoftLayer][] (individual accounts)
- [linuxOne][]

#### Other services
- [Cloudflare][] (for CDN and nodejs.org and iojs.org DNS)
- [Mailgun email][] (uses Rackspace login)

#### Certificates
- [GoGetSSL for SSL][]
- [Letsencrypt][] (via the ability to authenticate ownership status through
  DNS record modification and other)

### Release servers

Servers listed in the Ansible inventory under the `release` section are a
separate category of access. We treat security of the build pipeline very
seriously and protect access to servers that build assets published on
nodejs.org. Most Build WG members don't have access to release servers. All
members with infra access do. Release access is managed separately to infra and
it is possible to add an individual to release but not infra. However, due to
the protected nature of these resources, they are most likely to be coupled.

The current list of Build WG members with infra access is listed in the
[README][Release Admins].

In addition to servers, release has access to:

#### Certificates
- [Apple][] (for pkg signing)
- [Digicert for Authenticode][] (for binary signing)

### nodejs.org

`nodejs.org` is the main website for the Node.js Foundation. Its Ansible configuration lives in [`setup/www`](https://github.com/nodejs/build/tree/master/setup/www)

### [ci.nodejs.org](https://ci.nodejs.org)

`ci.nodejs.org` is the main Jenkins setup used to test projects within
the Node.js Foundation, the largest being Node itself.

This is a publicly accessible resource, only a GitHub account is required to
gain read-access. [@nodejs/collaborators][] have access to run Node core tests.
Other teams have access to run tests related to their projects
(libuv, node-gyp, etc.).

Members of [@nodejs/build][] has more access than collaborators to configure
parts of ci.nodejs.org, including the ability to add, configure and remove
nodes.

Different forms of elevated access is granted to specific teams for specific
jobs. For example, the [post-mortem jobs][] are managed by
[@nodejs/post-mortem][], and configured by [@nodejs/post-mortem-admins][].
For more info see the [Jenkins access doc][].

There are several different types of machines that form the test CI
cluster:

| Type  | Jenkins Agent | Jenkins Workspace | Playbook | Notes |
|---|---|---|---|---|
| "Normal"  | On machine | On machine | [`jenkins/worker/create.yml`](https://github.com/nodejs/build/blob/master/ansible/playbooks/jenkins/worker/create.yml) | Run-of-the-mill, most common type of worker |
| "Half Docker"  | On machine | Docker container | [`jenkins/worker/create.yml`](https://github.com/nodejs/build/blob/master/ansible/playbooks/jenkins/worker/create.yml) |  Raspbery Pi, Scaleway ARM v7 |
| "Full Docker"  |  Docker container | Docker container  | [`jenkins/docker-host.yaml`](https://github.com/nodejs/build/blob/master/ansible/playbooks/jenkins/docker-host.yaml) | Special case Linux machines |

[`nodejs-ci-health`](https://nodejs-ci-health.mmarchini.me/),
[`node-build-monitor`](http://node-build-monitor.herokuapp.com/), and
[`node-builder`](http://node-builder.herokuapp.com/) can all be used to
monitor the health of `ci.nodejs.org`.

#### Jenkins admins

[@nodejs/jenkins-admins][] have administrator access to ci.nodejs.org. They are
granted all permissions across Jenkins to modify resources. This group is
managed separately to test, release & infra and there are members of the Build
WG who have jenkins-admins access but not infra. We primarily grant access to
jenkins-admins on the basis of competence and according to our need to have
enough competent people available to maintain the resource as required.

### [ci-release.nodejs.org](https://ci-release.nodejs.org)

This is a private Jenkins instance used to release Node.js. Only certain GitHub teams have access.

[@nodejs/releasers][] have access to run builds on a job named `iojs+release`.
This is our primary pipeline that creates all downloadable resource available
at nodejs.org/download. Members of the Releasers team are approved by the TSC
and also have access to the `dist` user on nodejs.org to "promote" releases once
built.

[@nodejs/jenkins-release-admins][] have full administrator access to this
Jenkins instance. It is treated similarly to jenkins-admins but with an elevated
level of trust and security since it has impacts on our build pipeline and also
grants indirect access to our release servers. There are individuals who have
jenkins-release-admins membership who do not have infra or release membership.

### [GitHub Bot][]

The `github-bot` is the server that runs different [automation scripts](https://github.com/nodejs/github-bot/tree/master/scripts) within the Node.js Foundation GitHub organization. For example, the bot automatically applies labels to new pull requests in `nodejs/node`, and can trigger Jenkins builds or report their statuses on pull requests. Its Ansible configuration lives in [`playbooks/create-github-bot.yml`](https://github.com/nodejs/build/tree/master/ansible/playbooks/create-github-bot.yml)

Those with `github-bot` access have access to the GitHub Bot's configuration,
including GitHub and Jenkins secrets. The list of members is
[here][GitHub Bot Admins].

### `email`

The [`nodejs/email`](https://github.com/nodejs/email) repo contains all
email aliases for the Node.js Foundation, which are routed via Mailgun.

## NPM Management

We have a number of packages managed by the Node.js project including:

* [citgm](https://github.com/nodejs/citgm)
* [llnode](https://github.com/nodejs/llnode)
* [node-gyp](https://github.com/nodejs/node-gyp)
* [node-inspect](https://github.com/nodejs/node-inspect)
* [node-report](https://github.com/nodejs/node-report)
* [nodejs-dist-indexer](https://github.com/nodejs/nodejs-dist-indexer)
  (for use on nodejs.org)
* [nodejs-latest-linker](https://github.com/nodejs/nodejs-latest-linker)
  (for use on nodejs.org)
* [changelog-maker](https://github.com/nodejs/changelog-maker)
* [branch-diff](https://github.com/nodejs/branch-diff)

Packages are managed as follows:

* The [`nodejs-foundation`][] npm user, which is managed by the Build
  WG, is an administrator on all Foundation npm packages. It is the
  means to add or remove other package collaborators, and shouldn't be used
  to publish releases.
* Package maintainers are added as npm "collaborators" to the package,
  and publish releases.

The credentials required for the `nodejs-foundation` user are maintained in
encrypted form in the [secrets repo][].

[@nodejs/build]: https://github.com/orgs/nodejs/teams/build/members
[@nodejs/collaborators]: https://github.com/orgs/nodejs/teams/collaborators/members
[@nodejs/jenkins-admins]: https://github.com/orgs/nodejs/teams/jenkins-admins/members
[@nodejs/jenkins-release-admins]: https://github.com/orgs/nodejs/teams/jenkins-release-admins/members
[@nodejs/post-mortem-admins]: https://github.com/orgs/nodejs/teams/post-mortem-admins/members
[@nodejs/post-mortem]: https://github.com/orgs/nodejs/teams/post-mortem/members
[@nodejs/releasers]: https://github.com/orgs/nodejs/teams/releasers/members
[SSH guide]: ./ssh.md
[libuv]: https://github.com/libuv/libuv/
[Build WG members]: /README.md#build-wg-members
[GitHub Bot Admins]: /README.md#github-bot-admins
[Infra Admins]: /README.md#infra-admins
[Jenkins access doc]: /doc/process/jenkins_job_configuration_access.md
[Release Admins]: /README.md#release-admins
[GitHub Bot]: https://github.com/nodejs/github-bot
[inventory.yml]: /ansible/inventory.yml
[org owners]: https://github.com/orgs/nodejs/people?utf8=%E2%9C%93&query=%20role%3Aowner
[post-mortem jobs]: https://ci.nodejs.org/view/post-mortem/
[secrets repo]: https://github.com/nodejs/secrets
[DigitalOcean Droplets]: https://cloud.digitalocean.com/droplets
[Packet.net]: https://app.packet.net/portal
[Joyent]: https://www.joyent.com/
[MacStadium]: https://www.macstadium.com/
[Rackspace]: https://www.rackspace.com/
[Scaleway]: https://www.scaleway.com/
[SoftLayer]: https://control.softlayer.com/
[linuxOne]: https://www.ibm.com/linuxone
[Apple]: https://developer.apple.com/support/certificates/
[Digicert for Authenticode]: https://www.digicert.com/code-signing/microsoft-authenticode.htm
[GoGetSSL for SSL]: https://www.gogetssl.com/
[Letsencrypt]: https://www.gogetssl.com/
[Cloudflare]: https://www.cloudflare.com/
[Mailgun email]: https://www.mailgun.com/
[#524]: https://github.com/nodejs/build/pull/524
[IRC]: /README.md#nodejs-build-working-group
[the Readme]: /README.md
[the onboarding doc]: /ONBOARDING.md
[`nodejs-foundation`]: https://www.npmjs.com/~nodejs-foundation
