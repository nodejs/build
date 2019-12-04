NOTE: dependencies on AIX seem to make it hard to get the order correct
so the scripts install-xxx.sh currently need to be run more than
once and after some small number of runs (2-3) all of the required
modules will be installed.


## Increase the size of the filesystems

```bash
chfs -a size=+1300000 /opt
chfs -a size=+250000 /
chfs -a size=+917504 /tmp
```

For the systems without ramdisks `/home` needs to be set to the same size as `/home/iojs/build` would be on a ramdisk machine

```bash
chfs -a size=23000000 /home
```

## Edit SSH config

Add the following two lines to `/etc/ssh/sshd_config`:

```
PasswordAuthentication no
ChallengeResponseAuthentication no
```

## Remove failedlogin file

If /etc/security/failedlogin is growing without bounds on AIX6.1, remove
it with a cron job, use `crontab -e`, and add one line:
```sh
0 12 * * * /usr/bin/rm -f /etc/security/failedlogin
```

## Fix "Missing" shared objects

On the 7.1 machines we were facing this issues when yum installed packages were not able to find some of the shared objects they needed

```sh
bash-5.0$ gmake -v
exec(): 0509-036 Cannot load program gmake because of the following errors:
        0509-022 Cannot load module /opt/freeware/lib/libintl.a(libintl.so.8).
        0509-150   Dependent module /usr/lib/libiconv.a(libiconv.so.2) could not be loaded.
        0509-152   Member libiconv.so.2 is not found in archive
        0509-022 Cannot load module make_64.
        0509-150   Dependent module /opt/freeware/lib/libintl.a(libintl.so.8) could not be loaded.
        0509-022 Cannot load module .
```

The fix is as following:

```sh
sudo rm /usr/lib/libiconv.a && sudo ln -s /opt/freeware/bin/libiconv.a /usr/lib
```

# AIX 7.2 Install

Most packages should be installed via ansible.

If there are any missing they should be installed via yum

What you do need to install manually is **gcc** and **ccache**

## gcc 6.3.x on AIX 7.2

```bash
mkdir -p /opt/gcc-6.3 && cd /opt/gcc-6.3
curl -L https://ci.nodejs.org/downloads/aix/gcc-6.3-aix7.2.ppc.tar.gz | /opt/freeware/bin/tar -xzf -
```

## ccache 3.7.4 on AIX 7.2

```bash
mkdir -p /opt/ccache-3.7.4 && cd /opt/ccache-3.7.4
curl -L https://ci.nodejs.org/downloads/aix/ccache-3.7.4.aix7.2.ppc.tar.gz | /opt/freeware/bin/tar -xzf -
```
## Enable the AHA fs

For AIX 7.2 and 6.1, needed for the file watcher unit tests.

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

## Install XL compilers

1. Download 16.1.0 packages from: https://testcase.boulder.ibm.com (username:
   xlcomp4, password: ask @mhdawson)
2. scp them to target:/opt/ibm-xlc
3. on target:
```bash
cd /opt/ibm-xlc
uncompress 16.1.0.3-IBM-xlCcmp-AIX-FP003.tar.Z
uncompress IBM_XL_C_CPP_V16.1.0.0_AIX.tar.Z
installp -aXYgd ./usr/sys/inst.images -e /tmp/install.log all
inutoc
installp -aXgd ./ -e /tmp/install.log all
```
4. Find compilers in `/opt/IBM/xl[cC]/16.1.0/bin/`



#### tap2junit

Should be installed via ansible but if needed to be done manually use the following:

AIX72:
```
  python  -m pip install --upgrade pip pipenv git+https://github.com/nodejs/tap2junit
  python3 -m pip install --upgrade pip pipenv git+https://github.com/nodejs/tap2junit
  ln -s /opt/freeware/bin/tap2junit /usr/bin/tap2junit
```

Note: probably only the py3 was needed

```bash
python -m pip install --upgrade pip pipenv git+https://github.com/nodejs/tap2junit.git
ln -s /opt/freeware/bin/tap2junit /usr/bin/tap2junit
```


# AIX 6.1 Install

## Install required packages


#### curl, unzip

