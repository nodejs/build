#!/bin/bash

extrahosts="iojs-ns-xgene-1 iojs-ns-xgene-2 iojs-ns-xgene-3 iojs-ns-xu3-1"
tgit=/tmp/git.$$
rm -rf $tgit
mkdir $tgit
git clone https://github.com/nodejs/node.git ${tgit}/io.js.reference --mirror # --reference ~/git/iojs/io.js
list="$(cat ansible-inventory | grep ^iojs-ns-pi) $extrahosts"
for host in $list; do
  echo "Updating ${host}..."
  rsync -avz --times --perms --delete --links $tgit/ iojs@${host}:git/
done
rm -rf $tgit
