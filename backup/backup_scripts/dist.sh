#!/usr/bin/env bash

ROOTDIR=/data/backup/static

rsync -az -e "ssh -i /root/.ssh/nodejs_build_backup" root@nodejs-www:/home/dist/nodejs/ $ROOTDIR/dist/nodejs/
rsync -az -e "ssh -i /root/.ssh/nodejs_build_backup" root@nodejs-www:/home/dist/iojs/ $ROOTDIR/dist/iojs/
rsync -az -e "ssh -i /root/.ssh/nodejs_build_backup" root@nodejs-www:/home/libuv/www/dist/ $ROOTDIR/dist/libuv/
