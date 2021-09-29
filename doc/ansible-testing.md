# Testing Ansible playbooks locally

While working with Ansible playbooks, there's great value in testing them
locally first, before running them on one or more remote servers. The following
section tries to describe how you would do just that on a Vagrant virtual machine
running Debian for the [github-bot][].

Good luck, and have fun!

## Prerequisites

- Vagrant: https://www.vagrantup.com/downloads.html

## Create a Vagrantfile

Create a directory with a file named `Vagrantfile` inside it, somewhere outside
the build repo directory, as we don't want this in the repo.

The `Vagrantfile` configures the virtual machine about to be created, with the following:

1. Specify which OS we want
2. Prevent Vagrant from generating a random SSH key
3. Copy your own public SSH key onto the machine
4. Use your SSH key for the root user as well

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "debian/jessie64"

  # the insecure key is needed for the first login attempt by vagrant itself
  config.ssh.private_key_path = ["~/.ssh/id_rsa", "~/.vagrant.d/insecure_private_key"]
  config.ssh.insert_key = false
  # fixes "stdin: is not a tty" error when provisioning
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
  # allows us to ssh into the box as root
  config.vm.provision "shell", inline: "mkdir /root/.ssh && cp /home/vagrant/.ssh/authorized_keys /root/.ssh/authorized_keys"
end
```

## Start virtual machine

You can run `vagrant up` to start the virtual machine.

Notice which port the virtual machine's SSH port gets forward to, in the example
below, the port is `2200`.

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

## Edit `~/.ssh/config`

You will have to create an SSH alias for the hosts you're running the Ansible playbook against.

In this [github-bot] example, that means `infra-rackspace-debian8-x64-1` because
the playbook declares this hostname as the host it runs on.

Add the following to your `~/.ssh/config` file:

```
Host infra-rackspace-debian8-x64-1
  HostName 127.0.0.1
  Port 2200
  User root
```

With that in place, it's even easier to connect to your virtual machine:

```bash
$ ssh infra-rackspace-debian8-x64-1
```

## Run the playbook

Before running the playbook, ensure that the necessary secrets are defined.
Try and avoid using production secrets while testing the playbook -- you can add
fake secrets to the inventory instead and
`export NODE_BUILD_SECRETS=/invalid/path/` to make sure the real secrets are
not accessible.

While in the `build` directory, run the playbook using the following
command:

```bash
$ ansible-playbook ansible/playbooks/create-github-bot.yml
```

Don't forget to run `vagrant down` once you are down with the virtual machine.

[github-bot]: ../ansible/playbooks/create-github-bot.yml
