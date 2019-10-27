# Access to Node.js Infrastructure

* [Build Working Group Membership](#build-working-group-membership)
* [Resource Access](#resource-access)
  * [Test servers](#test-servers)
  * [Infra servers](#infra-servers)
    * [IaaS services](#iaas-services)
    * [Other services](#other-services)
    * [Certificates](#certificates)
  * [Release servers](#release-servers)
    * [Certificates](#certificates-1)
  * [ci.nodejs.org](#cinodejsorg)
    * [Jenkins admins](#jenkins-admins)
  * [ci-release.nodejs.org](#ci-releasenodejsorg)
  * [[GitHub Bot][]](#github-bot)
* [NPM Management](#npm-management)

This document describes which groups have access to which assets managed by the
Build Working Group and how membership of those groups is managed.

_Note that links to `@nodejs/` teams in this document are not visible to people
who aren't in the Nodejs organization, and the [secrets repo][] is only visible
to people who have read access to the nodejs-private organization._

For technical details on getting SSH access to the machines, see the
[SSH guide][].

## Build Working Group Membership

The Build WG is comprised of individuals who are interested in managing servers
and the services that are managed on behalf of the Node.js project. Membership
is determined by the group itself, with existing, active, members voting on
proposals to add new members. You can see existing [Build WG members][] on the
README.

When considering new members, the Build WG is primarily concerned with
**competence** and **trust**. Membership grants access to a significant amount
of, resources. While we partition our resources into trust levels, the basic
level that all members have access to comprises the largest number of servers
maintained by the Build WG. Members should have a basic level of competence in
one or more technical areas covered by the Build WG such that the addition of
a new member spreads the maintenance burden rather than creating additional
burden because of lack of competence, or un-trustworthy behavior. The Build WG
is not an expert group and we offer a place to learn and develop skills. Members
should be aware of the bounds of their expertise and act accordingly.

* Competence: it is difficult to objectively gauge technical competence without
  demonstration. You can demonstrate competence by contributing to resources in
  this repository where you see need or attempting to assist Build WG members
  where you are able. Competence may also be demonstrated through contributions
  to other activities of the Node.js project, although competence in software
  development does not necessarily correlate with the type of technical
  competence the Build WG would prefer.
* Trust: because we are granting access to protected resources, the Build WG
  needs to establish trust. Individuals with no prior relationship to the
  Node.js project or one of its member companies are likely to be asked to
  contribute as a non-member where possible for a period of time to establish
  the basics of a trust relationship. The most two most straigtforward paths to
  trust are:
  1. An established relationship with the Node.js project and its associated
     working groups and activities. The longer the better.
  2. A contractual relationship (such as employment) with a member company of
     the OpenJS Foundation. Contractual relationships carry legal weight and
     provide greater likelihood of a stable trust relationship; at a minimum
     they establish strong legal accountability.

Please be aware of the fact that **the Build WG is usually invisible to the
Node.js project when things go well, but highly visible when things don't go
well**. Downtime of important resources can have a very wide impact, not just
for Node.js open source contributors but for very large sections of the Node.js
user ecosystem. Security breaches could have devastating consequences and these
all reflect on the Build WG.

If you are interested in helping out with the Build WG, please reach out to
existing members to let us know. The best means for communication with the Build
WG are either here via GitHub issues or through the `#node-build` channel on
Freenode [IRC][].

Membership is granted by way of a pull request adding a new individual to the
members list on the README (e.g. [#524][]). New members can open such a pull
request themselves, but it would be advisable to check with an existing member
before doing so. Alternatively, an existing member may "sponsor" a new member by
opening a pull request. Existing, active members will vote on a pull request and
where no objetions are present after a reasonable period of time, membership
will be granted.

Depending on the level of trust and competence assessed by existing Build WG
members, new members may not be given immediate access to protected resources.
This is at the discretion of the Build WG. We ask that you not take offence if
we appear slow to grant access to resources you ask for as we take our
responsibilities regarding security and the stability of our infrastrucutre very
seriously.

Onboarding of new members is provided once they join, see the
[the onboarding doc][] for more details.

## Resource Access

For a list of servers, see the Ansible [inventory.yml][]. Secrets are stored in
the [secrets repo][], which [@nodejs/build][] (and [org owners][]) have access
to. Secrets are encrypted and accessible only to a pre-defined set of personal
GPG keys, so access to the repo does not itself give access to any of the
secrets within. Individuals with different levels of access are able to use
their GPG keys to decrypt a broader range of secrets.

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

We expect that even if you are given access to Test servers, Build WG members
should:

1. Not operate too far beyond their competence level without assistance.
   Humility is the key. Hubris gets you, and us, in trouble.
2. Operate in a collaborative manner _as much as possible_. The more
   communication the better and team behavior is what we expect.
3. Be sensitive to the complex web of concerns that surround our infrastructure.
   This will take some getting used to, but know that there are often very good
   reasons that things may not be according to what you think is the optimal
   situation. For example: we are dealing with donated resources and we often
   have to perform careful balancing-acts to foster these relationships.

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

### [ci.nodejs.org](https://ci.nodejs.org)

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

#### Jenkins admins

[@nodejs/jenkins-admins][] have administrator access to ci.nodejs.org. They are
granted all permissions across Jenkins to modify resources. This group is
managed separately to test, release & infra and there are members of the Build
WG who have jenkins-admins access but not infra. We primarily grant access to
jenkins-admins on the basis of competence and according to our need to have
enough competent people available to maintain the resource as required.

### [ci-release.nodejs.org](https://ci-release.nodejs.org)

This is a private Jenkins instance. Only certain GitHub teams have access.

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

Those with `github-bot` access have access to the GitHub Bot's configuration,
including GitHub and Jenkins secrets. The list of members is
[here][GitHub Bot Admins].

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
[@nodejs/release]: https://github.com/orgs/nodejs/teams/release/members
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
