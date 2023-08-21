## Node.js CI backup

A collection of scripts, configuration and information regarding what's
currently being backed up.


### Backed up infrastructure

 - ci.nodejs.org:
   - full backup of /var/lib/jenkins (rotated, excluding workdirs)
   - full backup of /etc (rotated)
   - iptables rules (rotated)
 - ci-release.nodejs.org:
   - full backup of /var/lib/jenkins (rotated, excluding workdirs)
   - full backup of /etc (rotated)
   - iptables rules (rotated)
 - nodejs-www:
   - /home/dist/iojs: all artifacts for iojs.org (static, no deletion)
   - /home/dist/nodejs: all artifacts for nodejs.org (static, no deletion)
   - /home/libuv/www/dist: all artifacts for libuv.org (static, no deletion)
   - /var/log/nginx: all logs for nodejs, iojs and libuv (rotated)
   - full backup of /etc (rotated)


### Folder structure

A list of the backup folder structure to make it easier navigating around.

| filename | description |
| --- | --- |
| `archive/` | archived content |
| `archive/nodejs-logs` | contains compressed logfiles from the old nodejs server |
| `archive/old-jenkins.tar.xz` | a full copy of jenkins pre-security-vulnerability |
| `static/` | backed up content intended for non-rotation |
| `periodic/` | periodically updated storage managed by rsnapshot |


### Setting it up

Dependencies:
 - rsync 3.x (or newer)
 - rsnapshot 1.2 (or newer)

Note: You will likely want ~1Tb storage available on /backup.

#### Installation instructions

1. Install dependencies
2. Copy the folder `backup_scripts` to /root/
3. Place rsnapshot.conf somewhere (and possibly change paths below)
4. Create the folder `/backup` (or edit configs to use another path)
5. Add scripts to cron:
   ```
   50 23 * * * /opt/local/bin/rsnapshot -c /opt/local/etc/rsnapshot.conf daily
   40 23 * * 6 /opt/local/bin/rsnapshot -c /opt/local/etc/rsnapshot.conf weekly && /root/backup_scripts/remove_old.sh ci-release.nodejs.org && /root/backup_scripts/remove_old.sh    ci.nodejs.org
   30 23 1 * * /opt/local/bin/rsnapshot -c /opt/local/etc/rsnapshot.conf monthly
   ```
6. Edit your ssh config as needed (likely the benchmark host)
7. Place the backup key retrieved from the secrets repo in
   `/root/.ssh/nodejs_build_backup`
8. Add your jenkins credentials to /root/.jenkins_credentials (so we can
   reload jenkins after updating the folder structure)
