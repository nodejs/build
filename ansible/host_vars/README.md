## The `host_vars` folder

If you have to handle secrets for workers or pass other variables,
create a file in here with the same name as the machine and store it
in there. It will be automatically made available as part of the
ansible playbook.

### Variables

You will always have to set the following variables to configure a host:

- `secret`: the jenkins slave secrets

#### Optional variables

Variables that _might_ be available for you to change depending on
what init system your host will be running:

- `server_jobs`: the number of parallel jobs to run on a host
- `server_ram`: how much memory the slave should assign to java-base
                (defaults to "128m")
