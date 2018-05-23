# io.js Build OpenBSD Setup

## Setting up

To set up hosts, make sure you add them to your ssh config first:
```
Host test-digitalocean-openbsd61-x64-1
  HostName 162.243.204.248
  User openbsd

Host test-digitalocean-openbsd61-x64-2
  HostName 104.236.54.140
  User openbsd
```

You will also have to install python (ansible dependency) and sudo:
```bash
$ ssh test-digitalocean-openbsd61-x64-1 "doas pkg_add -z python-2.7 sudo"
```

Now you're ready to run the playbook:
```bash
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

## Restarting jenkins

If you ever need to restart jenkins:
```bash
$ ssh test-digitalocean-openbsd61-x64-1 "sudo rcctl restart jenkins"
```
