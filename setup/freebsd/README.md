# io.js Build FreeBSD Setup

The current FreeBSD lives at Digitalocean.

To set up hosts, make sure you add them to your ssh config first:
```
Host test-digitalocean-freebsd10-x64-1
  HostName 162.243.204.248
  User freebsd

Host test-digitalocean-freebsd10-x64-2
  HostName 104.236.54.140
  User freebsd
```

Note that these hostnames are also used in the ansible-inventory file. The IP addresses will need to be updated each time the servers are reprovisioned.

To set up a host, run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

**Users**: The ansible-vars.yaml file contains a list of users who's GitHub public keys are pulled and placed into
authorized_keys for both root and iojs users. This file should be updates when new users are added to the build project
who are able to help maintain the containerized builds.
