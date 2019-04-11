# Non-Ansible Configuration Notes

There are a number of infrastructure setup tasks that are not currently automated by Ansible, either for technical reasons or due to lack of time available by the individuals involved in these processes. This document is intended to collect that information, to serve as a task list for additional Ansible work and as a central place to note special tasks.

## nodejs.org / web host

For dist.libuv.org we use letsencrypt.org for HTTPS certificate. Use Certbot to register and generate a certificate on the main nodejs.org server; only the single server serves dist.libuv.org so this configuration is simple. Certbot sets up auto-renewal for the certificate in /etc/cron.d/certbot.

```sh
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-nginx
certbot --nginx run -d dist.libuv.org -m build@iojs.org --agree-tos --no-redirect
certbot --nginx run -d iojs.org -m build@iojs.org --agree-tos --no-redirect
certbot --nginx run -d www.iojs.org -m build@iojs.org --agree-tos --no-redirect
certbot --nginx run -d roadmap.iojs.org -m build@iojs.org --agree-tos --no-redirect
```

## Windows (Azure/Rackspace)

In order to get Windows machines to a state where Ansible can be run against them, some manual steps need to be taken so that Ansible can connect.

Machines should have:
  - Remote Desktop (RDP) enabled, the port should be listed with the access credentials if it is not the default (3389).
  - PowerShell access enabled, the port should be listed with the access credentials if it is not the default (5986).

To use Ansible for Windows, PowerShell access should be enabled as described in [`ansible.intro_windows`][].

### Control machine (where Ansible is run)

Install the `pywinrm` pip module: `pip install pywinrm`

### Target machines

Ensure PowerShell v3 or higher is installed (`$PSVersionTable.PSVersion`), refer to [`ansible.intro_windows`][] if not.

Before running the preparation script, the network location must be set to Private (not necessary for Azure).
This can be done in Windows 10 by going to `Settings`, `Network`, `Ethernet`, click the connection name
(usually `Ethernet`, next to the icon) and change `Find devices and content` to on.

The preparation script can be manually downloaded from [`ansible.intro_windows`][] and run, or automatically by running
this in PowerShell (run as Administrator):

```powershell
Set-ExecutionPolicy -Force -Scope CurrentUser Unrestricted
$ansibleURL = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
Invoke-WebRequest $ansibleURL -OutFile ConfigureRemotingForAnsible.ps1
.\ConfigureRemotingForAnsible.ps1
# Optional
rm ConfigureRemotingForAnsible.ps1
```

## macOS

TODO: Update and copy notes from <https://github.com/nodejs/build/tree/master/setup/osx>

## jenkins-workspace

The hosts labelled jenkins-workspace are used to "execute" the coordination of Jenkins jobs. Jenkins uses them to do the initial Git work to figure out what needs to be done before farming off to the actual test machines. These machines are lower powered but have large disks so they can waste space with the numerous Git repositories Jenkins will create in this process. The use of these hosts takes a load off the Jenkins master and prevents the Jenkins master from filling up its disk with Git repositories.

Note that not all jobs can use jenkins-workspace servers for execution, some are tied to other hosts.

The jenkins-workspace hosts are setup as standard Node.js nodes but are only given the `jenkins-workspace` label. After setup, they require the following manual steps:

