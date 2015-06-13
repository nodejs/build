# io.js Build FreeBSD Setup

The current FreeBSD lives behind a VPN at [Voxer](http://voxer.com).
Should you need access, speak to [https://github.com/rvagg](rvagg) for
further information.

To set up hosts, make sure you add them to your ssh config first:
```
Host iojs-build-freebsd-64-1
  HostName 172.16.31.2

Host iojs-build-freebsd-32-1
  HostName 172.16.31.3
```

Note that these hostnames are also used in the ansible-inventory file. The IP addresses will need to be updated each time the servers are reprovisioned.

To set up a host, run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

**Users**: The ansible-vars.yaml file contains a list of users who's GitHub public keys are pulled and placed into
authorized_keys for both root and iojs users. This file should be updates when new users are added to the build project
who are able to help maintain the containerized builds.
