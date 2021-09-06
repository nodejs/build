# Build Helper Notes

The Node.js Build Working Group now has a AWX instance (https://ansible.nodejs.org) which can be used by non-Build WG members to perform some simple tasks to help free up the CI without waiting for a Build WG member to respond. Those with access to run this simple tasks are known as Build Helpers. To login to AWX click on the little GitHub icon under the login prompt where AWX will using GitHub OAuth authentication (The only requirement is that you are already a member of the `nodejs` org). From there a member of `@nodejs/build` will sort out your permissions for you.


## Tasks Build Helpers Can Run

nb: Don't run this template on any of the Pi's, they require gentle maintainence and this template is too aggressive for them and is more likely to cause issues than solve them.

### Pre-Requisites

Before running any of the following tasks please make sure that any job running on the machine is cancelled (please notify the runner of said job and make sure they are ok with you cancelling the job).

Also make sure you have the full hostname of the machine you wish to target otherwise the playbook wont work. This can be easily found by checking the top right of the `status` page on a failed jenkins run. For multi-node jobs (job that run on multiple levels of Operating System like `node-test-commit-linux`) make sure you are on the specific node that failed otherwise jenkins will be reporting the job ran on the `jenkins-workspace` machine which doesn't actually run the job.

### Restart Agent

This template allows for the Build Helper to restart the jenkins agent on the machine itself which is a simple fix which resolves most issues (Stuck jenkins job, disconnected agent, etc.)

To run the playbook:

 - Navigate to `Templates` under `Resources`
 - Select the template `Restart Agent`
 - Click `launch`
 - For credentials select `nodejs-build-test`
 - In the limit textbox paste in your selected machine
 - Click `launch` to run the playbook

You should now be taken to the output page which will display the result of your playbook run - If you get any non-obivous failures please contact a member of `@nodejs/build` for assistance


### Clear Workspace

This template allows for the clearing of all the workspaces on the node. This is very aggressive and should be used carefully.

To run the playbook:

 - Navigate to `Templates` under `Resources`
 - Select the template `Clear Workspace`
 - Click `launch`
 - For credentials select `nodejs-build-test`
 - In the limit textbox paste in your selected machine
 - Click `launch` to run the playbook

You should now be taken to the output page which will display the result of your playbook run - If you
get any non-obivous failures please contact a member of `@nodejs/build` for assistance
