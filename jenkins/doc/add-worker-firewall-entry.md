# Adding firewall entries for jenkins workers

Workers must be added to the firewall config before they will be able
to connect to the jenkins master.

You must be part of the infra group and have setup the ssh
keys and config file before hand.

To add an entry do the following:

* ssh to the ci master: `ssh ci`
* save the current config to a temporary file: `iptables-save >foo`
* edit the temporary file with your favorite editor. Use one of
  the existing lines as a template and add a new entry at the end
  of the list of hosts just before the second `COMMIT` line near
  the end of the file.
* restore the config from the temporary file: `iptables-restore foo`
* remove the temporary file: `rm foo`
