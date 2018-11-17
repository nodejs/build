#!/bin/bash

extrahosts="iojs-ns-xgene-1 iojs-ns-xgene-2 iojs-ns-xgene-3 iojs-ns-xu3-1"
tgit=/tmp/node_git_mirror

if [ -d "$tgit/io.js.reference" ]; then
  (
    cd ${tgit}/io.js.reference
    git fetch origin
    GIT_SSH_COMMAND='ssh -i ~/.ssh/ci-iojs-org-id_rsa-github' git fetch node_binary_tmp
  )
else
  (
    mkdir $tgit
    git clone https://github.com/nodejs/node.git ${tgit}/io.js.reference --mirror
    cd ${tgit}/io.js.reference
    cat >> config << EOF
[remote "node_binary_tmp"]
        url = git@github.com:janeasystems/node_binary_tmp.git
	fetch = +refs/*:refs/*
	mirror = true
EOF
    GIT_SSH_COMMAND='ssh -i ~/.ssh/ci-iojs-org-id_rsa-github' git fetch node_binary_tmp
  )
fi

list="$(cat ansible-inventory | grep 'pi2\|pi1p') $extrahosts"
for host in $list; do
  echo "Updating ${host}..."
  rsync -avz --times --perms --delete --links $tgit/ iojs@${host}:git/
done
#rm -rf $tgit
