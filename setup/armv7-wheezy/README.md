# io.js Build ARMv7 Wheezy Setup

For setting up an ARMv7 Wheezy box, currently being donated by https://www.scaleway.com/

```text
Host iojs-build-armv7-wheezy-1
  HostName 212.47.233.202
  User root
Host iojs-build-armv7-wheezy-2
  HostName 212.47.246.103
  User root
Host iojs-release-armv7-wheezy-1
  HostName 212.47.246.109
  User root
Host release-scaleway-debian7-arm-1
  Hostname 212.47.230.165
  User root
```

Note that these hostnames are also used in the *ansible-inventory* file. The IP addresses will need to be updated each time the servers are reprovisioned.

To set up a host, run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

Start-up of the Jenkins slaves is manual (for now), run:

```text
$ ssh iojs-build-armv7-wheezy-1 -l iojs ./start.sh
$ ssh iojs-build-armv7-wheezy-2 -l iojs ./start.sh
$ ssh iojs-release-armv7-wheezy-1 -l iojs ./start.sh
``` 
