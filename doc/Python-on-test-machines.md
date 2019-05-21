# Python versions available on Node.js test machines

See [__find_pythons.sh__](#find_pythonssh) and [__find_pythons_on_test_hosts.py__](#find_pythons_on_test_hostspy) below to help in validating this data.

* Acceptable Python 2 is version __>= 2.7.9__
* Acceptable Python 3 is version __>= 3.5.0__
* Release candidate versions (like __2.7.15rc_1__) should be replaced with production versions

| Machine | Upgrade Needed? | Legacy Python | Python | Description |
| ------- | --------------- | ------------- | ------ | ----------- |
| test-azure_msft-ubuntu1404-x64-1 | Py2 & Py3 | 2.7.6 | 3.4.3 | 
| test-digitalocean-freebsd11-x64-1 | ??? |  |  | ssh: connect to host 45.55.90.237 port 22: Connection refused
| test-digitalocean-debian8-x64-1 | Python 3 | 2.7.9 | 3.4.2 | 
| test-digitalocean-debian9-x64-1 | | 2.7.13 | 3.5.3 | 
| test-digitalocean-fedora26-x64-1 | | 2.7.15 | 3.6.5 | 
| test-digitalocean-fedora27-x64-1 | | 2.7.15 | 3.6.6 |  | 
| test-digitalocean-freebsd10-x64-1 | | 2.7.15 | 3.6.7 | 
| test-macstadium-macos10.08-x64-1 | ??? |  |  | Network is unreachable
| test-digitalocean-freebsd11-x64-2 | | 2.7.16 | 3.6.8 | 
| test-macstadium-macos10.08-x64-2 | ??? |  |  | Network is unreachable
| test-macstadium-macos10.09-x64-1 | ??? |  |  | Network is unreachable
| test-digitalocean-ubuntu1404-x64-1 | Py2 & Py3 | 2.7.6 | 3.4.3 | 
| test-digitalocean-ubuntu1404-x86-1 | Py2 & Py3 | 2.7.6 | 3.4.3 | 
| test-digitalocean-ubuntu1604-x86-1 | | 2.7.12 | 3.5.2 | 
| test-digitalocean-ubuntu1604-x86-2 | | 2.7.12 | 3.5.2 | 
| test-digitalocean-ubuntu1604_docker-x64-1 | | 2.7.12 | 3.5.2 | 
| test-digitalocean-ubuntu1604_docker-x64-2 | | 2.7.12 | 3.5.2 | 
| test-digitalocean-ubuntu1804-x64-1 | Python 2 | 2.7.15rc1 | 3.6.7 | 
| test-joyent-freebsd10-x64-1 | | 2.7.15 | 3.6.7 | 
| test-joyent-freebsd10-x64-2 | | 2.7.15 | 3.6.7 | 
| test-macstadium-macos10.09-x64-2 | ??? |  |  | Network is unreachable
| test-macstadium-macos10.09-x64-2 | ??? |  |  | Network is unreachable
| test-macstadium-macos10.10-x64-1 | ??? |  |  | Network is unreachable
| test-macstadium-macos10.10-x64-2 | ??? |  |  | Network is unreachable
| test-macstadium-macos10.11-x64-1 | ??? |  |  | Network is unreachable
| test-macstadium-macos10.11-x64-2 | ??? |  |  | Network is unreachable
| test-macstadium-macos10.12-x64-1 | ??? |  |  | Network is unreachable
| test-macstadium-macos10.12-x64-2 | ??? |  |  | Network is unreachable
| test-mininodes-ubuntu1604-arm64_odroid_c2-1 | ??? |  |  | Key didn't work
| test-mininodes-ubuntu1604-arm64_odroid_c2-2 | ??? |  |  | Key didn't work
| test-joyent-ubuntu1604_arm_cross-x64-1 | | 2.7.12 | 3.5.2 | 
| test-joyent-ubuntu1604_docker-x64-1 | | 2.7.12 | 3.5.2 | 
| test-joyent-ubuntu1804-x64-1 | Python 2 | 2.7.15rc1 | 3.6.7 | 
| test-mininodes-ubuntu1604-arm64_odroid_c2-3 | ??? |  |  | Key didn't work
| test-digitalocean-centos5-x86-1 | Py2 & Py3 | 2.6.8 | None | `yum search python3` failed with `M2Crypto.SSL.SSLError: tlsv1 alert protocol version`
| test-digitalocean-ubuntu1204-x64-1 | Python 3 | 2.7.3 | None | `apt-get -s install python3` shows python3.2 is available
| test-digitalocean-ubuntu1204-x64-2 | Python 3 | 2.7.3 | None | `apt-get -s install python3` shows python3.2 is available
| test-joyent-smartos14-x64-1 | Python 3 | 2.7.9 | None | `pkgin av \| grep -i python3` shows both 3.3 and 3.4 are available
| test-joyent-smartos14-x64-2 | Python 3 | 2.7.9 | None | `pkgin av \| grep -i python3` shows both 3.3 and 3.4 are available
| test-joyent-smartos14-x86-1 | Python 3 | 2.7.9 | None | `pkgin av \| grep -i python3` shows both 3.3 and 3.4 are available
| test-joyent-smartos14-x86-2 | Python 3 | 2.7.9 | None | `pkgin av \| grep -i python3` shows both 3.3 and 3.4 are available
| test-joyent-smartos15-x64-1 | Python 3 | 2.7.11 | None | "`pkgin av \| grep -i python3` shows 3.3, 3.4, and 3.5 are available | "
| test-joyent-smartos15-x64-2 | Python 3 | 2.7.11 | None | "`pkgin av \| grep -i python3` shows 3.3, 3.4, and 3.5 are available | "
| test-joyent-smartos16-x64-1 | Python 3 | 2.7.11 | None | "`pkgin av \| grep -i python3` shows 3.3, 3.4, and 3.5 are available | "
| test-joyent-smartos16-x64-2 | Python 3 | 2.7.11 | None | "`pkgin av \| grep -i python3` shows 3.3, 3.4, and 3.5 are available | "
| test-joyent-smartos17-x64-1 | Python 3 | 2.7.14 | None | `pkgin av \| grep -i python3` shows 3.4, 3.5, and 3.6 are available        
| test-joyent-smartos17-x64-2 | Python 3 | 2.7.14 | None | `pkgin av \| grep -i python3` shows 3.4, 3.5, and 3.6 are available        
| test-linuxonecc-rhel72-s390x-1 | Py2 & Py3 | 2.7.5 | None | Might have to check SCL
| test-linuxonecc-rhel72-s390x-2 | Py2 & Py3 | 2.7.5 | None | Might have to check SCL
| test-linuxonecc-rhel72-s390x-3 | Py2 & Py3 | 2.7.5 | None | Might have to check SCL
| test-marist-zos13-s390x-1 | Python 3 | 2.7.13 | None | 
| test-marist-zos13-s390x-2 | Python 3 | 2.7.13 | None | 
| test-nearform_intel-ubuntu1604-x64-1 | | 2.7.12 | 3.5.2 | 
| test-nearform_intel-ubuntu1604-x64-2 | | 2.7.12 | 3.5.2 | 
| test-osuosl-aix61-ppc64_be-1 | Python 3 | 2.7.11 | None | @sam-github has ideas on these...
| test-osuosl-aix61-ppc64_be-2 | | 2.7.11 | 3.7.3 | https://github.com/nodejs/build/issues/1775#issuecomment-492803274
| test-osuosl-aix61-ppc64_be-3 | Python 3 | 2.7.11 | None | ...three
| test-osuosl-centos7-ppc64_le-1 | Python 2 | 2.7.5 | 3.6.8 | https://github.com/nodejs/build/issues/1674
| test-osuosl-centos7-ppc64_le-2 | Python 2 | 2.7.5 | 3.6.8 | https://github.com/nodejs/build/issues/1674
| test-osuosl-ubuntu1404-ppc64_be-1 | Py2 & Py3 | 2.7.6 | 3.4.3 | 
| test-osuosl-ubuntu1404-ppc64_be-2 | Py2 & Py3 | 2.7.6 | 3.4.3 | 
| test-osuosl-ubuntu1404-ppc64_le-1 | Py2 & Py3 | 2.7.6 | 3.4.3 | 
| test-osuosl-ubuntu1404-ppc64_le-2 | Py2 & Py3 | 2.7.6 | 3.4.3 | 
| test-osuosl-ubuntu1404-ppc64_le-4 | Py2 & Py3 | 2.7.6 | 3.4.3 | 
| test-packetnet-centos7-arm64-1 | Py2 & Py3 | 2.7.5 | None | `yum search python3` shows Python 36
| test-packetnet-centos7-arm64-2 | Py2 & Py3 | 2.7.5 | None | `yum search python3` shows Python 36
| test-packetnet-ubuntu1604-arm64-1 | | 2.7.12 | 3.5.2 | 
| test-packetnet-ubuntu1604-arm64-2 | | 2.7.12 | 3.5.2 | 
| test-packetnet-ubuntu1604-x64-1 | | 2.7.12 | 3.5.2 | 
| test-packetnet-ubuntu1604-x64-2 | | 2.7.12 | 3.5.2 | 
| test-rackspace-centos7-x64-1 | Py2 & Py3 | 2.7.5 | None | `yum search python3` shows Python 36
| test-rackspace-debian8-x64-1 | Python 3 | 2.7.9 | 3.4.3 | 
| test-rackspace-debian8-x64-2 | Python 3| 2.7.9 | 3.4.2 | 
| test-rackspace-fedora26-x64-1 | | 2.7.14 | 3.6.4 | 
| test-rackspace-fedora27-x64-1 | | 2.7.14 | 3.6.4 | 
| test-rackspace-freebsd10-x64-1 | | 2.7.15 | 3.6.7 | 
| test-rackspace-ubuntu1204-x64-1 | Py2 & Py3 | 2.7.3 | None | `apt-cache search python3` shows Python 3.2 Debug build
| test-rackspace-ubuntu1604-x64-1 | Python 3 | 2.7.12 | 3.5.2 | 
| test-rackspace-ubuntu1604-x64-2 | Python 3 | 2.7.12 | 3.5.2 | 
| test-scaleway-ubuntu1604-armv7l-1 | | 2.7.12 | 3.5.2 | 
| test-scaleway-ubuntu1604-armv7l-2 | | 2.7.12 | 3.5.2 | 
| test-scaleway-ubuntu1604-armv7l-3 | | 2.7.12 | 3.5.2 | 
| test-softlayer-centos5-x64-1 | Py2 & Py3 | 2.4.3 | None | `yum search python3` does not have anything
| test-softlayer-centos5-x64-2 | Py2 & Py3 | 2.4.3 | None | `yum search python3` does not have anything
| test-softlayer-centos6-x64-1 | Py2 & Py3 | 2.6.6 | None | `yum search python3` shows Python 36
| test-softlayer-centos6-x64-2 | Py2 & Py3 | 2.6.6 | None | `yum search python3` shows Python 36
| test-softlayer-centos7-x64-1 | Python 3 | 2.7.5 | None | `yum search python3` shows Python 36
| test-softlayer-debian8-x86-1 | Python 3 | 2.7.9 | 3.4.2 | 
| test-softlayer-debian9-x64-1 | | 2.7.13 | 3.5.3 | 
| test-softlayer-ubuntu1404-x64-1 | Py2 & Py3 | 2.7.6 | 3.4.3 | 
| test-softlayer-ubuntu1404-x86-1 | Py2 & Py3 | 2.7.6 | 3.4.3 | 
| test-softlayer-ubuntu1604-x64-1 | | 2.7.12 | 3.5.2 | 
| test-softlayer-ubuntu1604-docker-x64-1 | | 2.7.12 | 3.5.2 |


### find_pythons.sh
```sh
#!/bin/sh

echo "$0: $1"
ssh $1 "which python ; python --version" || true
ssh $1 "which python2 ; python2 --version" || true
ssh $1 "which python3 ; python3 --version" || true
ssh $1 "which pyenv ; pyenv --version" || true
```
### find_pythons_on_test_hosts.py
```python
#!/usr/bin/env python3

"""
This Python script will generate a shell script that will run
find_pythons.sh on each host in the table above.
"""

with open("Python-on-test-machines.md") as in_file:
    hosts = [
        line.split("|")[1].strip()  # host is first table element
        for line in in_file.readlines()
        if line.startswith("|")  # only lines containing table rows
    ]
fmt = "find_pythons.sh {} || true"  # swallow any errors
print("\n".join(fmt.format(host) for host in hosts[2:]))  # [2:] drops the headers
print("")
```
