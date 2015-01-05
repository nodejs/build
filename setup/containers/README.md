# io.js Build Containers Server Setup

There are currently two build containers servers, both running Ubuntu 14.04 64-bit using Docker to run containerized builds and tests of iojs and libuv.

Members of the build team concerned with containierized builds have access to these servers via the following SSH config entries (`~/.ssh/config`):

```text
Host iojs-build-containers-1
  HostName 104.236.138.123
  User root
Host iojs-build-containers-2
  HostName 104.236.138.75
  User root
```

Note that these hostnames are also used in the *ansible-inventory* file. The IP addresses will need to be updated each time the servers are reprovisioned.

To set up a host, run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

Start-up of the Jenkins slaves is manual (for now), run:

```text
$ ssh iojs-build-containers-1 -l iojs ./start.sh
``` 

**Users**: The ansible-vars.yaml file contains a list of users who's GitHub public keys are pulled and placed into authorized_keys for both root and iojs users. This file should be updates when new users are added to the build project who are able to help maintain the containerized builds.
