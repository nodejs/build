# io.js Build CentOS 5 Setup

For setting up a CentOS 5 box

```text
Host iojs-build-centos5-32-1
  HostName 104.236.81.117
  User root

Host test-softlayer-centos5-x64-1
  HostName 50.23.85.252
  User root

Host test-softlayer-centos5-x64-2
  Hostname 173.193.25.109
  User root

Host release-softlayer-centos5-x86-1
  HostName 50.23.85.253
  User root

Host release-digitalocean-centos5-x64-1
  Hostname 162.243.217.142
  User root
```

Note that these hostnames are also used in the *ansible-inventory* file. The IP addresses will need to be updated each time the servers are reprovisioned.

To set up a host, run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

Start-up of the Jenkins slaves is manual (for now), run:

```text
$ ssh iojs-build-centos5-1 "service jenkins start && service jenkins-gcc41 start"
```

**Users**: The ansible-vars.yaml file contains a list of users who's GitHub public keys are pulled and placed into authorized_keys for both root and iojs users. This file should be updates when new users are added to the build project who are able to help maintain the containerized builds.
