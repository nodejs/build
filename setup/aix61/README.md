# io.js Build AIX61 Setup

For setting up an AIX 61 box

```text
Host test-ibm-aix61-ppc64-1:18822
  HostName cloud.siteox.com
  User root
  This machine is a temporary one until we get additional resources at osusol. It is some
  sort of shared resource where we have to ssh in on a special port which is 18822 for this
  machine
```

Note that these hostnames are also used in the *ansible-inventory* file. The IP addresses will need to be updated each time the servers are reprovisioned.

To set up a host, run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

**Users**: The ansible-vars.yaml file contains a list of users who's GitHub public keys are pulled and placed into authorized_keys for both root and iojs users. This file should be updates when new users are added to the build project who are able to help maintain the containerized builds.