Download and scp to the machine:
ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/curl/curl-7.44.0-2.aix6.1.ppc.rpm
ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/unzip/unzip-6.0-3.aix6.1.ppc.rpm

```bash
rpm -e git  # If necessary
rpm -e curl # If necessary
rpm -ivh curl-7.44.0-2.aix6.1.ppc.rpm
rpm -i unzip-6.0-3.aix6.1.ppc.rpm
```

#### gcc 4.8.5 on AIX6.1

Download and scp to the machine:
http://www.bullfreeware.com/affichage.php?id=2378

Note that install-gcc-rpm.sh is in setup/aix61/resources

```bash
mkdir gcc
cd gcc
LIBPATH=/usr/lib curl -L --insecure -O https://ci.nodejs.org/downloads/aix/gcc-c++-4.8.5-1.aix6.1.ppc.rpm-with-deps.zip
unzip gcc-c++-4.8.5-1.aix6.1.ppc.rpm-with-deps.zip
sh install-gcc-rpm.sh

# Cleanup
cd ../
rm -rf gcc
```

#### git-tools

```bash
mkdir git-tools
cd git-tools
LIBPATH=/usr/lib curl -L --insecure -O https://ci.nodejs.org/downloads/aix/git-1.8.3.1-3.aix6.1.ppc.rpm-with-deps.zip
unzip git-1.8.3.1-3.aix6.1.ppc.rpm-with-deps.zip
sh install-git-tools-rpm.sh

# Cleanup
cd ../
rm -rf git-tools
```

#### git

```bash
LIBPATH=/usr/lib curl --insecure -O https://ci.nodejs.org/downloads/aix/git-2.8.1-1.aix6.1.ppc.rpm
rpm -ivh git-2.8.1-1.aix6.1.ppc.rpm --force
```

#### openssl, openssh


Download and scp to the machine:
https://www-01.ibm.com/marketing/iwm/iwm/web/reg/pick.do?source=aixbp&lang=en_US

```bash
LIBPATH=/usr/lib curl --insecure -O https://ci.nodejs.org/downloads/aix/OpenSSH_6.0.0.6202.tar.Z
LIBPATH=/usr/lib curl --insecure -O https://ci.nodejs.org/downloads/aix/openssl-1.0.2.800.tar.Z
tar -xvf OpenSSH_6.0.0.6202.tar.Z
tar -xvf openssl-1.0.2.800.tar.Z

# Copy contents of OpenSSH_6.0.0.6202  openssl-1.0.2.800 to fixup dir.
mkdir fixup
cp -r OpenSSH_6.0.0.6202/* fixup/
cp -r openssl-1.0.2.800/* fixup/
cd fixup

inutoc .

emgr -r -L IV80743m9a  # (if necessary)
emgr -r -L IV83169m9a  # (if necessary)

installp -Y -qaXgd . openssl openssh
```

#### gettext, java, make


```bash
LIBPATH=/usr/lib curl --insecure -O https://public.dhe.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/gettext/gettext-0.19.7-1.aix6.1.ppc.rpm
rpm -e gettext
rpm -hUv gettext-0.19.7-1.aix6.1.ppc.rpm

LIBPATH=/usr/lib curl -L --insecure -O https://ci.nodejs.org/downloads/aix/j864redist.tar.gz
gunzip -d j864redist.tar.gz
tar -xf j864redist.tar

LIBPATH=/usr/lib curl --insecure -O http://www.oss4aix.org/download/everything/RPMS/make-3.82-1.aix5.3.ppc.rpm
rpm -i make-3.82-1.aix5.3.ppc.rpm
```

#### libtool


Download and scp to the machine:
http://www.bullfreeware.com/affichage.php?id=1458#
http://www.bullfreeware.com/affichage.php?id=2048

```bash
mkdir libtool
cd libtool
LIBPATH=/usr/lib curl -L --insecure -O https://ci.nodejs.org/downloads/aix/3149libtool-2.2.7b-1.aix6.1.ppc.rpm-with-deps.zip
unzip 3149libtool-2.2.7b-1.aix6.1.ppc.rpm-with-deps

LIBPATH=/usr/lib curl -L --insecure -O https://ci.nodejs.org/downloads/aix/m4-1.4.17-1.aix6.1.ppc.rpm

sh install-libtool-rpm.sh

# Cleanup
cd ../
rm -rf libtool
```

