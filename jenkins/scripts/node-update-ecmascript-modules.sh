# This script is run by the job:
# https://ci.nodejs.org/view/All/job/node-update-ecmascript-modules
# It mirrors the master branch from nodejs/node with nodejs/ecmascript-modules
# and then attempts to rebase the modules-lkgr branch on top of it.

cd node
git config --replace-all user.name "Node.js Jenkins CI"
git config --replace-all user.email ci@iojs.org

git reset --hard ecmascript-modules/modules-lkgr
get rebase origin/master

# Force-push to the ecmascript-modules repo as the nodejs-ci user if PUSH_TO_GITHUB set.
if [ "$PUSH_TO_GITHUB" = true ]; then
  ssh-agent sh -c "ssh-add $NODEJS_CI_SSH_KEY && git push ecmascript-modules origin/master:master && git push --force ecmascript-modules HEAD:modules-lkgr"
fi
