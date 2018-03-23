# Node.js Build Windows Setup for Jenkins Test Machines

See the [manual setup instructions](../../doc/non-ansible-configuration-notes.md) for how to prepare both the control and target machines to run the commands below.

To test the connection to the hosts, run:

```text
$ ansible node-windows -i ../ansible-inventory -m win_ping -vvvv
```

To run the Ansible playbook to setup the machines run below command depending on the version of Visual Studio that needs to be installed.
Below command setup the machine with VS2015.

```text
$ ansible-playbook -i ../ansible-inventory vs2015-ansible-playbook.yaml -vv
```

The servers should logon automatically at boot and start the Jenkins slave.

The release servers need to have the WiX Toolset and 7-Zip installed and in the path (not part of this script).
