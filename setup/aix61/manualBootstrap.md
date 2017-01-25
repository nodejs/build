NOTE: dependencies on AIX seem to make it hard to get the order correct
so the scripts install-xxx.sh currently need to be run more than
once and after some small number of runs (2-3) all of the required
modules will be installed.


## Increase the size of the /opt filesystem

```bash
chfs -a size=+1300000 /opt
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
export LIBPATH=/usr/lib # Needed to get curl to work
```

#### gcc

Download and scp to the machine:
http://www.bullfreeware.com/affichage.php?id=2378

```bash
gcc-c++-4.8.5-1.aix6.1.ppc.rpm-with-deps.zip
unzip gcc-c++-4.8.5-1.aix6.1.ppc.rpm-with-deps.zip
sh install-gcc-rpm.sh
```

#### git

```bash
curl --insecure -O https://public.dhe.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/git/git-2.8.1-1.aix6.1.ppc.rpm
rpm -ivh git-2.8.1-1.aix6.1.ppc.rpm
```

#### openssl, openssh

Download and scp to the machine:
https://www-01.ibm.com/marketing/iwm/iwm/web/reg/pick.do?source=aixbp&lang=en_US

```bash
# Copy into directory fixup
cd fixup
tar -xvf OpenSSH_6.0.0.6202.tar.Z
tar -xvf openssl-1.0.2.800.tar.Z
# Copy contents of OpenSSH_6.0.0.6202  openssl-1.0.2.800 to fixup dir.
inutoc .

emgr -r -L IV80743m9a  (if necessary)
emgr -r -L IV83169m9a  (if necessary)

installp -Y -qaXgd . openssl openssh
```

#### gettext, java, make

```bash
curl --insecure -O https://public.dhe.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/gettext/gettext-0.19.7-1.aix6.1.ppc.rpm
rpm -e gettext
rpm -hUv gettext-0.19.7-1.aix6.1.ppc.rpm

Java7r1_64.jre.7.1.0.200.tar.gz
gunzip Java7r1_64.jre.7.1.0.200.tar.gz
tar -xvf Java7r1_64.jre.7.1.0.200.tar
installp -agXYd . Java71_64.jre 2>&1 | tee installp.log

curl --insecure -O http://www.oss4aix.org/download/everything/RPMS/make-3.82-1.aix5.3.ppc.rpm
rpm -i make-3.82-1.aix5.3.ppc.rpm
```

#### libtool

Download and scp to the machine:
http://www.bullfreeware.com/affichage.php?id=1458#
http://www.bullfreeware.com/affichage.php?id=2048

```bash
unzip 3149libtool-2.2.7b-1.aix6.1.ppc.rpm-with-deps
m4-1.4.17-1.aix6.1.ppc.rpm
sh install-libtool-rpm.sh
```

#### pip

```bash
curl https://bootstrap.pypa.io/get-pip.py | python
ln -s /opt/freeware/bin/pip /usr/bin/pip
```

## Install ccache

Install ccache based on these instructions ./setup/ansible-tasks/ccache.yaml,
we should update that script so that it can be used on AIX as well.
Install on the new linux machines did not seem to work so use cp and chmod instead.

```bash
mkdir tmp
cd tmp
curl --insecure -O https://www.samba.org/ftp/ccache/ccache-3.2.7.tar.gz
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
