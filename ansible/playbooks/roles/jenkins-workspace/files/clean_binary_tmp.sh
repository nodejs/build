#!/bin/bash -ex

cd ~binary_tmp/binary_tmp.git
(echo; date) >> ~binary_tmp/clean_binary_tmp.log
du -sh ~binary_tmp/binary_tmp.git/ >> ~binary_tmp/clean_binary_tmp.log

git fetch origin +master:master

for b in $(git branch | sed /\*/d); do
  if [ -z "$(git log -1 --since='7 days ago' -s $b)" ]; then
    (git branch -D $b |& tee -a ~binary_tmp/clean_binary_tmp.log) || true
  fi
done

git prune

du -sh ~binary_tmp/binary_tmp.git/ >> ~binary_tmp/clean_binary_tmp.log
