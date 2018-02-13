# This script is run by the job:
# https://ci.nodejs.org/view/All/job/node-update-v8-canary
# It takes node master, updates deps/v8 to V8 lkgr, adds node specific patches,
# and pushes to nodejs/node-v8#canary.

# Download the latest build from nodejs.org
rm -rf "$WORKSPACE"/node-*

# Download a node tarball from nodejs.org
NODE_VERSION=v8
DOWNLOAD_DIR="https://nodejs.org/download/release/"
LINK=`curl $DOWNLOAD_DIR | grep $NODE_VERSION | sort -t. -k 1,1n -k 2,2n -k 3,3n | tail -1 | cut -d\" -f 2 | tr -d /`
OS=linux; ARCH=x64; EXT=tar.gz

curl -O "$DOWNLOAD_DIR$LINK/node-$LINK-$OS-$ARCH.$EXT"
gzip -cd node-$LINK-$OS-$ARCH.$EXT | tar xf -

# Setup path and install targos's update-v8 npm module
cd node-*/bin && export PATH="$PWD:$PATH" && cd -
which node
node --version
npm install -g update-v8

cd node
git config --replace-all user.name "Node.js Jenkins CI"
git config --replace-all user.email ci@iojs.org
git reset --hard origin/master

# Update README.md with disclaimer for node-v8 repository
curl https://raw.githubusercontent.com/nodejs/node-v8/readme/README.md > README.md
git add README.md
git commit -m"doc: update README for node-v8 repository"

# Clones V8 into base-dir and updates to specified branch
update-v8 major --branch=lkgr --base-dir="$WORKSPACE" --node-dir="$WORKSPACE"/node

# Cancel any cherry-pick in progress from an earlier failed run
git cherry-pick --abort || true

# Cherry-pick the floating V8 patches Node maintains on master
# Canary-base is the last good version of canary, and is manually updated with any V8 patches or backports
git cherry-pick `git log origin/canary-base -1 --format=format:%H --grep "src: update NODE_MODULE_VERSION"`...origin/canary-base

# Force-push to the canary branch as the nodejs-ci user if PUSH_TO_GITHUB set.
if [ "$PUSH_TO_GITHUB" = true ]; then
  ssh-agent sh -c "ssh-add $NODEJS_CI_SSH_KEY && git push --force git@github.com:nodejs/node-v8.git HEAD:canary"
fi
