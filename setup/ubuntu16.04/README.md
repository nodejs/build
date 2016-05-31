# io.js Build Ubuntu 16.04 Setup

Add this to your ssh config:

```text
Host test-digitalocean-ubuntu1604-x64-1
  HostName 104.236.89.53

Host test-digitalocean-ubuntu1604-x86-1
  HostName 159.203.77.233

Host test-mininodes-ubuntu1604-arm64_odroid_c2-1
  User odroid
  HostName 70.167.220.147
  # IdentityFile nodejs_build_test

Host test-mininodes-ubuntu1604-arm64_odroid_c2-2
  User odroid
  HostName 70.167.220.148
  # IdentityFile nodejs_build_test

Host test-mininodes-ubuntu1604-arm64_odroid_c2-3
  User odroid
  HostName 70.167.220.149
  # IdentityFile nodejs_build_test
```

Build the host_var config files for each host, including `server_jobs: 2` for the lower powered hosts, then run:

```bash
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

If you need to restart jenkins:
```bash
$ systemctl restart jenkins
```
