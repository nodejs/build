# io.js Build Alpine 3.4 Setup

Add this to your ssh config:

```text
Host test-joyent-alpine34-x64-2
  HostName 72.2.115.165
  User root
```

Build the host_var config files for each host, including `server_jobs: 2` for
the lower powered hosts, then run:

```bash
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

If you need to restart jenkins:
```bash
$ systemctl restart jenkins
```
