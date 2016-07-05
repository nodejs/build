# Node.js build Fedora 24 setup

Add this to your ssh config:

```text
Host test-digitalocean-fedora23-x64-1
  HostName 162.243.63.132
```

Run playbook:

```bash
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

If you need to restart jenkins:
```bash
$ systemctl restart jenkins
```
