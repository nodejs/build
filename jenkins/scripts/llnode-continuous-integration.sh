#!/bin/bash -ex

[ -z "$NODE_VERSION" ] &&
[ -z "$LLDB_VERSION" ] &&

rm -rf llnode npm

# Download node tarball.
bash -$- "$(dirname $0)"/common/getNode.sh ${NODE_VERSION:? Undefined.}

# Download lldb binary
bash -$- "$(dirname $0)"/common/getLLDB.sh ${LLDB_VERSION:? Undefined.}

export PATH="$PWD/node-bin/bin:$PATH"

[ -d "$PWD/llvm-bin/bin" ] && export PATH="$PWD/llvm-bin/bin:$PATH"

export npm_config_userconfig="$PWD"/npm/npmrc
mkdir -p npm/{cache,devdir,tmp}

cat <<!!EOF >npm/npmrc
tmpdir=$PWD/npm/tmp
cache=$PWD/npm/cache
devdir=$PWD/npm/devdir
loglevel=error
progress=false
!!EOF

node -v
npm -v
ls

git clone --depth=1 -b ${GIT_BRANCH:?Undefined.} https://github.com/${GIT_REPO:?Undefined.}.git llnode
cd llnode

npm install --nodedir=$(dirname $(dirname $(which node)))/include/node
npm test
