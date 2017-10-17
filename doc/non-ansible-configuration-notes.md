# Non-Ansible Configuration Notes

There are a number of infrastructure setup tasks that are not currently automated by Ansible, either for technical reasons or due to lack of time available by the individuals involved in these processes. This document is intended to collect that information, to serve as a task list for additional Ansible work and as a central place to note special tasks.

## Windows (Azure/Rackspace)

Currently the Windows configuration is [stand-alone][] and not part of the [newer Ansible configuration][], however it is up to date.

In order to get Windows machines to a state where Ansible can be run against them, some manual steps need to be taken so that Ansible can connect.

Machines should have:
  - Remote Desktop (RDP) enabled, the port should be listed with the access credentials if it is not the default (3389).
  - PowerShell access enabled, the port should be listed with the access credentials if it is not the default (5986).

To use Ansible for Windows, PowerShell access should be enabled as described in [`ansible.intro_windows`][].

### Control machine (where Ansible is run)

Install the `pywinrm` pip module.

Create a file `host_vars/node-win10-1.cloudapp.net` (`host_vars` in the same directory as `ansible-inventory`)
for each host and change the variables as necessary:

```yaml
---
server_id: node-msft-win10-1
server_secret: SECRET
ansible_user: USERNAME
ansible_password: PASSWORD
ansible_port: 5986
ansible_connection: winrm
ansible_winrm_server_cert_validation: ignore
```

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

## ARMv7 Wheezy

The current configuration for the ARMv7 Wheezy nodes (hosted at Scaleway) @ https://github.com/nodejs/build/tree/master/setup/armv7-wheezy pulls in the Raspbian repository for access to GCC 4.8 since it's not available natively on Wheezy. Unfortunately this is an ARMv6 build of GCC and produces ARMv6 binaries rather than optimized ARMv7 binaries.

ARMv7 GCC packages have been created for `armhf` using the Jessie GCC 4.9 source and are hosted @ https://ci.nodejs.org/downloads/armhf/ for use on our test and build ARMv7 Wheezy nodes. This is not yet in the Ansible scripts but could be migrated there by an intrepid reader (and Raspbian references removed). The following is a script that can update an ARMv7 Wheezy machine that has been set up using the existing `armv7-wheezy` Ansible script:

```
#!/bin/sh

set -e
set -x

apt-get update && apt-get dist-upgrade -y && apt-get autoremove -y
apt-get purge gcc-4.7-base -y
apt-get install libcloog-isl3 -y

cd /usr/src/

curl -sLO https://ci.nodejs.org/downloads/armhf/libstdc++6_4.9.2-10_armhf.deb
curl -sLO https://ci.nodejs.org/downloads/armhf/libstdc++6-4.9-dbg_4.9.2-10_armhf.deb
curl -sLO https://ci.nodejs.org/downloads/armhf/libstdc++-4.9-dev_4.9.2-10_armhf.deb
curl -sLO https://ci.nodejs.org/downloads/armhf/gcc-4.9-base_4.9.2-10_armhf.deb
curl -sLO https://ci.nodejs.org/downloads/armhf/libgcc-4.9-dev_4.9.2-10_armhf.deb
curl -sLO https://ci.nodejs.org/downloads/armhf/libgcc1-dbg_4.9.2-10_armhf.deb
curl -sLO https://ci.nodejs.org/downloads/armhf/libgcc1_4.9.2-10_armhf.deb
curl -sLO https://ci.nodejs.org/downloads/armhf/libgomp1_4.9.2-10_armhf.deb
curl -sLO https://ci.nodejs.org/downloads/armhf/libatomic1_4.9.2-10_armhf.deb
curl -sLO https://ci.nodejs.org/downloads/armhf/libasan1_4.9.2-10_armhf.deb
curl -sLO https://ci.nodejs.org/downloads/armhf/libubsan0_4.9.2-10_armhf.deb
curl -sLO https://ci.nodejs.org/downloads/armhf/g++-4.9_4.9.2-10_armhf.deb
curl -sLO https://ci.nodejs.org/downloads/armhf/cpp-4.9_4.9.2-10_armhf.deb
curl -sLO https://ci.nodejs.org/downloads/armhf/gcc-4.9_4.9.2-10_armhf.deb

dpkg -i libstdc++6_4.9.2-10_armhf.deb \
    libstdc++6-4.9-dbg_4.9.2-10_armhf.deb \
    libstdc++-4.9-dev_4.9.2-10_armhf.deb \
    gcc-4.9-base_4.9.2-10_armhf.deb \
    libgcc-4.9-dev_4.9.2-10_armhf.deb \
    libgcc1-dbg_4.9.2-10_armhf.deb \
    libgcc1_4.9.2-10_armhf.deb \
    libgomp1_4.9.2-10_armhf.deb \
    libatomic1_4.9.2-10_armhf.deb \
    libasan1_4.9.2-10_armhf.deb \
    libubsan0_4.9.2-10_armhf.deb \
    g++-4.9_4.9.2-10_armhf.deb \
    cpp-4.9_4.9.2-10_armhf.deb \
    gcc-4.9_4.9.2-10_armhf.deb

rm libstdc++6_4.9.2-10_armhf.deb \
    libstdc++6-4.9-dbg_4.9.2-10_armhf.deb \
    libstdc++-4.9-dev_4.9.2-10_armhf.deb \
    gcc-4.9-base_4.9.2-10_armhf.deb \
    libgcc-4.9-dev_4.9.2-10_armhf.deb \
    libgcc1-dbg_4.9.2-10_armhf.deb \
    libgcc1_4.9.2-10_armhf.deb \
    libgomp1_4.9.2-10_armhf.deb \
    libatomic1_4.9.2-10_armhf.deb \
    libasan1_4.9.2-10_armhf.deb \
    libubsan0_4.9.2-10_armhf.deb \
    g++-4.9_4.9.2-10_armhf.deb \
    cpp-4.9_4.9.2-10_armhf.deb \
    gcc-4.9_4.9.2-10_armhf.deb

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 1
update-alternatives --set gcc /usr/bin/gcc-4.9
update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-4.9  1
update-alternatives --set cc /usr/bin/gcc-4.9
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9  1
update-alternatives --set g++ /usr/bin/g++-4.9
update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-4.9  1
update-alternatives --set c++ /usr/bin/g++-4.9
```

