# ARM machines outside core cluster

## nfs_server parameters

For machines outside the core cluser the nfs details are likely
to be different that the defaults in ansible-vars. Update these
2 to match your configuration.

```
nfs_server:
nfs_share_root:
```

## ssh tunnel

For machines that do not have a static IP address, a connection can
be made through an SSH tunnel.

The following entries need to be added to the host_vars for the host
in order enable the tunnel on the machine when it is configured
by ansible:

```
ci_port: XXXXX
pi_local: "true"

```

were XXXXX is the port used by the release ci for jnlp (see
`Jenkins->Manage Jenkins->Configure Global Security-> TCP port for JNLP agents`
in jenkins UI.


In addition, the ssh private key for the `tunnel` user on the test ci
must be added as `id_rsa` for the root user on the raspberry pi in
the .ssh directory.

Finally, the slave must be configured in jenkins for tunneling.
In the configuration for the machine in the jenkins UI, select the
`Advanced` button under the Launch method section.  For the
"Tunnel connection through" parameter set the value to
`127.0.0.1:XXXXX` were the port is the port used by the
release ci for jnlp as above.

