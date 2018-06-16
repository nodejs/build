# Jenkins Guide

A guide on maintaining Node.js' Test and Release Jenkins clusters

## TOC

* [Ansible](#ansible)
  * [Running playbooks](#running-playbooks)
* [Security releases](#security-releases)
  * [Before the release](#before-the-release)
  * [After the release](#after-the-release)
* [Solving problems](#solving-problems)
  * [Out of memory](#out-of-memory)
  * [Out of space](#out-of-space)
  * [General issues with Jenkins agent: "normal machines" edition](#general-issues-with-jenkins-agent-normal-machines-edition)
  * [Restart the machine](#restart-the-machine)
  * [Containerized machines](#containerized-machines)
  * [IDK what to do](#idk-what-to-do)


## Ansible

All machines in the clusters are managed using Ansible, with the
playbooks that live in `ansible/playbooks/jenkins`.

The playbooks provision a machine, and handle tasks such as installing
compilers, Java versions, and managing the local Jenkins agent.

To see which playbooks correspond to which worker, check the [services
document](./services.md).

### Running playbooks

Before running playbooks, ensure that you have the [secrets repo][] properly
cloned and found by Ansible, [as described in the README](../ansible/README.md).
If the machine secret is not available, you can always get it from the
machine's Jenkins configuration page.

You can now run the playbook for the machine. Since
`test-rackspace-freebsd10-x64-1` is being used for this example, you would want
to run the following command on your local machine, from within the `ansible`
directory:

```bash
ansible-playbook playbooks/jenkins/worker/create.yml --limit test-rackspace-freebsd10-x64-1
```

If all goes according to plan, then Ansible should be able to run the
playbook with no errors. If you do encounter problems, there are usually
some WG members available in the
[#node-build IRC channel](irc://irc.freenode.net/node-build), who can try and
lend a hand.

## Security releases

When security releases are due to go out, the Build WG plays an
important role in facilitating their testing.

### Before the release

About 24 hours before a release is published, the [public CI](https://ci.nodejs.org)
must be "locked down" to prevent anyone from interfering in the testing of the
release.

Create a tracking issue in the [`nodejs/build` issue tracker](https://github.com/nodejs/build/issues) announcing the lockdown.

Make a post in the `nodejs/collaborators` [discussion page](https://github.com/orgs/nodejs/teams/collaborators)
to let users of the public CI know that their access will be curtailed.
Be sure to insert a link to the `nodejs/build` tracking issue.

Add a Jenkins "system message" in https://ci.nodejs.org/configure. Something like:
```html
<h1 style="color:red">system is under embargo for a security release</h1>
<h2>For solidarity, even if you have access, please don't start unrelated jobs</h2>
```
And some fancy "extra-css" to the Theme at https://ci.nodejs.org/configure#section122:
```css
#header, .task-icon-link[href="/"] {
  background-color: red;
}
a#jenkins-home-link:after {
  content: "Under security embargo!";
  font-size: larger;
  color: yellow;
  margin-left: 250px;
}
```


To change the Jenkins security configuration, you must be a member of
the `nodejs/jenkins-admins` team, and travel to the ["Configure Global
Security"](https://ci.nodejs.org/configureSecurity/) page.

Below is a screenshot of what the "Project-based Matrix Authorization Strategy"
table should look like before the release testing:

![](../static-assets/jenkins-authorization-normal.png)

Below is a screenshot of what the table should look like while release
testing is underway:

![](../static-assets/jenkins-authorization-sec.png)

### After the release

After the release has gone out, restore the table to its original
condition. Add a comment to your post in `nodejs/collaborators` and the
tracking issue in `nodejs/build` to announce that access has been
restored.

For easy reverting of config changes, you can use the history audit log:
1. system (includes security matrix) - https://ci.nodejs.org/jobConfigHistory/history?name=config
2. CSS - https://ci.nodejs.org/jobConfigHistory/history?name=org.codefirst.SimpleThemeDecorator

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

### Out of memory

First, get statistics on running processes for the machine: `ps aux | grep node`.

If there are a lot of "hanging" / "abandoned" processes, it's best to
remove them by running a command like: `ps -ef | grep node | grep -v -egrep -ejava -edocker | awk '{print $2}' | xargs kill`.

Overall memory utilization can be found using the `free` command on most
workers, or the `swap -s -h` command on SmartOS workers.

### Out of space

First, get statistics on how full (or not) the machine is by running the
`df -h` command.

If the `Use%` column appears very high for the worker's largest disk,
then it is probably appropriate to clean out part of the worker's
workspace (where Jenkins jobs are performed). To clean out part of the
workspace, run `rm -rf ~/build/node-test-commit*`.

### General issues with Jenkins agent: "normal machines" edition

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

### Restart the machine

Sometimes something weird happens, and it's easier to just reboot the
worker.

On Unix just do one of:

```bash
shutdown -r now
# or:
reboot
```

On the advice of the system adminstrators managing the AIX machines, please do
not restart them without good reason, it will make things worse.

### Fixing machines with Docker

The above steps generally do not apply to workers that are either
"Half Docker" or "Full Docker".

Below is a quick guide using [`test-softlayer-ubuntu1804_container-x64-1`][1] as an example Jenkins worker.

1. Figure out the which machine hosts the container. It should be stated in
the [worker's view][1] on Jenkins
2. Verify the existence of the container:
    * To view a list of all active Docker containers, you can run: `docker ps`
    * To view a list of all active services, you can run:  
      ```bash
      systemctl list-units | grep jenkins
      ```
    * Each container should have a matching `systemd` service that starts and stops the
    container. Its name should be `jenkins-${workername}`, so in this example
      ```
      jenkins-test-softlayer-ubuntu1804_container-x64-1
      ```
3. To view the logs for a service run:
   ```
   journalctl -u jenkins-test-softlayer-ubuntu1804_container-x64-1
   ```
4. To restart a Docker container, restart the associated `systemd` service:
   ```
   systemctl restart jenkins-test-softlayer-ubuntu1804_container-x64-1
   ```
5. `CONTAINER ID` is needed to console into a Docker container, first run:
   ```
   docker ps -f "name=test-softlayer-ubuntu1804_container-x64-1"
   ```
   That will give you:
   ```
   CONTAINER ID        IMAGE                                               COMMAND                  CREATED             STATUS              PORTS               NAMES
   9f3272e43017        node-ci:test-softlayer-ubuntu1804_container-x64-1   "/bin/sh -c 'cd /hom…"   19 minutes ago      Up 19 minutes                           node-ci-test-softlayer-ubuntu1804_container-x64-1
   ```
   then using run the following, replacing `CONTAINER_ID` with the appropriate ID
   ```
   docker exec -it ${CONTAINER_ID} /bin/bash`
   ```


### IDK what to do

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
[ci]: https://ci.nodejs.org/computer/test-softlayer-ubuntu1804_container-x64-1/
[1]: https://ci.nodejs.org/computer/test-softlayer-ubuntu1804_container-x64-1/
