#!/bin/sh

rm -f nohup.out

ARCH={{server_arch}} \
DESTCPU=arm \
PATH=/usr/lib/ccache/:$PATH \
JOBS=1 \
NODE_COMMON_PIPE=/home/iojs/test.pipe \
OSTYPE=linux-gnu \
nohup java \
  -jar slave.jar \
  -jnlpUrl https://ci.nodejs.org/computer/node-nodesource-raspbian-wheezy-{{server_id}}-{{server_suffix}}/slave-agent.jnlp \
  -secret {{server_secret}} &
