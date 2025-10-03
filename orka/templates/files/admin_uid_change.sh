#!/bin/bash
source /Users/admin/.zprofile
if [ $IMAGE_ARCHITECTURE = x64 ]; then
  echo "Re-numerating admin account. This takes a while to chmod"
  dscl . -change /Users/admin UniqueID 501 107
  time find /Users/admin -uid 501 -exec chown -h 107 {} \;
  dscl . create /Groups/ci
  dscl . create /Groups/ci gid 107
  dscl . create /Groups/ci passwd '*'
  dscl . create /Groups/ci GroupMembership admin
  echo "Finally done."
fi