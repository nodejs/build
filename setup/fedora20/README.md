# io.js Build Fedora 20 Setup

For setting up a Fedora 20 box

```text
Host iojs-ibm-ppcbe-fedora20-64-1
  HostName 140.211.168.172
  User root

Host iojs-ibm-ppcbe-fedora20-64-2
  HostName 140.211.168.191
  User root
```

Note that these hostnames are also used in the *ansible-inventory* file. The IP addresses will need to be updated each time the servers are reprovisioned.

To set up a host, run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

**Users**: The ansible-vars.yaml file contains a list of users who's GitHub public keys are pulled and placed into authorized_keys for both root and iojs users. This file should be updates when new users are added to the build project who are able to help maintain the containerized builds.
