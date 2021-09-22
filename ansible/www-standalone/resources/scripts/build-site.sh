#!/bin/bash

set -e

site=$1

if [ "X$site" != "Xiojs" ] && [ "X$site" != "Xnodejs" ]; then
  echo "Usage: build-site.sh < iojs | nodejs >"
  exit 1
fi

pidof -s -o '%PPID' -x $(basename $0) > /dev/null 2>&1 && \
  echo "$(basename $0) already running" && \
  exit 1

clonedir=/home/www/github/${site}

if [ ! -d "${clonedir}" ]; then
  repo="${site}.org"
  git clone https://github.com/nodejs/${repo}.git $clonedir
fi

if [ "$site" == "nodejs" ]; then
  build_cmd="npm run deploy"
  rsync_from="build/"
else
  build_cmd="node_modules/.bin/gulp build"
  rsync_from="public/"
fi

cd $clonedir
git reset --hard
git clean -fdx
git fetch origin
git checkout origin/main

nodeuid=$(grep ^nodejs: /etc/passwd | awk -F: '{print $3}')
nodegid=$(grep ^nodejs: /etc/passwd | awk -F: '{print $4}')

docker pull node:lts
docker run \
  --rm \
  -v ${clonedir}:/website/ \
  -v /home/nodejs/.npm:/npm/ \
  node:lts \
  bash -c " \
    apt-get update && apt-get install -y rsync && \
    addgroup nodejs --gid ${nodeuid} && \
    adduser nodejs --uid ${nodeuid} --gid ${nodegid} --gecos nodejs --disabled-password && \
    su nodejs -c ' \
      npm config set loglevel http && \
      npm config set cache /npm/ && \
      cd /website/ && \
      npm install --cache-min 1440 --production && \
      $build_cmd \
    ' \
  "

rsync -avz --delete --exclude .git ${clonedir}/${rsync_from} /home/www/${site}/

/home/nodejs/queue-cdn-purge.sh $site build-site
