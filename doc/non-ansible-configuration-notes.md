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

### Control machine (where Ansible is run)

Install the `pywinrm` pip module: `pip install pywinrm`

### Target machines

The preparation script needs to be run in PowerShell (run as Administrator):

```powershell
iwr -useb https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 | iex
```

Test the connection to the target machine with `ansible HOST -m win_ping -vvvv`. If there is any issue, please refer to the official Ansible documentation in [Setting up a Windows Host][].

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

Raspberry Pi configuration is integrated into the standard Ansible playbooks and will run properly when the right hosts are executed.

The current configuration relies upon an NFS boot and NFS root architecture, although it should still be possible to connect a non-NFS Raspberry Pi to the Node.js CI and the Ansible playbooks are intended to be friendly to non-NFS hosts. It's possible that current Ansible scripts don't properly account for non-NFS hosts since these are not regularly included so some adjustments may be necessary.

This document covers much of the process we use: https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/net_tutorial.md

### NFS boot

* The SD card in the Raspberry Pi should have an up to date bootcode.bin (found in the FAT partition of the Raspbian images and comes via regular updates) and ideally an updated firmware. It is possible to boot newer Pi's without SD card but the SD card is necessary for older models and our Ansible setup uses it for local swap space.
* Upon boot, the bootcode will cause the Pi to reach out for an initial DHCP discovery. A DHCP server should be configured to respond appropriately for that device's address along with some NFS boot signals, such as this configuration for dnsmasq:

```
enable-tftp
tftp-root=/var/tftpd
pxe-service=0,"Raspberry Pi Boot"
```

* The tftp server on the same DHCP server should be able to respond to boot requests.
* After looking in the root of the tftp server, the Pi will attempt to load files from a subdirectory named by its serial number. Obtain the serial number from /proc/cpuinfo from a running Pi, take the last 8 characters from the `Serial` field and use that to store individual boot files.
* Copy the entirety of the boot partition of the Raspbian disk image into a subdirectory for each Pi. Symlinks are acceptable to map serial numbers to the names of the Pi's to keep them organised properly.
* Edit cmdline.txt inside the tftp subdirectory for each file and replace the contents with:

``
modprobe.blacklist=bcm2835_v4l2 root=/dev/nfs nfsroot=NFS_ROOT_SERVER_IP:/NFS_ROOT_FOR_THIS_PI,vers=3 rw ip=dhcp rootwait elevator=deadline
```

* Replacing `NFS_ROOT_SERVER_IP` and `NFS_ROOT_FOR_THIS_PI` as appropraite. It is assumed that NFSv3 is used for the root server. The `modprobe.blacklist` is for a sound driver that has been causing problems in most 2019 versions of the Raspbian kernels (Stretch and Buster), this may be fixed at a later day and be unnecessary. Booting would freeze late in the process without this driver removed.
* The DHCP / tftp server should export each of the boot directories via NFS so they can be mounted by the Pi's as /boot/ which will allow the files to be updated during system updates.

### NFS root

An NFS root server can be separate from NFS boot server, and could be different for each Pi.

* The NFS root server should export a shared .ccache directory to be mounted by all Pi's, so it should be exported in such a way as to be permissive with IP addresses. The export should have roughly these options: `(async,rw,all_squash,anonuid=1001,anongid=1002,no_subtree_check)`.
* The NFS root server should export a root directory for each Pi. The IP of the server along with the path to the directory should be put in cmdline.txt on the NFS boot server. The exports should have roughly these options: `(rw,sync,no_subtree_check,no_root_squash)`/
* The ext4 partition of the Raspbian image file (second partition, not the boot FAT partition) should be extracted into this root directory.
* `etc/fstab` in the root directory should be edited to make it NFS compatible. Remove the existing `/boot` and `/` entries and replace them with:

```

```
/dev/mmcblk0p1 /mnt/mmcblk0p1 vfat defaults 0 0
NFS_ROOT_SERVER_IP:PATH_TO_SHARED_CCACHE_DIRECTORY /home/iojs/.ccache nfs4 rw,exec,async,noauto 0 0
NFS_BOOT_SERVER_IP:PATH_TO_TFTP_BOOT_EXPORT /boot nfs4 nfsvers=3,rw,noexec,async,noauto 0 0
```

* Ansible should also perform checks on `/etc/fstab` so these modifications may not be strictly necessary but it is helpful to have first-boot be into an appropriate state.
* Mounting `/` is done during the NFS boot process so is omitted from `/etc/fstab`.
* The SD card is mounted at `/mnt/mmcblk0p1` and is assumed to be in this location by the Ansible scripts for swap file creation.
* `/boot` is this Pi's tftp boot directory from the NFS boot server.
* When powered on, the Pi should perform all mount steps and present with the standard initial Raspbian boot & login. Note that SSH is not enabled by default and this needs to be done manually before you can remotely access it. To streamline setup, these additional steps can be performed on an initial Pi and then its root directory copied to all other root directories with only minor modifications to `/etc/fstab` required:
  * Enable SSH with `raspi-config`
  * Add the `nodejs_build_test` public SSH key to `~pi/.ssh/authorized_keys` (with appropriate permissions).
  * Change the default password for user `pi` to remove insecurity. This could even be disabled entirely since the SSH key is in place.

After these steps are performed and the Pi's are running, Ansible can be run to finish setup. A reboot is recommended after initial setup to ensure the environment is configured correctly (locale and other settings that are changed).

## AIX 7.2

To set up, basically:

1. Run ansible
2. Run through ansible/aix61-standalone/manualBootstrap.md, doing the steps marked as
   relevant to AIX 7.2

The manual setup curls some pre-built distributables, the following describes
how they were created.

### Preparing gcc distributables

