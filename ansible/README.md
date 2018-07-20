# Ansible scripts for the Node.js build group infrastructure

(in lack of a better title)


## Getting started

1. Follow the [instructions to install the latest version of Ansible][ansible-install].
   * In most cases, using pip: `pip install ansible`.
   * If you use brew, then `brew install python2 ansible`, and then run
   `export PYTHONPATH=$(pip2 show pyyaml | grep Location | awk '{print $2}') `
   before you use `ansible-playbook`.
2. Read this document.
3. For SSH access, see the [SSH guide](../doc/ssh.md).


## Getting things done

Most of your work will probably include editing `inventory.yml`, followed by
running one (or multiple) of below playbooks.

See the [manual setup instructions](../doc/non-ansible-configuration-notes.md)
for how to prepare both the control and target machines to run the commands
below. To ensure that the secrets are in place and test the connection to a
host use:

```console
$ ansible test-digitalocean-debian8-x64-1 -m ping -vvvv
## Or, for Windows hosts:
$ ansible test-rackspace-win2008r2-x64-1 -m win_ping -vvvv
```

If you're adding a new host, limiting Ansible to just running on that host is
probably quicker. In fact, you most likely want to use `--limit` for everything
when you just need to edit a few set of hosts:

```console
$ ansible-playbook playbooks/jenkins/worker/create.yml \
    --limit "test-digitalocean-debian8-x64-1" -vv
```

If you only want to run a specific set of steps, you can use `--step`. This is
useful when developing playbooks and when you want to be sure that only a few
steps are executed, to avoid disrupting the machines.

These playbooks are available to you:

  - **jenkins/host/create.yml**: Sets up jenkins ci hosts.

  - **jenkins/host/iptables.yml**: Update iptables rules so workers can connect.

  - **jenkins/worker/create.yml**: Sets up jenkins workers.

  - **jenkins/worker/upgrade-jar.yml**: Upgrades the worker jar file.

  - **jenkins/docker-host.yml**: Sets up a host to run Docker workers.

  - **create-github-bot.yml**: Configures the server that hosts the
    [github-bot][].

  - **create-webhost.yml**: Configures the server(s) that host nodejs.org,
                            iojs.org and dist.libuv.org among other things
                            (only works on Ubuntu boxes).

  - **create-unencrypted.yml**: Configures unencrypted.nodejs.org.

  - **upgrade-packages.yml**: Upgrades packages on provided hosts.

  - **update-ssh-keys.yml**: Updates (and verifies) {,pub}keys both locally
    and remote. This is useful if you want to cycle keys.

  - **write-ssh-config.yml**: Updates your ~/.ssh/config with hosts from
   inventory.cfg if your ssh config contains these template stubs:
   ```console
   # begin: node.js template

   # end: node.js template
   ```

If something isn't working, you will likely get a warning or error.
Have a look at the playbooks or roles. They are well documented and should
(hopefully) be easy to improve.

## Adding a new host to inventory.yml

Hosts are listed as part of an yaml collection. Find the type and provider and
add your host in the list (alphabetical order). Your host can start with an
optional sponsor - for instance `rvagg-debian7-arm_pi1p-1` - which expands
into `test-nodesource_rvagg-debian7-arm_pi1p-1`.

Since we use yaml, we can abstract away `$type` and `$provider` by creating
subelements:

```yaml
- test:
  - digitalocean:
    - debian8-x64-1: {ip: 1.2.3.4}
```

Make sure you follow the naming convention. There are scripts in place that
will throw errors if you don't. Using an incorrect convention will likely
lead to unwanted consequences.

### Naming

Each host must follow this naming convention:

```yaml
$type-$provider(_$optionalmeta)-$os-$architecture(_$optionalmeta)-$uid
```

For more information refer to other hosts in `inventory.yml` or the
[ansible callback that is responsible for parsing it][callback].

### Metadata

Each host needs a bit of metadata:

  - (required) `ip`: used both by ansible and placed in your ssh config.
  - `user`: only provide if ssh requires a non-root login. Passing this
             will additionally make ansible try to become root for all
             commands executed.
  - `alias`: creates shorthand names for ssh convenience.
  - `labels`: Each host can also labels. More on that below.

