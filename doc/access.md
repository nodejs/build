# Access to Node.js Infrastructure

Documents which groups have access to which Infra assets. Note that links to
`@nodejs/` teams are not visible to people who aren't in the Nodejs
organisation, so those links may not work for you. The [secrets repo][] is also
secret...

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

- [@nodejs/jenkins-admins][] have admin access.

### [GitHub Bot][]

Those with `github-bot` access have access to the GitHub Bot's configuration,
including GitHub and Jenkins secrets. The list of members is
[here][GitHub Bot Admins].


[@nodejs/build]: https://github.com/orgs/nodejs/teams/build/members
[@nodejs/collaborators]: https://github.com/orgs/nodejs/teams/collaborators/members
[@nodejs/jenkins-admins]: https://github.com/orgs/nodejs/teams/jenkins-admins/members
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
