# Node.js build Fedora setup

Add this to your ssh config:

```text
Host test-digitalocean-fedora22-x64-1
  HostName 45.55.139.194

Host test-digitalocean-fedora23-x64-1
  HostName 162.243.63.132

Host test-digitalocean-fedora24-x64-1
  HostName 104.236.112.180
```

Run playbook:

```bash
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

If you need to restart jenkins:
```bash
$ systemctl restart jenkins
```