#### pip

```bash
LIBPATH=/usr/lib curl https://bootstrap.pypa.io/get-pip.py | python
ln -s /opt/freeware/bin/pip /usr/bin/pip
```



## Install ccache


  The right way to do this is not with CC and CXX that have ccache in them,
  but by making sure that ccache is first in the path, and that following it
  in the PATH is the location of the selected compiler

Install ccache based on these instructions ./setup/ansible-tasks/ccache.yaml,
we should update that script so that it can be used on AIX as well.
Install on the new linux machines did not seem to work so use cp and chmod instead.

```bash
mkdir tmp
cd tmp
LIBPATH=/usr/lib curl --insecure -O https://www.samba.org/ftp/ccache/ccache-3.2.7.tar.gz
gunzip ccache-3.2.7.tar.gz
tar -xvf ccache-3.2.7.tar
cd ccache-3.2.7
./configure
gmake
mkdir /opt/freeware/bin/ccache
cp ccache /opt/freeware/bin/ccache/
chmod 755 /opt/freeware/bin/ccache/ccache

ln -s /opt/freeware/bin/ccache/ccache /opt/freeware/bin/ccache/cc
ln -s /opt/freeware/bin/ccache/ccache /opt/freeware/bin/ccache/g++
ln -s /opt/freeware/bin/ccache/ccache /opt/freeware/bin/ccache/gcc
cd ../..
rm -rf tmp
```

## Add ::1 to /etc/hosts


```bash
echo "::1 localhost" >>/etc/hosts
```

## Enable the AHA fs

For AIX 7.2 and 6.1, needed for the file watcher unit tests.

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

AIX72: did not do ioo, not clear if it is needed, and looks like it would get
lost on reboot.

We also apply a disk IO optimization which instructs AIX to start writing dirty
pages earlier and not wait for the sync demon:

```bash
ioo -o j2_maxRandomWrite=32
```

## gcc 6.3.x on AIX 6.1

```bash
su - iojs
cd /home/iojs

LIBPATH=/usr/lib curl -L --insecure -O https://ci.nodejs.org/downloads/aix/V2-gcc-6.3.0-1.tar.gz
gunzip -d V2-gcc-6.3.0-1.tar.gz
tar -xf V2-gcc-6.3.0-1.tar

LIBPATH=/usr/lib curl -L --insecure -O https://ci.nodejs.org/downloads/aix/gmake-dep.tar.gz
gunzip -d gmake-dep.tar.gz
tar -xf gmake-dep.tar
```


## Install python3

AIX72: uneeded, installed by yum

```bash
mkdir /tmp/i-files
cd /tmp/i-files
LIBPATH=/usr/lib curl -L --insecure -O https://ci.nodejs.org/downloads/aix/aixtools.python3.3.7.3.0.I
installp -d /tmp/i-files -L
installp -d /tmp/i-files -a aixtools.python3
```

Repeat the __pip__ and __tap2junit__ steps above but substitute __python3__ in the commands in place of
__python__.  This is required because Python 2 and Python 3 have separate site-packages so that modules
installed on one are not automatically available on the other.

The archive was originally from http://www.aixtools.net/index.php/python3

Installation is into `/opt/bin`.

If uninstallation is needed for some reason, the command is:
```
installp -u aixtools.python3
```

## Install XL compilers

1. Download 16.1.0 packages from: https://testcase.boulder.ibm.com (username:
   xlcomp4, password: ask @mhdawson)
2. scp them to target:/opt/ibm-xlc
3. on target:
```bash
cd /opt/ibm-xlc
uncompress 16.1.0.3-IBM-xlCcmp-AIX-FP003.tar.Z
uncompress IBM_XL_C_CPP_V16.1.0.0_AIX.tar.Z
installp -aXYgd ./usr/sys/inst.images -e /tmp/install.log all
inutoc
installp -aXgd ./ -e /tmp/install.log all
```
4. Find compilers in `/opt/IBM/xl[cC]/16.1.0/bin/`


# Final setup steps

## Setup ramdisks

TODO(sam-github): use the rc script from AIX7.2

