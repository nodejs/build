# Fixing machines

A basic guide to troubleshooting machine issues.

## Jenkins job failures

Usually the first sign of trouble is a failed Jenkins job. First thing to check
is whether this is actually a Jenkins issue rather than a machine issue.

1. Rebuild the job.
2. Clean the workspace and rebuild the job.
3. Check vital signs on the machine page
   (https://ci.nodejs.org/computer/<machine>/)
4. Take machine offline and rebuild, do other machines have the same problem?

## On the machine itself

Try to `su` to the Jenkins user if possible, this avoids accidentally doing
things as root (which can destroy the machine, or break jobs).

```bash
su iojs # Check user with `ps -ef | grep java`.
```

It's also good practice to raise/comment in a GitHub issue (or on IRC) to let
others know what you did.

### Out of space

Most common problem is that a partition is full. You can quickly check with:

```bash
df -h # Or `df -m` on machines that don't support `-h`.
```

Look at the `%Used` column (not the `%Iused`, that's for inodes). If it's full
it probably needs a cleanup.

### Processes left behind

```bash
ps -ef | grep iojs | grep -v java | grep -v grep
```

If there are a lot of processes running on the machine, and nothing running on
the machine according to Jenkins, then that's a warning flag. Paste the list of
processes in an issue, and clean them up with:

```bash
# Show all iojs processes except the Jenkins process and grep, and kill them.
ps -ef | grep iojs | grep -v java | grep -v grep | awk '{print $2}' | xargs kill
```

### Git or file permission issues

Sometimes we get problems in job workspaces, either because someone left a file
there as `root` that `iojs` can't remove, or because some git cleanup (like `git
gc`) needs to happen.

Jenkins job workspaces on machines can be wiped (as long as a job isn't running), so
feel free to nuke a job's workspace, for example:

```bash
rm -rf /home/iojs/build/workspace/node-test-commit/
```

The next job will take longer as it re-clones the workspace.


### Turn it off and on again

Sometimes something weird happens, and it's easier to just reboot the machine.
On Unix just do one of:

```bash
shutdown -r now
# or:
reboot
```

When the machine comes back the Jenkins slave should reconnect automatically
(check on ci.nodejs.org). If it doesn't see the next step.

### Restart the Jenkins agent

Most machines have a service to restart the Jenkins agent. Try one of:

```bash
# Systemd init (some newer Linux distros):
systemctl jenkins start
# System V init (older Linux distros):
/etc/init.d/jenkins start
# AIX:
/etc/rc.d/rc2.d/S20jenkins start
# Things we don't have a service for yet:
~iojs/start.sh
```

Service files should be stored [here][Jenkins Worker Template], if none of these
work look for the relevant file there.

## Problems with non-test machines

Ask someone in [infra][Infra Admins] or [release][Release Admins] to take a look.

## Machines needing reimaging or reconfiguring

You need to run the ansible scripts on the machines again, see the [Ansible
Readme][].

[Infra Admins]: https://github.com/nodejs/build#infra-admins
[Jenkins Worker Template]: https://github.com/nodejs/build/tree/master/ansible/roles/jenkins-worker/templates
[Release Admins]: https://github.com/nodejs/build#release-admins
[Ansible Readme]: https://github.com/nodejs/build/blob/master/ansible/README.md
