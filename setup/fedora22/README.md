# io.js Build Fedora 22 Setup

For setting up a Fedora 22 box

```text
Host iojs-build-fedora22-1
  HostName 45.55.139.194
  User root
```

Note that these hostnames are also used in the *ansible-inventory* file. The IP addresses will need to be updated each time the servers are reprovisioned.

To set up a host, run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

Note: this requires Ansible 1.9+ because of the use of DNF. As of 1.9.1 it also requires [this patch](https://github.com/ansible/ansible-modules-extras/commit/a3ba1be3f11e8dd16658b592f1dcbe63cc9c9af0) to make the DNF module work.

**Users**: The ansible-vars.yaml file contains a list of users who's GitHub public keys are pulled and placed into authorized_keys for both root and iojs users. This file should be updates when new users are added to the build project who are able to help maintain the containerized builds.
