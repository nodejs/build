# Ansible scripts for the Node.js build group infrastructure

(in lack of a better title)


## Getting started

1. Follow the [instructions to install the latest version of Ansible][ansible-install].
   * In most cases, using pip: `pip install ansible`.
     * Newer versions of Ansible are incompatible with some older operating systems in the inventory (e.g. RHEL 8). In those cases you will need to install an older version of Ansible, e.g. if using `pip`:
      ```console
      pip install ansible-core==2.16.14 ansible==9.13
      ```
   * If you use brew, then `brew install python3 ansible`, and then run
   `export PYTHONPATH=$(pip show pyyaml | grep Location | awk '{print $2}') `
   before you use `ansible-playbook`.
   * If you have Python 2 installed, you may need to add an alias to your shell profile for python 3 as the default python interpreter, like `alias python=/usr/local/bin/python3.11`
2. Read this document.
3. For SSH access, see the [SSH guide](../doc/ssh.md).


## Getting things done

Most of your work will probably include editing `inventory.yml`, followed by
running one (or multiple) of below playbooks.

The example show running ansible from the directory in which you have cloned
the build directory (not the ansible subdirectory).

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
$ ansible-playbook ansible/playbooks/jenkins/worker/create.yml \
    --limit "test-digitalocean-debian8-x64-1" -vv
```

If you only want to run a specific set of steps, you can use `--step`. This is
useful when developing playbooks and when you want to be sure that only a few
steps are executed, to avoid disrupting the machines.

You can't run any playbooks on a host until you've manually created a
`build:ansible/host_vars/HOST` file for that host (same name as the argument
to limit, above). Use `host_vars/test-marist-zos13-s390x-template` as an
example. The `secret:` doesn't have to be the real Jenkins secret until the
worker actually has to connect to the master.

You may also need to copy the SSH ID files you are using while setting up a new
host to the correct file name, for example:
```console
$ cp ~/.ssh/rhel72-s390x-3.pem /home/sam/.ssh/nodejs_build_test
```

### Running commands directly

You can run Ansible modules directly from the command line, including the
[`shell`](https://docs.ansible.com/ansible/latest/modules/shell_module.html)
module. Since Windows uses a dedicated module, a common pattern is:

```console
$ ansible 'test-*:!*-win*' -m shell -a 'python -V'
$ ansible 'test-*-win*' -m win_shell -a 'python -V'
```

### Secrets

If you have access to secrets, clone the `secrets` repository [next to the
`build` repository](./plugins/inventory/nodejs_yaml.py#L146-L156), or
`export NODE_BUILD_SECRETS=/path/to/secrets/build/`.

To see if the inventory is loaded correctly, run the script directly and
confirm that all the expected information is there and there are no warnings
printed to stderr:

```console
$ python plugins/inventory/nodejs_yaml.py
```

### Playbooks

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

You will always have to set the following variables to configure a host:

- `secret`: the Jenkins agent secrets (use a dummy value for testing the
  scripts on machines that will not be connected to Jenkins)
- `ip`: the IP or DNS address of the machine

#### Optional variables

Variables that _might_ be available for you to change depending on
the machine system and role:

- `port`: SSH or WinRM port to connect to, necessary if not the default
- `user`: only provide if SSH requires a non-root login. Passing this will
  additionally make Ansible try to become root for all commands executed
- `alias`: creates shorthand names for SSH convenience
- `is_benchmark`: set to `true`/`false`. If true, will run the
  `benchmarking` role on the machine
- `server_jobs`: the number of parallel jobs to run on a host
- `server_ram`: how much memory the agent should assign to java-base
  (defaults to "128m")
- `vs`: Visual Studio version to install on Windows hosts
- `rdp_port`: port to use for Windows remote desktop connections

### Adding extra options to a host

Hosts can inherit extra options by adding them to `ansible.cfg`. These are
freeform and are passed to ansible. One example is adding a proxycommand
configuration to hosts at NodeSource since they sit behind a jumphost.

Add a config section by creating a group with the name of the hosts you want
to match (matches on full hostname). Since this is passed as metadata it
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
your inventory file for the new host(s) will need to have a special set of
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
should be given.  The `os` determines the `Dockerfile` to use to build the
host.  The templates for these can be found in `roles/docker/templates/`.

For testing purposes, the stanza above can be added into
`host_vars/<docker_host>`, then the master record should be in the
`inventory.yml` in the secrets repository.

Note that the Docker host itself doesn't need to be known by Jenkins, just the
containers that are managed there.

The docker-host playbook sets up services which are managed via `systemctl`.
If you log into the host sytsem you can view them with `systemctl | grep
jenkins-` and start and stop individual ones using `systemctl start` and
`systemctl stop` commands as and when required. For more information on
debugging problems, see the
[separate guide to fixing docker machines](../doc/jenkins-guide.md#fixing-machines-with-docker)

### TODO

Unsorted stuff of things we need to do/think about

- [x] playbook: copy keys and config to release machines
- [ ] avoid messing with keys on machines that has multiple usage such as jump
      hosts (or set up a new jump host)
- [x] copy release (staging) keys to release machines
- [ ] backup host: generate config, install rsnapshot
- [ ] switch to agentLog for all jenkins instances lacking stdout redirection
      (note: this depends on init type!)
- [ ] add iptables-save-persistent to cron on ci hosts
- [ ] [unencrypted host](https://gist.github.com/jbergstroem/5c308089c26e7ae7529a0ef2df92a7f9)
- [ ] when creating additional jenkins labels based on `labels=` add os/arch
      as part of hte label (ref: rvagg long irc talk see 2016-08-29 logs)
- [ ] follow up ansible upstream wrt hostname support for smartos
- [ ] callback plugin: make `nodejs_yaml` a class and support `--host`
- [ ] add label support to jenkins
- [ ] move all service-related stuff to handlers
- [ ] find a nicer way of adding proxyhosts to iptables
- [ ] add clang/clang++ symlinks for ccache
- [ ] verify that /usr/local/bin works as ccache install path
- [x] remove subversion since v8 tests uses git nowadays
- [ ] assign 192/256mb ram to the jenkins instances that requires it:
      - aix
      - TBD
- [x] make .ssh/config and .ssh/id_rsa for release machines, adding config
      for `node-www` and record host key for node-www
- [ ] add explicit ARCH and DESTCPU for release machines (RV: I'm adding
      "arm64" manually for both to force the right thing, from memory I've
      needed to do this on x86 and x64, best be explicit to be sure)
- [x] github-bot: automate allow list of Jenkins worker IPs

[ansible-install]: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
[callback]: plugins/inventory/nodejs_yaml.py
[github-bot]: https://github.com/nodejs/github-bot