### Adding extra options to a host

Hosts can inherit extra options by adding them to `ansible.cfg`. These are
freeform and are passed to ansible. One example is adding a proxycommand
configuration to hosts at NodeSource since they sit behind a jumphost.

Add a config section by creating a group with the name of the hosts you want
to match (matches on full hostname). Since this is passed to `host_vars` it
can be any kind of ansible variable/config:

```ini
[hosts:freebsd]
ansible_python_interpreter: /usr/local/bin/python
```

**Note**: We currently can't use ansible's built-in support for `proxy_command`
          since that will enable the `paramiko` connection plugin, disregard
          other ssh-specific options.

### Docker host configuration options

When configuring a Docker host using the `jenkins/docker-host.yml` playbook,
your host_vars file for the new host(s) will need to have a special set of
options to configure the containers run on the host. It should look something
like this:

```yaml
containers:
  - { name: 'test-digitalocean-alpine34_container-x64-1', os: 'alpine34', secret: 'abc123' }
  - { name: 'test-digitalocean-alpine35_container-x64-1', os: 'alpine35', secret: 'abc456' }
  - { name: 'test-digitalocean-alpine36_container-x64-1', os: 'alpine36', secret: 'abc567' }
  - { name: 'test-digitalocean-ubuntu1604_container-x64-1', os: 'ubuntu1604', secret: 'abc890' }
```

Where each item corresponds to a container to be set up and run on the host.

Each `name` should exist as a node in Jenkins and the corresponding `secret`
should be given. The `os` determines the `Dockerfile` to use to build the host.
The templates for these can be found in `roles/docker/templates/`.

Note that the Docker host itself doesn't need to be known by Jenkins, just the
containers that are managed there.

### TODO

Unsorted stuff of things we need to do/think about

- [ ] playbook: copy keys and config to release machines
- [ ] avoid messing with keys on machines that has multiple usage such as jump
      hosts (or set up a new jump host)
- [ ] copy release (staging) keys to release machines
- [ ] backup host: generate config, install rsnapshot
- [ ] switch to slaveLog for all jenkins instances lacking stdout redirection
      (note: this depends on init type!)
- [ ] add iptables-save-persistent to cron on ci hosts
- [ ] [unencrypted host](https://git.io/v6H1z)
- [ ] when creating additional jenkins labels based on `labels=` add os/arch
      as part of hte label (ref: rvagg long irc talk see 2016-08-29 logs)
- [ ] follow up ansible upstream wrt hostname support for smartos
- [ ] callback plugin: make `nodejs_yaml` a class and support `--host`
- [ ] add label support to jenkins
- [ ] move all service-related stuff to handlers
- [ ] find a nicer way of adding proxyhosts to iptables
- [ ] add clang/clang++ symlinks for ccache
- [ ] centos7 needs different ccache path
- [ ] debian7 needs to update alternative gcc/g++
- [ ] adding scl stuff on centos5/6 is broken
- [ ] verify that /usr/local/bin works as ccache install path
- [x] remove subversion since v8 tests uses git nowadays
- [ ] assign 192/256mb ram to the jenkins instances that requires it:
      - aix
      - TBD
- [ ] centos5 and 6 repositories for rhel\* stuff is broken
- [ ] automate more items in initial Raspberry Pi setup (see bottom of
      setup/raspberry-pi/README.md, some of these can be automated)
- [ ] epel-release for centos - required for centos7 on packet.net arm64
      before ccache can be installed
- [ ] make .ssh/config and .ssh/id_rsa for release machines, adding config
      for `node-www` and record host key for node-www
- [ ] add explicit ARCH and DESTCPU for release machines (RV: I'm adding
      "arm64" manually for both to force the right thing, from memory I've
      needed to do this on x86 and x64, best be explicit to be sure)
- [ ] github-bot: automate list of whitelisted Jenkins worker IPs with
      python

[ansible-install]: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
[callback]: plugins/inventory/nodejs_yaml.py
[github-bot]: https://github.com/nodejs/github-bot
