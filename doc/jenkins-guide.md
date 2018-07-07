# Jenkins Guide

A guide on maintaining Node.js' Test and Release Jenkins clusters

### Ansible

All machines in the clusters are managed using Ansible, with the
playbooks that live in `ansible/playbooks/jenkins`.

The playbooks provision a machine, and handle tasks such as installing
compilers, Java versions, and managing the local Jenkins agent.

To see which playbooks correspond to which worker, check the [services
document](doc/services.md).

##### Running playbooks

Before running playbooks, ensure that you have the host variables
properly setup for the machine.

If you wanted to run the playbook for one of the linter machines,
`test-rackspace-freebsd10-x64-1`, there should be a file named
`ansible/host_vars/test-rackspace-freebsd10-x64-1` that contains the machine's
Jenkins secret, and other configuration details.

It is generally best to get the configuration from the [secrets repo][], which
contains encrypted versions of the files. If there is no file in that
repository, you can always get the secret from the machine's Jenkins configuration
page.

Once you have the host variables set, you can now run the playbook for
the machine. Since `test-rackspace-freebsd10-x64-1` is being used for
this example, you would want to run the following command on your local
machine, from within the `ansible` directory:

```bash
ansible-playbook playbooks/jenkins/worker/create.yml --limit test-rackspace-freebsd10-x64-1
```

If all goes according to plan, then Ansible should be able to run the
playbook with no errors. If you do encounter problems, there are usually
some WG members available in the
[#node-build IRC channel](irc://irc.freenode.net/node-build), who can try and
lend a hand.

### Restricting access for security releases

When security releases are due to go out, the Build WG plays an
important role in facilitating their testing.

##### Before the release

About 24 hours before a release is published, the [public CI](ci.nodejs.org)
must be "locked down" to prevent anyone from interfering in the testing of the
release.

Create a tracking issue in the [`nodejs/build` issue tracker](https://github.com/nodejs/build/issues) announcing the lockdown.

Make a post in the `nodejs/collaborators` [discussion page](https://github.com/orgs/nodejs/teams/collaborators)
to let users of the public CI know that their access will be curtailed.
Be sure to insert a link to the `nodejs/build` tracking issue.

To change the Jenkins security configuration, you must be a member of
the `nodejs/jenkins-admins` team, and travel to the ["Configure Global
Security"](https://ci.nodejs.org/configureSecurity/) page.

Below is a screenshot of what the "Project-based Matrix Authorization Strategy"
table should look like before the release testing:

![](../static-assets/jenkins-authorization-normal.png)

Below is a screenshot of what the table should look like while release
testing is underway:

![](../static-assets/jenkins-authorization-sec.png)

##### After the release

After the release has gone out, restore the table to its original
condition. Add a comment to your post in `nodejs/collaborators` and the
tracking issue in `nodejs/build` to announce that access has been
restored.

### Solving problems

Issues with the Jenkins clusters are usually reported to either the
[#node-build IRC channel](irc://irc.freenode.net/node-build), or to the
[`nodejs/build` issue tracker](https://github.com/nodejs/build/issues).

When trying to fix a worker, ensure that you "mark the node as offline,"
via the Jenkins worker configure UI, so more failures don't pile up.
Once you are done fixing the worker, ensure that you return the worker
to the "online" status.

The most common issues facing workers are explained below, with potential
solutions on how to remedy the problem. Most commands below are meant to
be run on the worker itself, after SSH-ing in and switching to the
`iojs` user. See the [SSH guide](./ssh.md) on how to log into the machines.

##### Out of memory

First, get statistics on running processes for the machine: `ps aux | grep iojs | grep -v java | grep -v grep`.

If there are a lot of "hanging" / "abandoned" processes, it's best to
remove them by running a command like: `ps aux | grep iojs | grep -v java | grep -v grep | awk '{print $2}' | xargs kill`.

Overall memory utilization can be found using the `free` command on most
workers, or the `swap -s -h` command on SmartOS workers.

##### Out of space

First, get statistics on how full (or not) the machine is by running the
`df -h` command.

If the `Use%` column appears very high for the worker's largest disk,
then it is probably appropriate to clean out part of the worker's
workspace (where Jenkins jobs are performed). To clean out part of the
workspace, run `rm -rf ~/build/node-test-commit*`.

##### General issues with Jenkins agent: "normal machines" edition

Git errors or exceptions raised by the Jenkins agent can usually be
fixed by taking a look at the agent's logs, and then restarting it.

To view the agent's logs on most modern Linux machines, you can run
`journalctl -n 50 -u jenkins | less`.

To view the status of the agent, you can run one of the following
commands (based on the OS of the worker):

```bash
# Most modern Linux machines
systemctl status jenkins

# Older Linux machines
service jenkins status

# SmartOS
svcs -l svc:/application/jenkins:default

# macOS
sudo launchctl list | grep jenkins

# Other OSes
~iojs/start.sh
```

To restart the agent, you can run one of the following commands (based
on the OS of the worker):

```bash
# Most modern Linux machines
systemctl restart jenkins

# Older Linux machines
service jenkins restart

# SmartOS
svcadm restart svc:/application/jenkins:default

# macOS
launchctl stop org.nodejs.osx.jenkins
launchctl start org.nodejs.osx.jenkins

# Other OSes
~iojs/start.sh
```

##### Restart the machine

Sometimes something weird happens, and it's easier to just reboot the
worker.
On Unix just do one of:

```bash
shutdown -r now
# or:
reboot
```

##### Fixing machines with Docker

The above steps generally do not apply to workers that are either
"Half Docker" or "Full Docker".

To view a list of all active Docker containers, you can run `docker ps`.

Each Docker container has a matching `systemd` service that starts and
stops the container. There are several actions you can take once you
know the `systemd` service name, say `jenkins-test-digitalocean-ubuntu1804_container-x64-1.service`, for instance:

- To view a list of all active services, you can run
`systemctl list-units | grep jenkins`.
- To view the logs for a service, you can run `journalctl -n 50 -u systemctl restart jenkins-test-digitalocean-ubuntu1804_container-x64-1.service | less`
- To restart a Docker container, restart the associated `systemd` service, for
example:
`systemctl restart jenkins-test-digitalocean-ubuntu1804_container-x64-1.service `.

To SSH into a Docker container, first you need to find the container
ID by running `docker ps`. Once you have the ID, you can run `docker
exec -it CONTAINER_ID /bin/bash`, replacing `CONTAINER_ID` with the
appropriate ID.

##### IDK what to do

In case the above steps did not work, or you are unsure of what to try,
this section is for you.

The first thing to remember is that, ultimately, all workers can be
replaced with newly provisioned ones, so don't worry too much about
messing up a worker.

The safest bet when dealing with an erroring worker is to re-run its
associated Ansible playbook. This will try and restore the worker back
to its desired state, including refreshing and restarting the Jenkins
agent configuration.

If none of the above steps work, please post in the
[#node-build IRC channel](irc://irc.freenode.net/node-build), or the
[`nodejs/build` issue tracker](https://github.com/nodejs/build/issues), to allow
for escalation and other WG members to troubleshoot.

For problems with machines outside of the Jenkins test cluster, ask one
of the members of the [infra](https://github.com/nodejs/build#infra-admins) or
[release](https://github.com/nodejs/build#release-admins) administrators to
take a look.

[secrets repo]: https://github.com/nodejs-private/secrets
