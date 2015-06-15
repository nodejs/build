# io.js Build Linter Setup

These machines (currently just one) are run as part of the jenkins job,
linting any code before passing it on to compile/test.

To set up hosts, make sure you add them to your ssh config first:
```
Host iojs-linter
  HostName 104.236.229.96
```

Note that these hostnames are also used in the ansible-inventory file.
The IP addresses will need to be updated each time the servers
are reprovisioned.

Before running ansible you need to install Python (2.x):
```
$ ssh freebsd@iojs-linter1 sudo pkg install -y python
```

To set up a host, run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

**Users**: The ansible-vars.yaml file contains a list of users whose GitHub
public keys are pulled and placed into authorized_keys for both root and
iojs users. This file should be updates when new users are added to the
build project who are able to help maintain the containerized builds.
