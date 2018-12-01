#!/bin/bash

site=benchmarking
rsync_from=www/
clonedir=/home/www/github/${site}

if [ ! -d "${clonedir}" ]; then
  repo="${site}"
  git clone https://github.com/nodejs/${site}.git $clonedir
fi

cd $clonedir
git reset --hard
git clean -fdx
git fetch origin
git checkout origin/master

rsync -avz --delete --exclude charts/ ${clonedir}/${rsync_from} /home/www/${site}/
rsync -avz --delete benchmark:charts/ /home/www/${site}/charts/
