# Node.js Build Windows Setup for Jenkins Test Machines

For setting up a Windows box to run tests.

Machines should have:
  - Remote Desktop (RDP) enabled, the port should be listed with the access credentials if it is not the default (3389).
  - PowerShell access enabled, the port should be listed with the access credentials if it is not the default (5986).

To use Ansible for Windows, the target machine should have PowerShell access enabled as described in http://docs.ansible.com/ansible/intro_windows.html .
This includes installing the `pywinrm` pip module on the control machine.
For the target machines, this includes ensuring PowerShell v3 is installed, running the preparation script on the target machines and running Windows Update.

Before running the preparation script, the network location must be set to Private (not necessary for Azure).
This can be done in Windows 10 by going to `Settings`, `Network`, `Ethernet`, click the connection name (usually `Ethernet`, next to the icon)
and change `Find devices and content` to on.

The preparation script can be manually downloaded from http://docs.ansible.com/ansible/intro_windows.html and run, or automatically by running
this in PowerShell (run as Administrator):

```powershell
Set-ExecutionPolicy -Force -Scope CurrentUser Unrestricted
Invoke-WebRequest https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 -OutFile ConfigureRemotingForAnsible.ps1
.\ConfigureRemotingForAnsible.ps1
```

To set up the hosts, create a file `../host_vars/node-win10-1.cloudapp.net` (`host_vars` in the same directory as `ansible-inventory`)
for each host and change the variables as necessary:

```yaml
---
server_id: node-msft-win10-1
server_secret: SECRET
ansible_ssh_user: node
ansible_ssh_pass: PASSWORD
ansible_ssh_port: 5986
ansible_connection: winrm
```

To test the connection to the hosts, run:

```text
$ ansible node-windows -i ../ansible-inventory -m win_ping -vvvv
```

To run the Ansible playbook to setup the machines run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml -vv
```

The servers should logon automatically at boot and start the Jenkins slave.

The release servers need to have the WiX Toolset and 7-Zip installed and in the path (not part of this script).
