# io.js Build SmartOS Setup

To set up hosts, make sure you add them to your ssh config first:
```
Host iojs-build-smartos-64-1
  HostName 165.225.137.91
  User root

Host iojs-build-smartos-32-1
  HostName 165.225.138.254
  User root

Host iojs-joyent-smartos13.3.1-release
  HostName 72.2.114.225

Host nodejs-release-joyent-smartos153-64-1
  Hostname 72.2.115.68
```

Note that these hostnames are also used in the ansible-inventory file. The IP addresses will need to be updated each time the servers are reprovisioned.

To set up a host, run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

**Users**: The ansible-vars.yaml file contains a list of users who's GitHub public keys are pulled and placed into
authorized_keys for both root and iojs users. This file should be updates when new users are added to the build project
who are able to help maintain the containerized builds.
