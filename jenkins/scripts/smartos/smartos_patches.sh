#!/opt/local/bin/bash

# Gather the patchfile
curl -sLO https://raw.githubusercontent.com/nodejs/build/main/jenkins/scripts/smartos/v8_sunos_madvise.patch

# Apply the patch.
patch -p1 v8 < v8_sunos_madvise.patch