1. download gcc-c++ (with dependencies) from bullfreeware.com
2. `scp 15412gcc-c++-6.3.0-1.aix7.2.ppc.rpm-with-deps.zip TARGET:/ramdisk0`
   - Note: / is too small
3. `unzip 15412gcc-c++-6.3.0-1.aix7.2.ppc.rpm-with-deps.zip`
4. contained wrong libstdc++-9.1, so downloaded bundle for libstdc++ 6.3.0-1
5. unpack the RPMs:
        `$ for f in *gcc* *stdc*; do rpm2cpio $f | /opt/freeware/bin/cpio_64 -idmv; done`
5. Find absolute symlinks, and make them relative, example:
	```
	$ find . -type l | xargs file
	./opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/ppc64/libatomic.a: symbolic link to /opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/libatomic.a.
	./opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/ppc64/libgcc_s.a: symbolic link to /opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/libgcc_s.a.
	./opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/ppc64/libstdc++.a: symbolic link to /opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/libstdc++.a.
	./opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/ppc64/libsupc++.a: symbolic link to /opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/libsupc++.a.
	./opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/pthread/ppc64/libatomic.a: symbolic link to /opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/pthread/libatomic.a.
	./opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/pthread/ppc64/libgcc_s.a: symbolic link to /opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/pthread/libgcc_s.a.
	./opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/pthread/ppc64/libstdc++.a: symbolic link to /opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/pthread/libstdc++.a.
	./opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/pthread/ppc64/libsupc++.a: symbolic link to /opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/pthread/libsupc++.a.
	```
	```
	bash-5.0# pwd
	/ramdisk0/aixtoolbox/opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/ppc64
	```
	```
	bash-5.0# ln -fs ../libatomic.a ../libgcc_s.a ../libstdc++.a ../libsupc++.a ./
	```
	```
	bash-5.0# find . -type l | xargs file
	./ppc64/libatomic.a: archive (big format)
	./ppc64/libgcc_s.a: archive (big format)
	./ppc64/libstdc++.a: archive (big format)
	./ppc64/libsupc++.a: archive (big format)
	./pthread/ppc64/libatomic.a: symbolic link to /opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/pthread/libatomic.a.
	./pthread/ppc64/libgcc_s.a: symbolic link to /opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/pthread/libgcc_s.a.
	./pthread/ppc64/libstdc++.a: symbolic link to /opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/pthread/libstdc++.a.
	./pthread/ppc64/libsupc++.a: symbolic link to /opt/freeware/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/pthread/libsupc++.a.
	```
	```
	bash-5.0# cd pthread/ppc64/
	```
	```
	bash-5.0# ln -fs ../libatomic.a ../libgcc_s.a ../libstdc++.a ../libsupc++.a ./
	```
	```
	bash-5.0# file *.a
	libatomic.a: archive (big format)
	libgcc.a: archive (big format)
	libgcc_eh.a: archive (big format)
	libgcc_s.a: archive (big format)
	libgcov.a: archive (big format)
	libstdc++.a: archive (big format)
	libsupc++.a: archive (big format)
	```

6. Move to target location and create a tarball with no assumptions on leading
path prefix:
    ```
    $ mkdir /opt/gcc-6.3
	$ cd /opt/gcc-6.3
	$ mv .../opt/freeware/* ./
	$ tar -cvf ../gcc-6.3-aix7.2.ppc.tar *
	```


Example above was for 6.3.0, but process for 4.8.5 is identical, other than
the version numbers.

Example search for 4.8.5 gcc on bullfreeware:
- http://www.bullfreeware.com/?searching=true&package=gcc&from=&to=&libraries=false&exact=true&version=5

### Preparing ccache distributables

Notes:
- AIX tar doesn't know about the "z" switch, so use GNU tar.
- Build tools create 32-bit binaries by default, so explicitly create 64-bit
  ones.

    ```
	$ curl -L -O https://github.com/ccache/ccache/releases/download/v3.7.4/ccache-3.7.4.tar.gz
	  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
					 Dload  Upload   Total   Spent    Left  Speed
	100   607    0   607    0     0   3281      0 --:--:-- --:--:-- --:--:--  3281
	100  490k  100  490k    0     0   586k      0 --:--:-- --:--:-- --:--:-- 60.4M
	$ /opt/freeware/bin/tar -xzf ccache-3.7.4.tar.gz
	$ cd ccache-3.7.4
	$ ./configure CC="gcc -maix64" && gmake
	$ mkdir -p /opt/ccache-3.7.4/libexec /opt/ccache-3.7.4/bin
	$ cp ccache /opt/ccache-3.7.4/bin
	$ cd /opt/ccache-3.7.4/libexec
	$ ln -s ../bin/ccache c++
	$ ln -s ../bin/ccache cpp
	$ ln -s ../bin/ccache g++
	$ ln -s ../bin/ccache gcc
	$ ln -s ../bin/ccache gcov
	$ cd cd /opt/ccache-3.7.4
	$ tar -cf /opt/ccache-3.7.4.aix7.2.ppc.tar.gz *
	```


## rhel7-s390x

### devtoolset-6 install

First copy the rpms from a machine that already has them

```
scp -r test-ibm-rhel7-s390x-1:/data/devtoolset-6-s390x-rpms/ ~/devtoolset-6-s390x-rpms
```

Then copy them over to the target machine

```
scp -r ~/devtoolset-6-s390x-rpms {target host}:~/devtoolset-6-s390x-rpms/
```

Then install the rpms

```
yum install -y devtoolset-6-s390x-rpms/*
```



[Setting up a Windows Host]: https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html
[newer Ansible configuration]: https://github.com/nodejs/build/tree/master/ansible
[stand-alone]: https://github.com/nodejs/build/tree/master/setup/windows