Clear old state, if its not a fresh install:
```
mv /home/iojs/build/tools /home/iojs/build.tools

umount /home/iojs/build
umount /ramdisk0

rmramdisk rramdisk0
rmramdisk rramdisk1

# ls -l /dev/ramdisk*
ls: 0653-341 The file /dev/ramdisk* does not exist.
```

Create and mount new ramdisks:
```
# mkramdisk 10000000
/dev/rramdisk0
# mkfs -V jfs2 -o log=INLINE /dev/ramdisk0
mkfs: destroy /dev/ramdisk0 (yes)? y
logform: Format inline log for  <y>?
File system created successfully.
4979164 kilobytes total disk space.
Device /dev/ramdisk0:
  Standard empty filesystem
  Size:           9958328 512-byte (DEVBLKSIZE) blocks
# mount -V jfs2 -o log=/dev/ramdisk0 /dev/ramdisk0 /ramdisk0
# chown iojs:staff /ramdisk0/
# mkramdisk 23000000
/dev/rramdisk1
# mkfs -V jfs2 -o log=INLINE /dev/ramdisk1
mkfs: destroy /dev/ramdisk1 (yes)?
logform: Format inline log for  <y>?
File system created successfully.
11454388 kilobytes total disk space.
Device /dev/ramdisk1:
  Standard empty filesystem
  Size:           22908776 512-byte (DEVBLKSIZE) blocks
# mount -V jfs2 -o log=/dev/ramdisk1 /dev/ramdisk1 /home/iojs/build
# chown iojs:staff /home/iojs/build
# ls -l /dev/*ramdisk*
brw-------    1 root     system       36,  0 Jun 18 12:13 /dev/ramdisk0
brw-------    1 root     system       36,  1 Jun 18 12:14 /dev/ramdisk1
crw-------    1 root     system       36,  0 Jun 18 12:13 /dev/rramdisk0
crw-------    1 root     system       36,  1 Jun 18 12:14 /dev/rramdisk1
# df | grep ram
/dev/ramdisk0   10000000   9956864    1%        4     1% /ramdisk0
/dev/ramdisk1   23000000  22905728    1%        4     1% /home/iojs/build
# mount | grep ram
         /dev/ramdisk0    /ramdisk0        jfs2   Jun 18 12:13 rw,log=/dev/ramdisk0
         /dev/ramdisk1    /home/iojs/build jfs2   Jun 18 12:14 rw,log=/dev/ramdisk1
```

AIX7.2: put below into /etc/rc.d/rc2.d/S19ramdisk:
```bash
#!/bin/ksh

##################################################
# name: S19ramdisk
# purpose: script to create and mount ramdisks
##################################################


case "$1" in
start )
        mkramdisk 10000000
        echo yes | mkfs -V jfs2 -o log=INLINE /dev/ramdisk0
        mount -V jfs2 -o log=/dev/ramdisk0 /dev/ramdisk0 /ramdisk0
        chown iojs:staff /ramdisk0/
        mkramdisk 23000000
        echo yes | mkfs -V jfs2 -o log=INLINE /dev/ramdisk1
        mount -V jfs2 -o log=/dev/ramdisk1 /dev/ramdisk1 /home/iojs/build
        chown iojs:staff /home/iojs/build
        ;;
stop )
        ;;
* )
        echo "Usage: $0 (start | stop)"
        exit 1
esac
```

TODO(sam-github): use ansible to install the rc script

## Run ansible script to complete base configuration

See [the README](./README.md) for instructions

## Edit /etc/inetd.conf

AIX72: unneeded

Comment out default inbound services such as TELNET, FTP, RLOGIN, TALK etc. and
then reload the configuration with:

```bash
refresh -s inetd
```

The only remaining services should be:

```
daytime stream  tcp     nowait  root    internal
time    stream  tcp     nowait  root    internal
daytime dgram   udp     wait    root    internal
time    dgram   udp     wait    root    internal
caa_cfg stream  tcp6    nowait  root    /usr/sbin/clusterconf clusterconf >>/var/adm/ras/clusterconf.log 2>&1
wsmserver       stream  tcp     nowait  root    /usr/websm/bin/wsmserver wsmserver -start
xmquery dgram   udp6    wait    root    /usr/bin/xmtopas xmtopas -p3
```
