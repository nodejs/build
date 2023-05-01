#!/bin/sh
# Build host file for parallel-ssh, they can be used like:
#     parallel-ssh -h arm64_pi3 gcc --version

set -e

mkdir -p hosts

# Ansible hosts look like:
#   Host some-thing-that-is-blue  alias
# Check that there are at least 3 "-" in the name to choose only ansible's
# machine names, and strip off the trailing alias.
egrep '^Host .*-.*-.*-.*' ~/.ssh/config | sed -e 's/^Host //' -e 's/ .*//' > hosts/all

# Add aliases for groups of hosts. Feel free to add more aliases as useful.
grep -- '-arm' hosts/all > hosts/arm
grep -- 'aix61-ppc64_be' hosts/all > hosts/aix61-ppc64_be
grep -- 'arm64_pi3' hosts/all > hosts/arm64_pi3
grep -- 'armv6l_pi1' hosts/all > hosts/armv6l_pi1
grep -- 'armv7l_pi2' hosts/all > hosts/armv7l_pi2
grep -- 'centos7-ppc64_le' hosts/all > hosts/centos7-ppc64_le
grep -- 'centos7-ppc64_le' hosts/all > hosts/centos7-ppc64_le
grep -- 'centos7' hosts/all > hosts/centos7
grep -- 'digitalocean' hosts/all > hosts/digitalocean
grep -- 'infra-' hosts/all > hosts/infra
grep -- 'joyent' hosts/all > hosts/joyent
grep -- 'release-' hosts/all > hosts/release
grep -- 'rhel7-s390x' hosts/all > hosts/rhel7-s390x
grep -- 'rhel7.*-s390x' hosts/all > hosts/rhel7x-s390x
grep -- 'smartos' hosts/all > hosts/smartos
grep -- 'softlayer' hosts/all > hosts/softlayer
grep -- 'test-' hosts/all > hosts/test
grep -- 'ubuntu1404-ppc64_be' hosts/all > hosts/ubuntu1404-ppc64_be
grep -- 'ubuntu1404-ppc64_le' hosts/all > hosts/ubuntu1404-ppc64_le
grep -- 'zos13' hosts/all > hosts/zos13

echo "Parallel SSH config files updated in ./hosts"