* Download the Coverity Build Tool for Linux x64 at <https://scan.coverity.com/download> (requires a Coverity login)
* Extract to `/var`, e.g. so the resulting directory looks like `/var/cov-analysis-linux64-2017.07/` or similar
* Ensure that the [node-coverity-daily](https://ci.nodejs.org/job/node-daily-coverity/configure) job matches the path used in its explicit `PATH` setting

## Docker hosts

The hosts that run Docker images for "sharedlibs", Alpine Linux and a few other dedicated systems (hosts identified by `grep _docker-x64- inventory.yml`) don't have Docker image reload logic built in to Ansible. Changes to Docker images (adding, deleting, modifying) involve some manual preparation.

The general steps are:

1. Stop the concerned Jenkins systemd service(s) (`sudo systemctl stop jenkins-test-$INSTANCE`)
2. Disable the concerned Jenkins systemd service(s) (`sudo systemctl disable jenkins-test-$INSTANCE`)
3. Remove the Jenkins systemd service configuration (`rm /lib/systemd/system/jenkins-test-$INSTANCE.service`)
4. `systemctl daemon-reload` to reload systemd configuration from disk
5. `systemctl reset-failed` to remove the disabled and removed systemd service(s)
6. Clean up unnecessary Docker images (`docker system prune -fa` to clean everything up, or just `docker rm` for the images that are no longer needed and a lighter `docker system prune` after that to clean non-tagged images).

Steps 3-5 may not be strictly necessary in the case of a simple modification as the existing configurations will be reused or rewritten by Ansible anyway.

To completely clean the Jenkins and Docker setup on a Docker host to start from scratch, either re-image the server or run the follwing commands:

```sh
systemctl list-units -t service --plain --all jenkins* | grep jenkins-test | awk '{print $1}' | xargs -l sudo systemctl stop
systemctl list-units -t service --plain --all jenkins* | grep jenkins-test | awk '{print $1}' | xargs -l sudo systemctl disable
sudo rm /lib/systemd/system/jenkins-test-*
sudo systemctl daemon-reload
sudo systemctl reset-failed
sudo docker system prune -fa
```

To do this across multiple hosts, it can be executed with `parallel-ssh` like so:

```sh
parallel-ssh -i -h /tmp/docker-hosts 'systemctl list-units -t service --plain --all jenkins* | grep jenkins-test | awk '\''{print $1}'\'' | xargs -l sudo systemctl stop'
parallel-ssh -i -h /tmp/docker-hosts 'systemctl list-units -t service --plain --all jenkins* | grep jenkins-test | awk '\''{print $1}'\'' | xargs -l sudo systemctl disable'
parallel-ssh -i -h /tmp/docker-hosts 'sudo rm /lib/systemd/system/jenkins-test-*'
parallel-ssh -i -h /tmp/docker-hosts 'sudo systemctl daemon-reload'
parallel-ssh -i -h /tmp/docker-hosts 'sudo systemctl reset-failed'
parallel-ssh -i -h /tmp/docker-hosts 'sudo docker system prune -fa'
```

Note that while this is being done across all Docker hosts, you should disable [node-test-commit-linux-containered](https://ci.nodejs.org/view/All/job/node-test-commit-linux-containered/) to avoid a queue and delays of jobs. The Alpine Linux hosts under [node-test-commit-linux](https://ci.nodejs.org/view/All/job/node-test-commit-linux/) will also be impacted and may need to be manually cancelled if there is considerable delay. Leaving one or more Docker hosts active while reloading others will alleviate the need to do this.

## SmartOS

Joyent SmartOS machines use `libsmartsshd.so` for PAM SSH authentication in order to look up SSH keys allowed to access machines. Part of our Ansible setup removes this so we can only rely on traditional SSH authentication. Therefore, it is critcal to put `nodejs_test_*` public keys into `$USER/.ssh/authorized_keys` as appropriate or access will be lost and not recoverable after reboot or sshd restart (part of Ansible setup).

## Raspberry Pi

Currently the Raspberry Pi configuration is [stand-alone](https://github.com/nodejs/build/tree/master/setup/raspberry-pi) and not part of the [newer Ansible configuration](https://github.com/nodejs/build/tree/master/ansible), however it is up to date.

In order to get Raspberry Pi's to a state where they Ansible can be run against them, some manual steps need to be taken, including the sourcing of older images.

### Raspbian

Raspberry Pi B+ and Raspberry Pi 2 boxes used in the cluster run Raspbian Wheezy, based on Debian 7 (Wheezy). This distribution is no longer supported so an older version must be used. The last build based on Wheezy was raspbian-2015-05-07, which is available at <http://downloads.raspberrypi.org/raspbian/images/raspbian-2015-05-07/>.

Raspberry Pi 3's use the most recent Raspbian Jessie, based on Debian 8 (Jessie) images.

Unfortunately, for recent versions of all Raspberry Pi hardware, including the more recently produced version 1 B+ and version 2, they will not boot with the stock raspbian-2015-05-07 image. To fix this image:

1. Download the latest Jessie image (verified with raspbian-2016-05-31)
2. Extract the first partition of the image (the small FAT32 partition)
3. Copy the complete contents of this partition on to the first partition of an SD card that has the Wheezy image ***but*** keep the `cmdline.txt` from the Wheezy version

See below for specific instructions on how to do this.

#### Manual provisioning steps

Set up SD card:

* Copy image, e.g. `dd if=/tmp/2015-05-05-raspbian-wheezy.img of=/dev/sdh bs=1M conv=fsync` for Pi1's and 2's
* For Wheezy:
  - mount partition 1 of the card (`/boot`)
  - remove contents
  - copy in the contents of the Jessie SD image partition 1
  - replace `cmdline.txt` in the partition with the original from the Wheezy SD image (which simply contains `dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait`)
  - unmount and sync/eject

Set up running system, steps to execute in `raspi-config`:

* Expand Filesystem
* Change User Password
* Advanced - Enable SSH

Then, manually:

* Set up ~pi/.ssh/authorized_keys as appropriate for running Ansible (Insert the `nodejs_build_test` key or the `nodejs_build_release` key as appropriate). Set ~pi/.ssh to mode 755 and ~pi/.ssh/authorized_keys to mode 644.
* Ensure that it can boot on the network and local SSH configuration matches the host (reprovisioned hosts will need a replacement of your `known_hosts` entry for it)
* Update <https://github.com/nodejs/build/blob/master/setup/ansible-inventory> to include any new hosts under `[iojs-raspbian]`
* Update <https://github.com/nodejs/build/blob/master/ansible/inventory.yml> to reflect any host additions or changes (this is primarily for automatic .ssh/config setup purposes currently)
* Run Ansible from <https://github.com/nodejs/build/tree/master/setup/raspberry-pi> with `ansible-playbook ansible-playbook.yaml -i ../ansible-inventory --limit <hostname>`

## git on CentOS 5

GitHub have removed TLS 1.0 & 1.1 support, leaving CentOS 5 support in the lurch. Git has to be manually built on CentOS 5, this also requires:

 * Manually fixing yum repos to point to a still-available CentOS 5 repo (many have been removed and the mirror system doesn't work for 5 anymore) so we can install a couple of dependencies
 * Removing old git & curl
 * Compiling and installing OpenSSL 1.0.2
 * Compiling and installing curl / libcurl
 * Compiling and installing git

The steps to achieve this are as follows, note that there are some manual steps here:

```sh
vi /etc/yum.repos.d/CentOS-Base.repo
# comment out exiting "mirrorlist" and "baseurl" lines in the top [base] block
# add in: baseurl=http://mirrors.usc.edu/pub/linux/distributions/centos/5.11/os/$basearch/
# comment out everything else below the [base] block, e.g. go to the blank line below it and in vim run: :.,$s/^/#

yum remove -y git curl
yum install -y zlib-devel gettext

cd /tmp/

wget https://www.openssl.org/source/openssl-1.0.2n.tar.gz
tar zxvf openssl-1.0.2n.tar.gz && cd openssl-1.0.2n
./config -fpic shared && make -j4 && make install
echo /usr/local/ssl/lib >> /etc/ld.so.conf
ldconfig

cd ..

# Manually download https://curl.haxx.se/download/curl-7.58.0.tar.gz and scp to /tmp/ on the server (haxx.se is strict tls 1.2)
tar zxvf curl-7.58.0.tar.gz && cd curl-7.58.0
./configure --with-ssl=/usr/local/ssl --disable-ldap && make -j4 && make install
echo /usr/local/lib >> /etc/ld.so.conf
ldconfig

cd ..

/usr/local/bin/curl -sLO https://www.kernel.org/pub/software/scm/git/git-2.16.2.tar.gz
tar zxvf git-2.16.2.tar.gz && cd git-2.16.2
LDFLAGS="-L/usr/local/ssl/lib/ -L/usr/local/lib" ./configure --with-openssl=/usr/local/ssl/ --with-curl=/usr/local
LDFLAGS="-L/usr/local/ssl/lib/ -L/usr/local/lib" make -j4
make install

cd ..
/usr/local/bin/curl -sLO https://cloudflare.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.6p1.tar.gz
tar zxvf openssh-7.6p1.tar.gz && cd openssh-7.6p1
LDFLAGS="-L/usr/local/ssl/lib/" ./configure --with-ssl-dir=/usr/local/ssl/ --prefix=/usr/local/
LDFLAGS="-L/usr/local/ssl/lib/" make -j4
make install

# test with: cd /tmp/ && git clone https://github.com/nodejs/node
```

Also ensure that /usr/local/bin is included in the `JENKINS_PATH` set in /etc/init.d/jenkins

[`ansible.intro_windows`]: http://docs.ansible.com/ansible/intro_windows.html
[newer Ansible configuration]: https://github.com/nodejs/build/tree/master/ansible
[stand-alone]: https://github.com/nodejs/build/tree/master/setup/windows
