# io.js Build Ubuntu 14.04 Setup

For setting up a Ubuntu 14.04 box

```text
Host iojs-ibm-ppcle-ubuntu1404-64-1
  HostName 140.211.168.171
  User root
Host iojs-ibm-ppcle-ubuntu1404-64-2
  HostName 140.211.168.192
  User root
Host iojs-softlayer-benchmark
  HostName 50.23.85.254
  User root
Host test-softlayer-ubuntu14-x86-1
  HostName 50.97.245.9
Host test-softlayer-ubuntu14-x64-1
  HostName 50.97.245.5
Host test-digitalocean-ubuntu14-x86-1
  HostName 159.203.115.220
Host test-digitalocean-ubuntu14-x64-1
  HostName 45.55.252.223
Host test-osuosl-ubuntu14-ppc64_le-1
  HostName 140.211.168.106
Host test-osuosl-ubuntu14-ppc64_le-2
  HostName 140.211.168.94
Host test-osuosl-ubuntu14-ppc64_be-1
  HostName 140.211.168.74
Host test-osuosl-ubuntu14-ppc64_be-2
  HostName 140.211.168.75
Host release-osuosl-ubuntu14-ppc64_be-1
  HostName 140.211.168.76
Host release-osuosl-ubuntu14-ppc64_le-1
  HostName 140.211.168.66
```

Note that these hostnames are also used in the *ansible-inventory* file. The IP addresses will need to be updated each time the servers are reprovisioned.

To set up a host, run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

**Users**: The ansible-vars.yaml file contains a list of users who's GitHub public keys are pulled and placed into authorized_keys for both root and iojs users. This file should be updates when new users are added to the build project who are able to help maintain the containerized builds.
