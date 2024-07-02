#!/opt/local/bin/bash

# Gather the patchfile
curl -sLO https://raw.githubusercontent.com/nodejs/build/4e1c490eda807abf434cc10c04fbd7887978c19c/jenkins/scripts/smartos/v8_sunos_madvise.patch

# Apply the patch.
patch -p1 v8 < v8_sunos_madvise.patch
