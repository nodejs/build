# io.js Build Linter Setup

## Setting up

To set up hosts, make sure you add them to your ssh config first:
```
Host lint-digitalocean-freebsd10-x64-1
  HostName 104.236.229.96

Host lint-joyent-freebsd10-x64-1
  HostName 72.2.114.23
```

You will also have to install python (ansible dependency):
```bash
$ ssh lint-joyent-freebsd10-x64-1 sudo pkg install -y python
```

Now you're ready to run the playbook:
```bash
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

## Restarting jenkins

If you ever need to restart jenkins:
```bash
$ ssh lint-joyent-freebsd10-x64-1 sudo service jenkins restart
```

