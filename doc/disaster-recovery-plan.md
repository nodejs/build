# Disaster Recovery Plan

Notes and (hopefully) enough pointers to be able to recover critical bits of
build infrastructure.

## Table of Contents

* [Jenkins Servers](#jenkins-servers)
  * [Recovering Jenkins configuration](#recovering-jenkins-configuration)
  * [Recovering iptables configuration](#recovering-iptables-configuration)

## Jenkins Servers

We have two Jenkins servers running the Stable (LTS) release of Jenkins:
* ci.nodejs.org - The public testing CI. Accessible to anyone with a GitHub
  login.
* ci-release.nodejs.org - Restricted release CI, used to build binaries for
  redistribution on nodejs.org. Access is restricted to releasers.

Each server:
* Is fronted by nginx.
* Controls connections from Jenkins agents via iptables rules.
* Is connected to our grafana server via a telegraf agent.
* Run a script to sync the Jenkins job configurations to GitHub via `crontab`
(see [Recovering Jenkins configuration] below).

If setting up replacement servers:
* `/var/lib/jenkins` should reside on a disk with 300GB capacity.
* The IP address will need to be updated in the DNS settings at CloudFlare.
* The Ansible inventory and [Jenkins host playbooks] updated.

For reference, at the time of writing the hosts are configured:
host | vCPUs | Memory
:---|:---:|---:
ci.nodejs.org | 12 | 32 GB
ci-release.nodejs.org | 4 | 8 GB

### Recovering Jenkins configuration

For each Jenkins server periodic snapshots of `/var/lib/jenkins` are
taken by the [backup server]. The snapshots retain the directory layout
and can be copied over a clean installation of the same version of Jenkins.

In addition to the backups on the backup server, the job configuration for
each Jenkins server is synced to GitHub (currently private) repositories
cloned at `/home/jenkins/config-backup`. The backup script from the GitHub
repository is run every five minutes via `crontab`. Only the `config.xml`
file, renamed to `jobs/<jobname>.xml`, from each job is saved.
* https://github.com/nodejs/jenkins-config-release
* https://github.com/nodejs/jenkins-config-test

### Recovering iptables configuration

For each Jenkins server periodic backups of the results of `iptables-save`
are taken by the [backup server].

The [iptables ansible playbook] can also be used to add every known host
in the ansible inventory beginning with `release-` or `test-` prefixes to
the iptables rules for the respective CI server.

[backup server]: https://github.com/nodejs/build/tree/main/backup
[iptables ansible playbook]: https://github.com/nodejs/build/blob/main/ansible/playbooks/jenkins/host/iptables.yml
[Jenkins host playbooks]: https://github.com/nodejs/build/tree/main/ansible/playbooks/jenkins/host
[Recovering iptables configuration]: #recovering-iptables-configuration
[Recovering Jenkins configuration]: #recovering-jenkins-configuration
 