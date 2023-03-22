# Create Windows custom VM guide

This doc guides you through the process of creating Windows VMs for collaborators to test Node, without connecting them to Jenkins.

## Prerequisits

It is expected that your own machine is set up to run Ansible. If not, please follow the instruction to install and configure it from [here](https://github.com/nodejs/build/blob/main/ansible/README.md#getting-started).

## 1. Creating the machine

This part can be done in two ways.
- You can create a local VM (eg. in VMware, VirtualBox, ...). You should be able to do this witout any Build WG permissions.
- Build WG infra admins can use the accounts in Rackspace or Azure. Please name the machine with a reference to the GitHub issue asking for access (for example `gh-build-3137`), and be mindful of cost limits.

Once the machine is created, you should find its IP address, username (default is Administrator), password, RDP and WinRM ports (defaults are 3389 and 5986). This information will be required later.

After creation, follow the instructions found [here](https://github.com/nodejs/build/blob/main/ansible/MANUAL_STEPS.md#windows-azurerackspace) to set up the machine for running Ansible on it.

## 2. Adding the machine to inventory file

The full name of the machine should follow this format: `test-{Provider}[_{Sponsor}]-{WindowsVersion}_{VisualStudioVersion}-{Architecture}-{UID}`.

### Group

The inventory file is located [here](/ansible/inventory.yml). The newly created machine needs to be added to it in order to run ansible playbooks on it. Hosts are divided into three groups: `infra`, `release`, and `test`. Each of them is further separated into subgroups based on machine providers. For Windows machines, these will in most cases be `azure` and `rackspace` (unless Windows on ARM64 is in case). Your machine should be added to the `test` group and to the provider it belongs to.

**Note:** There is no provider group for local VMs, so feel free to add it to some of the existing ones as long as you do not push that change.

### Name

The machine name needs to follow a certain format in order for ansible to set up everything as expected. That format is `{WindowsVersion}_{VisualStudioVersion}-{Architecture}-{UID}`.
- `WindowsVersion`: This part needs to start with `win`, and end with the version used. Some of the usual values are `win10`, `win2012r2`, `win2016` and `win2019`.
- `VisualStudioVersion`: This part needs to start with `vs`, and end with the version used. Some of the usual values are `vs2017` and `vs2019`.
- `Architecture`: This part can be one of the following values `x86`, `x64`, and `arm64`.
- `UID`: This is just a number to make machines with all other same values distinctive. It starts from 1 and is incremented for each machine with the same setup.

Next are a few examples with valid host names for the inventory file:
- `win2019_vs2019-x64-1`
- `win2012r2_vs2017_x64-3` (if 1 and 2 already exist)
- `win10_vs2019-arm64-1`

### Properties

In order to run ansible playbooks, the inventory file needs to know three pieces of information about the machine:
- IP address: This property is called `ip` and it represents an IPv4 address of the machine.
- Username: This property is called `user` and it is usually `Administrator`.
- Password: This property is called `password` and it must be a valid password for the provided username.

For Build WG cloud machines, only the IP address should be added to the inventory file, the remaining information should be added in the secrets repository. If the machine is expected to live for more than a few days, please commit the changes and open pull requests on both repos.

For local test machines, or for quickly testing, all of the information can be added to the inventory file. Example of a valid host with all of the valid properties set:
```
win2019_vs2019-x64-1: {ip: 192.168.0.101, user: Administrator, password: AdministratorPassword123}
```

## 3. Testing the machine

Once all previous steps are completed, your machine should be accessible to Ansible. To check if it is, try pinging it via the following command:
```
ansible {FullHostName} -m win_ping
```

This should be run from the build repo root directory, where `{FullHostName}` is the full name starting with `test-`. If everything is correct, the result should be:
```
{FullHostName} | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```
If running the ping command fails, try running it with `-vvvv` for more information.

## 4. Configuring the machine

After adding the machine to the inventory and running the ping command to check everything is correct, it is now time to set the machine up for building and testing Node. This is done by the create-windows-custom-vm.yml playbook found [here](/ansible/playbooks/create-windows-custom-vm.yml).

It is important to run a playbook on that host only, especially if you have access to other Node CI machines. For that, you'll need to use `--limit "{FullHostName}"`, where `{FullHostName}` is the full name starting with `test-`.

The Ansible playbook command needs to be run from the build repo root directory, and the command is:
```
ansible-playbook ansible/playbooks/create-windows-test-vm.yml --limit "{FullHostName}"
```

For more information, you can add `-vvvv`, and for control over which steps to run you can add `--step`.

### Known issues

The playbook should run without any problems, but in case you run in any problem, check the following list to see how to get it fixed:
- Task "package-upgrade : download and install Windows updates" fails with "Searching for updates: Exception from HRESULT: 0x80244010 - The number of round trips to the server exceeded the maximum limit (WU_E_PT_EXCEEDED_MAX_SERVER_TRIPS 80244010)". What this means is that your host Windows OS is very outdated. When playbook fails on this task, just rerun it (maybe more than once) until it passes and continues to the next task.
- Playbook hangs on task "install Visual Studio Community 2019 Native Desktop Workload". Since chocolatey is used for installing all of the software needed and installing Visual Studio has a rather complicated script, this can happen sometimes (for other software as well). When in this situation, terminate the playbook process and start it again.
