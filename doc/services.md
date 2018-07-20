# Build WG Services

This document is intended to outline all services managed by the Build WG,
and how to configure and operate them.

### Ansible configuration

Ansible is the tool used to managed all machines that the Build WG is responsible for.

Secrets for Ansible scripts live within the `build` directory of the [`nodejs-private/secrets`](https://github.com/nodejs-private/secrets/tree/master/build) repository. Access to credentials is granted upon joining the build team.

### `ci.nodejs.org`

`ci.nodejs.org` is the main Jenkins setup used to test projects within
the Node.js Foundation, the largest being Node itself.

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

### `ci-release.nodejs.org`

`ci-release.nodejs.org` is the Jenkins server used to release Node.js.

### `github-bot`

The `github-bot` is the server that runs different [automation scripts](https://github.com/nodejs/github-bot/tree/master/scripts) within the Node.js Foundation GitHub organization. For example, the bot automatically applies labels to new pull requests in `nodejs/node`, and can trigger Jenkins builds or report their statuses on pull requests. Its Ansible configuration lives in [`playbooks/create-github-bot.yml`](https://github.com/nodejs/build/tree/master/ansible/playbooks/create-github-bot.yml)

### `nodejs.org`

`nodejs.org` is the main website for the Node.js Foundation. Its Ansible configuration lives in [`setup/www`](https://github.com/nodejs/build/tree/master/setup/www)

### `email`

The [`nodejs/email`](https://github.com/nodejs/email) repo contains all
email aliases for the Node.js Foundation, which are routed via Mailgun.
