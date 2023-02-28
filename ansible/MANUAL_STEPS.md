# Manual steps required to setup machines

* [Adding firewall entries for Jenkins workers](#adding-firewall-entries-for-jenkins-workers)
* [`release-*` machines](#release--machines)
  * [`release-*container*` machines](#release-container-machines)
  * [macOS release machines](#macos-release-machines)
    * [Full Xcode](#full-xcode)
    * [Signing certificates](#signing-certificates)
* [macOS](#macos)
  * [Install Command Line Tools for Xcode](#install-command-line-tools-for-xcode)
* [AIX](#aix)
  * [Disk layout](#disk-layout)
* [AIX 7.1](#aix-71)
  * [Remove en1 network interface](#remove-en1-network-interface)
  * [Update XL C/C++ Runtime](#update-xl-cc-runtime)
* [AIX 7.2 Install](#aix-72-install)
  * [ccache 3.7.4 on AIX 7.2](#ccache-374-on-aix-72)
  * [Enable the AHA fs](#enable-the-aha-fs)
  * [Install XL compilers](#install-xl-compilers)
  * [Preparing gcc distributables](#preparing-gcc-distributables)
* [Windows (Azure/Rackspace)](#windows-azurerackspace)
  * [Control machine (where Ansible is run)](#control-machine-where-ansible-is-run)
  * [Target machines](#target-machines)
* [jenkins-workspace](#jenkins-workspace)
* [Docker hosts](#docker-hosts)
* [SmartOS](#smartos)
* [Raspberry Pi](#raspberry-pi)
  * [NFS boot](#nfs-boot)
* [IBM i](#ibm-i)
* [z/OS](#zos)

## Adding firewall entries for Jenkins workers

Workers must be added to the firewall config before they will be able
to connect to the Jenkins master.

You must be part of the infra group and have setup the ssh keys and config file
beforehand.

To add an entry do the following:

* ssh to the ci master: `ssh ci`
* save the current config to a temporary file: `iptables-save >foo`
* edit the temporary file with your favorite editor. Use one of
  the existing lines as a template and add a new entry at the end
  of the list of hosts just before the second `COMMIT` line near
  the end of the file.
* restore the config from the temporary file: `iptables-restore foo`
* remove the temporary file: `rm foo`
* run `iptables-save > /etc/iptables/rules.v4` to ensure the changes persist across reboots

## `release-*` machines

Release machines must be able to upload release artifacts to the nodejs.org
web server. The [release-builder](roles/release-builder) Ansible role will
write the necessary key and ssh config onto the release machine, automating
the previously manual steps.

<details>
<summary>Manual steps</summary>

Once setup, they must have `~iojs/.ssh` cloned from another machine, so they
have the ssh setup and keys required to upload release artifacts to the
nodejs.org web server. The result will be 2 files, an `id_rsa` containing
a private key, and a `config` containing:

```
Host node-www
  HostName direct.nodejs.org
  User staging
  IdentityFile ~/.ssh/id_rsa
```

Both the `config` file and `id_rsa` should be owned and only readable by the
user: `chmod 700 .ssh && chmod 600 .ssh/*`.

Its necessary to accept the `known_hosts` keys interactively on first ssh or
the release builds will fail. After setting up .ssh, do something like this:

```
ssh node-www date
// ... accept the host keys
```
</details>

### `release-*container*` machines

In the case of Docker container release hosts, the SSH configuration above works
differently since the `~iojs` home directories are elsewhere on the host
machine. The Docker containers are started with `/home/iojs` inside the
container mounted from `/home/iojs/name-of-container/` on the host machine.
Therefore, the above SSH configuration should take place in
`/home/iojs/name-of-container/.ssh/`, with permissions set appropriately.

`known_hosts` can be primed and SSH tested from within the running containers:

1. Find the running container ID using `docker ps`
2. Enter the container using `docker exec <containerid> -ti bash`
3. Run `ssh node-www date` (as above)

### macOS release machines

Previous notes: [#1393](https://github.com/nodejs/build/issues/1393)

#### Full Xcode

Xcode Command-line tools are not enough to perform a full notarization cycle, full Xcode must be installed manually.

As root:

* Download Xcode: https://developer.apple.com/download/more/ - find non-beta version, open Developer Tools in browser, Networking tab, start download (then cancel), in Networking tab "Copy as cURL" (available in Chrome & FF)
* Download onto release machine using the copied curl command (may need `-o xcode.xip` appended to curl command) to `/tmp`
* Extract: `xip --expand xcode.xip`
* Move `Xcode.app` directory to `/Applications`
* `xcode-select --switch /Applications/Xcode.app`
* `xcodebuild -license` - accept license

#### Signing certificates

* Extract from secrets/build/release: `dotgpg cat Apple\ Developer\ ID\ Node.js\ Foundation.p12.base64 | base64 -D > /tmp/Apple\ Developer\ ID\ Node.js\ Foundation.p12`
* Transfer to release machine (scp to /tmp)
* `sudo security import /tmp/Apple\ Developer\ ID\ Node.js\ Foundation.p12 -k /Library/Keychains/System.keychain -T /usr/bin/codesign -T /usr/bin/productsign -P 'XXXX'` (where XXXX is found in secrets/build/release/apple.md) (`security unlock-keychain -u /Library/Keychains/System.keychain` _may_ be required prior to running this command).

#### Validating certificates are in date

1. security -i unlock-keychain    (Enter the password for the machine located in secrets)
2. security find-certificate -c "Developer ID Application" -p > /tmp/app.cert     (outputs the PEM format of the cert so we can properly inspect it)
3. security find-certificate -c "Developer ID Installer" -p > /tmp/installer.cert
4. openssl x509 -inform PEM -text -in /tmp/app.cert | less
5. openssl x509 -inform PEM -text -in /tmp/installer.cert | less

The last two steps will show the details of the certificates allowing to see expiry dates.

Example:

```
Not Before: Jan 22 03:40:05 2020 GMT
Not After : Jan 22 03:40:05 2025 GMT
```

## macOS
1. Update Sudoers file:

this requires `NOPASSWD` to be added to the sudoers file to enable elevation

`sudo visudo`
and change:
`%admin          ALL = (ALL) ALL`
to
`%admin          ALL = (ALL) NOPASSWD:ALL`

2. Allow ssh access

```bash
sudo systemsetup -setremotelogin on
```

### Install Command Line Tools for Xcode

Older versions of `gyp` in Node.js 12 and npm 6 (included in Node.js 12
and 14) cannot detect Command Line Tools for Xcode unless they have
been installed manually. Later versions of `gyp` in Node.js 16 and
above, and npm 7/8 use an additional way to detect the Command Line
Tools for Xcode and do not need this step done to build.

`gyp` only checks for Command Line Tools for Xcode if a full Xcode
install was not detected (e.g. on the release machines). We do not
install the full Xcode on the test machines to save disk space (the
Command Line Tools are much smaller).

To check if this needs to be done on a macOS instance that will build
Node.js 12 or 14, run
```console
pkgutil --pkg-info=com.apple.pkg.CLTools_Executables
```

This should return something like
```console
package-id: com.apple.pkg.CLTools_Executables
version: 11.5.0.0.1.1588476445
volume: /
location: /
install-time: 1642786943
groups: com.apple.FindSystemFiles.pkg-group
```

If instead this errors with:
```console
No receipt for 'com.apple.pkg.CLTools_Executables' found at '/'.
```

then manually download and install:
1. Go to https://developer.apple.com/download/all/?q=command with an
Apple Developer account (it does not need to be the Build WG's account)
and find `Command Line Tools for Xcode 11.5`. Click the `View Details`
twisty to reveal the download link and download the
`Command_Line_Tools_for_Xcode_11.5.dmg` file.
2. Mount the `.dmg` disk image. This creates
`/Volumes/Command Line Developer Tools`
```console
sudo hdiutil attach Command_Line_Tools_for_Xcode_11.5.dmg
```
3. Install the `.pkg` inside the mounted disk image.
```console
sudo installer -package /Volumes/Command\ Line\ Developer\ Tools/Command\ Line\ Tools.pkg -target /
```
4. Verify with the earlier `pkgutil` command that the installation is
detectable.
5. Unmount the disk image.
```console
sudo hdiutil detach /Volumes/Command\ Line\ Developer\ Tools
```

## AIX

### Disk Layout

[Our AIX Ansible bootstrap role](roles/bootstrap/tasks/partials/aix.yml) 
attempts to resize filesystems to be large enough to install packages from the
AIX Toolbox and to hold workspaces for CI builds. The server instances will
need to have enough disk space available to fit the requested disk space. On
IBM Cloud, for example, this involves having a second disk added in addition to
the default one (e.g. 20Gb standard disk and an additional 100Gb one).

If not enough space is availble the Jenkins worker create playbook will fail
with an `allocp` error, e.g.

```console
TASK [bootstrap : Set size of /tmp to 1G] ******************************************************************************************************************
task path: /home/rlau/sandbox/github/build/ansible/roles/bootstrap/tasks/partials/aix.yml:25
redirecting (type: modules) ansible.builtin.aix_filesystem to community.general.aix_filesystem
fatal: [test-ibm-aix73-ppc64_be-1]: FAILED! => {"changed": false, "msg": "Failed to run chfs. Error message: 0516-404 allocp: This system cannot fulfill the allocation request.\n\tThere are not enough free partitions or not enough physical volumes \n\tto keep strictness and satisfy allocation requests.  The command\n\tshould be retried with different allocation characteristics.\n"}
```

On AIX disks are organised into physical volumes (the disks) and logical
volumes. Disks can be added to a volume group (where AIX will then manage the
storage for the group). Useful commands are:

```console
lspv
```

this will list the physical volumes attached to the server, e.g.

```console
hdisk0          00c8d470fdbc3b5e                    rootvg          active
hdisk1          00f6db0a6c7aece5                    rootvg          active
```

shows two disks attached to one volume group named `rootvg`. If this shows one
of the disks as `None` this indicates that the disk has not been included in
the volume group.

```console
hdisk0          00fa00d6b552f41b                    rootvg          active
hdisk1          none                                None
```

[`lspv <disk name>`](https://www.ibm.com/docs/en/aix/7.3?topic=l-lspv-command)
will show further information about disks.

```console
# lspv hdisk0
PHYSICAL VOLUME:    hdisk0                   VOLUME GROUP:     rootvg
PV IDENTIFIER:      00fa00d6b552f41b VG IDENTIFIER     00fa00d600004c000000017d43623707
PV STATE:           active
STALE PARTITIONS:   0                        ALLOCATABLE:      yes
PP SIZE:            32 megabyte(s)           LOGICAL VOLUMES:  13
TOTAL PPs:          639 (20448 megabytes)    VG DESCRIPTORS:   2
FREE PPs:           4 (128 megabytes)        HOT SPARE:        no
USED PPs:           635 (20320 megabytes)    MAX REQUEST:      512 kilobytes
FREE DISTRIBUTION:  00..00..00..00..04
USED DISTRIBUTION:  128..128..127..128..124
MIRROR POOL:        None
# lspv hdisk1
0516-1396 : The physical volume hdisk1, was not found in the
system database.
#
```

To add a disk to a volume group:

```console
extendvg rootvg hdisk1
```

This may fail:

```console
0516-1254 extendvg: Changing the PVID in the ODM.
0516-1162 extendvg: The Physical Partition Size of 32 requires the creation of
        3200 partitions for hdisk1.  The limitation for volume group rootvg is
        1016 physical partitions per physical volume.  Use chvg command with -t
        option to attempt to change the maximum Physical Partitions per Physical
        volume for this volume group.
0516-792 extendvg: Unable to extend volume group.
```

Information about a volume group can be obtained via [`lsvg`](https://www.ibm.com/docs/en/aix/7.3?topic=l-lsvg-command),
e.g.

```console
# lsvg rootvg
VOLUME GROUP:       rootvg                   VG IDENTIFIER:  00fa00d600004c000000017d43623707
VG STATE:           active                   PP SIZE:        32 megabyte(s)
VG PERMISSION:      read/write               TOTAL PPs:      639 (20448 megabytes)
MAX LVs:            256                      FREE PPs:       4 (128 megabytes)
LVs:                13                       USED PPs:       635 (20320 megabytes)
OPEN LVs:           12                       QUORUM:         2 (Enabled)
TOTAL PVs:          1                        VG DESCRIPTORS: 2
STALE PVs:          0                        STALE PPs:      0
ACTIVE PVs:         1                        AUTO ON:        yes
MAX PPs per VG:     32512
MAX PPs per PV:     1016                     MAX PVs:        32
LTG size (Dynamic): 512 kilobyte(s)          AUTO SYNC:      no
HOT SPARE:          no                       BB POLICY:      relocatable
PV RESTRICTION:     none                     INFINITE RETRY: no
DISK BLOCK SIZE:    512                      CRITICAL VG:    no
FS SYNC OPTION:     no                       CRITICAL PVs:   no
ENCRYPTION:         yes
#
```

where the earlier error is referring to `MAX PPs per PV`. This can be changed,
as indicated by the error message, with [`chvg -t`](https://www.ibm.com/docs/en/aix/7.3?topic=c-chvg-command). 
Note that `-t` takes a scaling factor which is multiplied by 1016. For our
100Gb disks we use a factor of 16 which then allows the
[`extendvg`](https://www.ibm.com/docs/en/aix/7.3?topic=e-extendvg-command)
command to succeed:

```console
# chvg -t 16 rootvg
0516-1164 chvg: Volume group rootvg changed.  With given characteristics rootvg
        can include up to 2 physical volumes with 16256 physical partitions each.
# extendvg rootvg hdisk1
#
```

After extending the `rootvg` volume group you may still run into an error with
the playbook:
```console
TASK [bootstrap : Set size of /home to 50G] ****************************************************************************************************************
ok: [test-ibm-aix73-ppc64_be-1] => {"changed": false, "msg": "0516-787 extendlv: Maximum allocation for logical volume hd1\n\tis 512.\n"}
```

We can use `lslv <logical volume name>` to view the volume:

```console
# lslv hd1
LOGICAL VOLUME:     hd1                    VOLUME GROUP:   rootvg
LV IDENTIFIER:      00fa00d600004c000000017d43623707.8 PERMISSION:     read/write
VG STATE:           active/complete        LV STATE:       opened/syncd
TYPE:               jfs2                   WRITE VERIFY:   off
MAX LPs:            512                    PP SIZE:        32 megabyte(s)
COPIES:             1                      SCHED POLICY:   parallel
LPs:                1                      PPs:            1
STALE PPs:          0                      BB POLICY:      relocatable
INTER-POLICY:       minimum                RELOCATABLE:    yes
INTRA-POLICY:       center                 UPPER BOUND:    32
MOUNT POINT:        /home                  LABEL:          /home
MIRROR WRITE CONSISTENCY: on/ACTIVE
EACH LP COPY ON A SEPARATE PV ?: yes
Serialize IO ?:     NO
INFINITE RETRY:     no                     PREFERRED READ: 0
ENCRYPTION:         no
#
```

and use [`chlv -x`](https://www.ibm.com/docs/en/aix/7.3?topic=c-chlv-command)
to increase the maximum logical partitions (`MAX LPs`). For our 100Gb we use
`6000` (to match what we have for our AIX 7.1 IBM Cloud instances):

```
# chlv -x 6000 hd1
# lslv hd1
LOGICAL VOLUME:     hd1                    VOLUME GROUP:   rootvg
LV IDENTIFIER:      00fa00d600004c000000017d43623707.8 PERMISSION:     read/write
VG STATE:           active/complete        LV STATE:       opened/syncd
TYPE:               jfs2                   WRITE VERIFY:   off
MAX LPs:            6000                   PP SIZE:        32 megabyte(s)
COPIES:             1                      SCHED POLICY:   parallel
LPs:                1                      PPs:            1
STALE PPs:          0                      BB POLICY:      relocatable
INTER-POLICY:       minimum                RELOCATABLE:    yes
INTRA-POLICY:       center                 UPPER BOUND:    32
MOUNT POINT:        /home                  LABEL:          /home
MIRROR WRITE CONSISTENCY: on/ACTIVE
EACH LP COPY ON A SEPARATE PV ?: yes
Serialize IO ?:     NO
INFINITE RETRY:     no                     PREFERRED READ: 0
ENCRYPTION:         no
#
```

## AIX 7.1

### Remove en1 network interface

Some libuv/Node.js tests currently fail on AIX with a network interface
containing a link local address. This is being tracked in
https://github.com/nodejs/node/issues/39143. In the meantime the `en1`
interface containing the link local address is removed.
```
sudo ifconfig en1 down detach
```

Use
```
ifconfig -a
```
to list the available interfaces. To add back the `en1` interface, run
```
sudo autoconf6 -i en1
```

### Update XL C/C++ Runtime

Java 17 requires XL C/C++ Runtime 16.1 available from https://www.ibm.com/support/pages/fix-list-xl-cc-runtime-aix#161X.
Once downloaded, unpack the files with `zcat`:
```
zcat 16.1.0.9-IBM-xlCrte-AIX-FP009.tar.Z |  tar -xvf -
```
and then install with `installp`:
```
installp -aXYgd . -e /tmp/install.log all
```

Use `lslpp -l xlC\*` to view the curently installed version.

```
# lslpp -l xlC\*
  Fileset                      Level  State      Description
  ----------------------------------------------------------------------------
Path: /usr/lib/objrepos
  xlC.aix61.rte             13.1.3.3  COMMITTED  IBM XL C++ Runtime for AIX 6.1
                                                 and later
  xlC.cpp                    9.0.0.0  COMMITTED  C for AIX Preprocessor
  xlC.rte                   13.1.3.3  COMMITTED  IBM XL C++ Runtime for AIX
  xlC.sup.aix50.rte          9.0.0.1  COMMITTED  XL C/C++ Runtime for AIX 5.2
#
```

## AIX 7.2 Install

Most packages should be installed via ansible.

If there are any missing they should be installed via yum

What you do need to install manually is **ccache**


```bash
mkdir -p /opt/gcc-6.3 && cd /opt/gcc-6.3
curl -L https://ci.nodejs.org/downloads/aix/gcc-6.3-aix7.2.ppc.tar.gz | /opt/freeware/bin/tar -xzf -
```

### ccache 3.7.4 on AIX 7.2

```bash
mkdir -p /opt/ccache-3.7.4 && cd /opt/ccache-3.7.4
curl -L https://ci.nodejs.org/downloads/aix/ccache-3.7.4.aix7.2.ppc.tar.gz | /opt/freeware/bin/tar -xzf -
```

### Enable the AHA fs

For AIX 7 and 6.1, needed for the file watcher unit tests.

Add the following to /etc/filesystems:

```
/aha:
        dev             = /aha
        vfs             = ahafs
        mount           = true
        vol             = /aha
```

and then:

```bash
mkdir /aha
mount /aha
```

### Install XL compilers

1. Download 16.1.0 packages from: https://testcase.boulder.ibm.com (username:
   xlcomp4, password: ask @mhdawson)
2. scp them to target:/opt/ibm-xlc
3. on target:
```bash
cd /opt/ibm-xlc
uncompress 16.1.0.3-IBM-xlCcmp-AIX-FP003.tar.Z
tar -xvf 16.1.0.3-IBM-xlCcmp-AIX-FP003.tar
uncompress IBM_XL_C_CPP_V16.1.0.0_AIX.tar.Z
tar -xvf IBM_XL_C_CPP_V16.1.0.0_AIX.tar
installp -aXYgd ./usr/sys/inst.images -e /tmp/install.log all
inutoc
installp -aXgd ./ -e /tmp/install.log all
```
4. Find compilers in `/opt/IBM/xl[cC]/16.1.0/bin/`

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
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1" -OutFile "ConfigureRemotingForAnsible.ps1"
.\ConfigureRemotingForAnsible.ps1 -ForceNewSSLCert true -CertValidityDays 3650
```

#### Port Configuration

Delete the unencrypted WinRM endpoint:

```powershell
winrm delete winrm/config/Listener?Address=*+Transport=HTTP
```

On Rackspace hosts, it is necessary to change the port to match the value found in secrets (change 12345):

```powershell
winrm set winrm/config/Listener?Address=*+Transport=HTTPS '@{Port="12345"}'
```

On Azure, changing the ports is done in the Load Balancer configuration using the Azure Portal.

To see the status of running listeners:

```powershell
winrm enumerate winrm/config/listener
```

#### Test

Test the connection to the target machine with `ansible HOST -m win_ping -vvvv`. If there is any issue, please refer to the official Ansible documentation in [Setting up a Windows Host][].

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

```
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


## IBM i

There isn't a system start service on IBMi -- the machine should not be
rebooted, and after ansible is run, jenkins needs to be started with
`jenkins-start.sh`. This will submit the job under the iojs user. If the
job is already running, the `jenkins-start.sh` script will not start
another job.


### Install open source ecosystem
See http://ibm.biz/ibmi-rpms (see "Installation" section)

### Create Nodejs user
```
/QOpenSys/usr/bin/system -kpib 'CRTUSRPRF USRPRF(NODEJS) PASSWORD() USRCLS(*SECOFR) SPCAUT(*USRCLS) PWDEXPITV(*NOMAX)'
```
### Create Nodejs user's home directory
```
mkdir -p /home/NODEJS
chown -R nodejs /home/NODEJS
```

### Set global PATH and .bashrc to use Open Source Ecosystem
Edit `/QOpenSys/etc/profile` to contain:
```
PATH=/QOpenSys/pkgs/bin:$PATH
export PATH
```
This can be done by running the following commands from a shell:
```
echo 'PATH=/QOpenSys/pkgs/bin:$PATH' >> /QOpenSys/etc/profile
echo 'export PATH' >> /QOpenSys/etc/profile
```
After that is completed, copy to the `.bashrc` file for the nodejs user
`cp /QOpenSys/etc/profile /home/NODEJS/.bashrc`

### Use bash as the default shell for your user (maintainer convenience) and the nodejs user
```
/QOpenSys/pkgs/bin/yum install chsh
/QOpenSys/pkgs/bin/chsh -s /QOpenSys/pkgs/bin/bash
/QOpenSys/pkgs/bin/chsh -s /QOpenSys/pkgs/bin/bash nodejs
```

## z/OS

The system Java installed is too old to be able to verify the SSL certificate
for our Jenkins servers and a more recent version has to be installed manually.
The script used to start the Jenkins agent expects to find the Java SDK in
[`/u/unix1/java/J8.0_64/`](roles/jenkins-worker/vars/main.yml).

To install the Java SDK, obtain the latest Java 8 service refresh for z/OS from:
https://developer.ibm.com/javasdk/support/zos/

Transfer the pax.Z file to the z/OS system (via sftp, do not use scp as that
will perform an unwanted character conversion). Log into the z/OS system and
extract the SDK via the `pax` command:
e.g. if the pax.Z file is located in `/u/unix1/SDK8_64bit_SR6_FP10.PAX.Z`
```
mkdir -p /u/unix1/java
cd /u/unix1/java
pax -rf /u/unix1/SDK8_64bit_SR6_FP10.PAX.Z -ppx
```



[Setting up a Windows Host]: https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html
[newer Ansible configuration]: https://github.com/nodejs/build/tree/main/ansible
[stand-alone]: https://github.com/nodejs/build/tree/main/setup/windows
