# Node.js build Debian setup for github-bot

Add this to your ssh config:

```text
Host infra-rackspace-debian8-x64-1
  HostName 23.253.100.79
```

Run playbook:

```bash
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

If you need to restart github-bot:
```bash
$ systemctl restart github-bot
```
