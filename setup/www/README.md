# io.js Website Setup

This directory contains an Ansible playbook to set up the iojs.org website from a fresh Ubuntu host (Upstart configuration assumes 14.04 or similar).

This setup listens to the [iojs/website](https://github.com/iojs/website) repository for new commits on the *master* branch. The changes are pulled locally and copied (sans the *.git* directory) into a publicly served directory.

The inventory uses the host `iojs-www`, the easiest way to link this is to add it to your *~/.ssh/config*, something like:

```text
Host iojs-www
  HostName 104.236.136.193
  User root
```

This setup assumes a GitHub Webhook is configured ([here](https://github.com/iojs/website/settings/hooks)) to point to port `9999` of the server with the path `/webhook` plus an additional secret.

Note that the *host_vars/iojs-www* file needs to be created, the *host_vars/iojs-www.tmpl* file can be used as a template and simply add the GitHub Webhook secret.

An SSL certificate should also be provided along with a key. The certificate, along with chain, should be placed in *resources/iojs_chained.crt* and the key in *resources/iojs.key*.

Additionally, you'll need the private SSH keys for `staging` and `dist`, which should be `resources/keys/staging/id_rsa` and `resources/keys/dist/id_rsa`.

To set up the web server, run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```
