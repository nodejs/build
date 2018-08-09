# Access to Node.js Infrastructure

This document describes which groups have access to which Infra assets.

Note that links to `@nodejs/` teams are not visible to people who
aren't in the Nodejs organization, and the [secrets repo][] is only
visible to people who have read access to the nodejs-private organization.

For technical howtos on getting SSH access to the machines, see the
[SSH guide](./ssh.md).

## Joining the Build Working Group

Anyone interested in helping out with the Build WG can reach out to existing
members to let us know, for example via a GitHub Issue on this repo or through
[IRC][].

Membership of the Build WG involves granting infrastructure access, so full
membership of the WG can be a gradual process. However we welcome anyone willing
to contribute, and we're always working to make contributions easier.

Once you're an established contributor, an existing Build WG member will invite
you to join the WG. A PR adding your name can be raised by either you or them
(e.g. [#524][]) and once that gains consensus and is landed you will be
onboarded (see [the onboarding doc][] for more details).

## Machine Access

For a list of machines, see the [inventory.yml][]. Secrets are stored in the
[secrets repo][], which [@nodejs/build][] (and [org owners][]) have access to.
Secrets are individually encrypted, so access to the repo does not itself
give access to any of the secrets within. For more info see the repo's README.

### Test machines

[@nodejs/build][] have root access to the test CI machines (`test-*`). The list
of members is [here][Build WG Members].

### Infra machines

A subsection of build members have access to infra machines
(`infra-*`). The list of members is [here][Infra Admins].

The infra group also have access to:

#### Servers:
- [DigitalOcean Droplets][] (individual accounts)
- [Joyent][]
- [MacStadium][]
- [Packet.net][] (individual accounts)
- [Rackspace][] (individual accounts)
- [Scaleway][]
- [SoftLayer][] (individual accounts)
- [linuxOne][]

#### Certificates
- [Apple][]
- [Digicert for Authenticode][]
- [GoGetSSL for SSL][]

#### Other
- [Cloudflare][]
- [Mailgun email][] (uses Rackspace login)

### Release machines

A subsection of build members have access to release machines
(`release-*`). The list of members is [here][Release Admins].

## Infra Access

There are a number of other infra assets maintained by the Build WG, accesses
are as follows.

Note that the machines that our Jenkins instances run on are `infra` machines,
and thus any task that requires access to the machine requires `infra` access.

### [ci.nodejs.org](ci.nodejs.org)

- [@nodejs/collaborators][] have access to run Node core tests.

- Run and configure access for other jobs is controlled by the teams who own them
(for example, the [post-mortem jobs][] are run by [@nodejs/post-mortem][], and
configured by [@nodejs/post-mortem-admins][]. For more info see the [Jenkins
access doc][].

- [@nodejs/build][] have machine access (the ability to add, remove, and
configure machines).

- [@nodejs/jenkins-admins][] have admin access.

### [ci-release.nodejs.org](ci-release.nodejs.org)

- [@nodejs/release][] have access to run builds.

- [@nodejs/jenkins-release-admins][] have admin access.

### [GitHub Bot][]

Those with `github-bot` access have access to the GitHub Bot's configuration,
including GitHub and Jenkins secrets. The list of members is
[here][GitHub Bot Admins].

## NPM Management

We have a number of modules under the Node.js Foundation including:

* [citgm](https://github.com/nodejs/citgm)
* [llnode](https://github.com/nodejs/llnode)
* [node-gyp](https://github.com/nodejs/node-gyp)
* [node-inspect](https://github.com/nodejs/node-inspect)
* [node-report](https://github.com/nodejs/node-report)

Modules are managed as follows:

* The [`nodejs-foundation`][] npm user, which is managed by the Build
  WG, is an administrator on all Foundation npm packages. It is the
means to add or remove other module collaborators, and shouldn't be used
to publish releases.
* Package mantainers are added as npm "collaborators" to the package,
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
[Build WG Members]: /README.md#build-wg-members
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
[Cloudflare]: https://www.cloudflare.com/
[Mailgun email]: https://www.mailgun.com/
[#524]: https://github.com/nodejs/build/pull/524
[IRC]: /README.md#nodejs-build-working-group
[the Readme]: /README.md
[the onboarding doc]: ./onboarding.md
[`nodejs-foundation`]: https://www.npmjs.com/~nodejs-foundation
