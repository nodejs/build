# Non-Ansible Configuration Notes

There are a number of infrastructure setup tasks that are not currently automated by Ansible, either for technical reasons or due to lack of time available by the individuals involved in these processes. This document is intended to collect that information, to serve as a task list for additional Ansible work and as a central place to note special tasks.

## Windows / Azure

TODO

## macOS

TODO

## jenkins-workspace

TODO

## Raspberry Pi

Currently the Raspberry Pi configuration is [stand-alone](https://github.com/nodejs/build/tree/master/setup/raspberry-pi) and not part of the [newer Ansible configuration](https://github.com/nodejs/build/tree/master/ansible), however it is up to date.

In order to get Raspberry Pi's to a state where they Ansible can be run against them, some manual steps need to be taken, including the sourcing of older images.

### Raspbian

Raspbery Pi B+ and Raspberry Pi 2 boxes used in the cluster run Raspbian Wheezy, based on Debian 7 (Wheezy). This distribution is no longer supported so an older version must be used. The last build based on Wheezy was raspbian-2015-05-07, which is available at <http://downloads.raspberrypi.org/raspbian/images/raspbian-2015-05-07/>.

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
  - mount partition 1 of the card
  - remove contents
  - copy in the contents of the Jessie SD image partition 1
  - replace `cmdline.txt` from the Wheezy SD image (which simply contains `dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait`)
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
* Run Ansible from <https://github.com/nodejs/build/tree/master/setup/raspberry-pi>
