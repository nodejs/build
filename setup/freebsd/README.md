# io.js Build FreeBSD Setup

The current FreeBSD VMs lives at Digitalocean.

You have to install `python` before running ansible. Log in to the VM
and run the following:
```
sudo pkg update && sudo pkg install -y python
```

To set up hosts, make sure you add them to your ssh config first:
```
Host test-digitalocean-freebsd10-x64-1
  HostName 162.243.204.248
  User freebsd

Host test-digitalocean-freebsd10-x64-2
  HostName 104.236.54.140
  User freebsd
```

Note that these hostnames are also used in the ansible-inventory file.
The IP addresses will need to be updated each time
the servers are reprovisioned.

To set up a host, run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

If you have to update settings related to how jenkins is deployed,
the configuration lives in `/usr/local/etc/rc.conf.d/jenkins`.

