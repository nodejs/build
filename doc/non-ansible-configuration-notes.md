# Non-Ansible Configuration Notes

There are a number of infrastructure setup tasks that are not currently automated by Ansible, either for technical reasons or due to lack of time available by the individuals involved in these processes. This document is intended to collect that information, to serve as a task list for additional Ansible work and as a central place to note special tasks.

## Windows / Azure

TODO: Update and copy notes from <https://github.com/nodejs/build/tree/master/setup/windows>

## macOS

TODO: Update and copy notes from <https://github.com/nodejs/build/tree/master/setup/osx>

## jenkins-workspace

The hosts labelled jenkins-workspace are used to "execute" the coordination of Jenkins jobs. Jenkins uses them to do the initial Git work to figure out what needs to be done before farming off to the actual test machines. These machines are lower powered but have large disks so they can waste space with the numerous Git repositories Jenkins will create in this process. The use of these hosts takes a load off the Jenkins master and prevents the Jenkins master from filling up its disk with Git repositories.

Note that not all jobs can use jenkins-workspace servers for execution, some are tied to other hosts.

The jenkins-workspace hosts are setup as standard Node.js nodes but are only given the `jenkins-workspace` label. After setup, they require the following manual steps:

* Download the Coverity Build Tool for Linux x64 at <https://scan.coverity.com/download> (requires a Coverity login)
* Extract to `/var`, e.g. so the resulting directory looks like `/var/cov-analysis-linux64-2017.07/` or similar
* Ensure that the [node-coverity-daily](https://ci.nodejs.org/job/node-daily-coverity/configure) job matches the path used in its explicit `PATH` setting

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
