#!/bin/bash -ex

"$(dirname $0)"/common/getNode.sh # Load colors.

export UNZIP_DIR=`ls |grep "node" |grep -v "gz"`
cd $WORKSPACE/node-*/bin

export PATH=$PWD:$PATH
cd $WORKSPACE
export NPM_CONFIG_USERCONFIG=$WORKSPACE/npmrc
export NPM_CONFIG_CACHE=$WORKSPACE/npm-cache
node -v
npm -v
export npm_loglevel=error
npm set progress=false
ls
git clone https://github.com/$GIT_REPO.git llnode
cd llnode
if [ $GIT_BRANCH != master ]; then
	git fetch origin $GIT_BRANCH:testBranch
	git checkout testBranch
fi

[ $(uname) = Darwin ] && git clone --depth=1 -b release_39 https://github.com/llvm-mirror/lldb.git lldb
# Initialize GYP
git clone https://chromium.googlesource.com/external/gyp.git tools/gyp
# Configure
[ $(uname) = Linux ] && GYP_ARGS="-Dlldb_dir=/usr/lib/llvm-3.8/" || GYP_ARGS=""
./gyp_llnode $GYP_ARGS
# Build
make -C out/ -j9

npm install
npm test
