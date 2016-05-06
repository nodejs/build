# io.js Build Ubuntu 16.04 Setup

Add this to your ssh config:

```text
Host test-digitalocean-ubuntu1604-x64-1
  HostName 104.236.89.53

Host test-digitalocean-ubuntu1604-x86-1
  HostName 159.203.77.233
```

..then run:

```bash
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

If you need to restart jenkins:
```bash
$ systemctl restart jenkins
```
