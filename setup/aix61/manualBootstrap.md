NOTE: dependencies on AIX seem to make it hard to get the order correct
so the scripts install-xxx.sh currently need to be run more than
once and after some small number of runs (2-3) all of the required
modules will be installed.


## Increase the size of the /opt and / filesystems

```bash
chfs -a size=+1300000 /opt
chfs -a size=+250000 /
```

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

#### gcc

Download and scp to the machine:
http://www.bullfreeware.com/affichage.php?id=2378

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

#### tap2junit

```bash
python -m pip install --upgrade pip pipenv git+https://github.com/refack/tap2junit.git
ln -s /opt/freeware/bin/tap2junit /usr/bin/tap2junit
```

## Install ccache

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

We also apply a disk IO optimization which instructs AIX to start writing dirty
pages earlier and not wait for the sync demon:

```bash
ioo -o j2_maxRandomWrite=32
```

## Run ansible script to complete base configuration

See [the README](./README.md) for instructions

## Edit /etc/inetd.conf

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


## Install the 6.3.x compiler

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