The GCC packages themselves were created with the following steps on a fresh ARMv7 Wheezy server:

```
echo 'deb-src http://http.debian.net/debian/ jessie main non-free contrib' >> /etc/apt/sources.list
apt-get update
apt-get install -y fakeroot build-essential devscripts libc6-dbg m4 libtool autoconf2.64 autogen gawk zlib1g-dev systemtap-sdt-dev flex gdb locales sharutils procps libantlr-java libffi-dev fastjar libmagic-dev zip libasound2-dev libxtst-dev libxt-dev libart-2.0-dev libcairo2-dev dejagnu chrpath quilt doxygen ghostscript texlive-latex-base xsltproc libxml2-utils docbook-xsl-ns binutils-multiarch gperf bison texinfo libecj-java libgtk2.0-dev libcloog-isl-dev libmpc-dev libmpfr-dev libgmp-dev realpath graphviz libcloog-isl-dev dpkg-dev binutils
cd /usr/src/ && apt-get source gcc-4.9/jessie
curl -O https://raw.githubusercontent.com/nodejs/build/master/doc/deb-control-armv7.patch
cd /usr/src/gcc-4.9-4.9.2/debian && patch -p0 < /usr/src/deb-control-armv7.patch
debuild -uc -us
```

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
* Internationalisation Options - Change Locale to en_US.UTF8
* Internationalisation Options - Change Keyboard Layout - Generic non-Intl, English (US)
* Overclock Pi 1 B+ to Medium
* Advanced - Hostname, replace `_` with `--`
* Advanced - Enable SSH

Then, manually:

* Set up .ssh/authorized_keys as appropriate for running Ansible (Insert the `nodejs_build_test` key or the `nodejs_build_release` key as appropriate)
* Ensure that it can boot on the network and local SSH configuration matches the host (reprovisioned hosts will need a replacement of your `known_hosts` entry for it)
* Update <https://github.com/nodejs/build/blob/master/setup/ansible-inventory> to include any new hosts under `[iojs-raspbian]`
* Update <https://github.com/nodejs/build/blob/master/ansible/inventory.yml> to reflect any host additions or changes (this is primarily for automatic .ssh/config setup purposes currently)
* Run Ansible from <https://github.com/nodejs/build/tree/master/setup/raspberry-pi>


[`ansible.intro_windows`]: http://docs.ansible.com/ansible/intro_windows.html
[newer Ansible configuration]: https://github.com/nodejs/build/tree/master/ansible
[stand-alone]: https://github.com/nodejs/build/tree/master/setup/windows
