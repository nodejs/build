# io.js Build Fedora 21 Setup

For setting up a Fedora 21 box

```text
Host iojs-build-fedora21-1
  HostName 45.55.229.175
  User root
```

Note that these hostnames are also used in the *ansible-inventory* file.
The IP addresses will need to be updated each time the servers
are reprovisioned.

To set up a host, run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

Start-up of the Jenkins slaves is manual (for now), run:

```text
$ ssh iojs-build-fedora21-1 -l iojs ./start.sh
``` 

**Users**: The ansible-vars.yaml file contains a list of users who's GitHub
public keys are pulled and placed into authorized_keys for both root and iojs
users. This file should be updates when new users are added to the build
project who are able to help maintain the containerized builds.
