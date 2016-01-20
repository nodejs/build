# io.js Build Debian 8 Setup

For setting up a Debian 8 box

```text
Host test-rackspace-debian8-x64-1
  HostName 23.253.109.216
Host test-rackspace-debian8-x64-2
  HostName 104.239.140.184
Host test-softlayer-debian8-x86-1
  Hostname 169.44.16.126
```

Note that these hostnames are also used in the *ansible-inventory* file. The IP addresses will need to be updated each time the servers are reprovisioned.

To set up a host, run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

Start-up of the Jenkins slave:

```text
$ systemctl start jenkins
``` 

**Users**: The ansible-vars.yaml file contains a list of users who's GitHub public keys are pulled and placed into authorized_keys for both root and iojs users. This file should be updates when new users are added to the build project who are able to help maintain the containerized builds.
