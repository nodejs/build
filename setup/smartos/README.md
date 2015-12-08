# io.js Build SmartOS Setup

To set up hosts, make sure you add them to your ssh config first:
```
Host release-joyent-smartos13-x64-1
  HostName 72.2.114.225

Host test-joyent-smartos14-x64-1
  Hostname 72.2.114.47

Host test-joyent-smartos14-x86-1
  Hostname 72.2.112.239

Host release-joyent-smartos14-x64-1
  Hostname 72.2.113.193
```

Note that these hostnames are also used in the ansible-inventory file. The IP addresses will need to be updated each time the servers are reprovisioned.

To set up a host, run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

**Users**: The ansible-vars.yaml file contains a list of users who's GitHub public keys are pulled and placed into
authorized_keys for both root and iojs users. This file should be updates when new users are added to the build project
who are able to help maintain the containerized builds.
