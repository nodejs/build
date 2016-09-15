# Ansible setup

Servers in the Node.js infrastructure is provisioned with Ansible. This directory contains all
the related Ansible files.

For more information and getting started with Ansible, please read [getting started on ansible.com].

# Working with Ansible

While working with these ansible playbooks, there's great value in testing them locally first, before running
them on one or more remote servers. The following section tries to describe how you would do just that
on a Vagrant virtual machine running debian for the [github-bot](github-bot/ansible-playbook.yaml).

Good luck, have fun!

## Prerequisites

- Vagrant: https://www.vagrantup.com/downloads.html

## Create a Vagrantfile

Create a directory with a file named `Vagrantfile` inside it, somewhere outside the build repo directory, as we don't want this in the repo.

The `Vagrantfile` configures the virtual machine about to be created, with the following:

1. Specify which OS we want
2. Use root as user (rather than the default vagrant user)
3. Prevent Vagrant from generating a random SSH key
4. Copy your own public SSH key onto the machine

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "debian/jessie64"

  config.ssh.username = 'root'
  config.ssh.insert_key = false

  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
end
```

## Start virtual machine

```bash
$ vagrant up
```

Notice which port the virtual machine's SSH port gets forward to, in the example below port `2200`.

```
==> default: Forwarding ports...
    default: 22 (guest) => 2200 (host) (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2200
    default: SSH username: root
```

After that command successfully completed, you should be able to connect to that machine:

```bash
$ ssh -p 2200 root@127.0.0.1
```

*Remember to provide your correct port in the `-p` argument.*

## Edit ~/.ssh/config

You will have to create an SSH alias for the hosts you're running the ansible playbook against.
In this [github-bot](github-bot/ansible-playbook.yaml) example, that means `github-bot` which
is defined as an ansible inventory group in our [inventory file](ansible-inventory).

## Run the playbook

While in the github-bot directory, run the playbook overriding the inventory altogether:

```bash
$ cd setup/github-bot
$ ansible-playbook -i "github-bot," ansible-playbook.yaml
```

The `-i` argument is crucial, as ansible ends up using your newly added SSH alias to run the playbook against.
