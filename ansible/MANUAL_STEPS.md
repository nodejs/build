# Manual steps required to run ansible on machines

## RHEL7-S390X
1. V8 build-tools

Copy `/home/iojs/build-tools/{gn,ninja}` from any other RHEL7-S390X host that
has them to the newly provisioned one. Confirm `gn --version` is at least
`1620`.

If building from scratch, gn is built from  https://gn.googlesource.com/gn,
and ninja is built from https://github.com/ninja-build/ninja.

Note: If https://bugs.chromium.org/p/chromium/issues/detail?id=1029662 is
resolved this will no longer be necessary.

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

## AIX 7.2 Install

Most packages should be installed via ansible.

If there are any missing they should be installed via yum

What you do need to install manually is **ccache**


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




