# Alpine Linux 3.4 via Docker on Ubuntu 16.04 Setup

Add this to your ssh config:

```text
Host test-digitalocean-ubuntu1604_adocker_alpine34-x64-1
  HostName 107.170.75.204
  User root
  #IdentityFile nodejs_build_test
```

..then run:

```bash
$ ansible-galaxy install -p . angstwad.docker_ubuntu
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```
