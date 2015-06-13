#!/bin/sh

rm -f nohup.out
ARCH={{server_arch}} DESTCPU=arm PATH=/usr/lib/ccache/:$PATH JOBS=1 NODE_COMMON_PIPE=/home/iojs/test.pipe OSTYPE=linux-gnu nohup java -jar slave.jar -jnlpUrl https://jenkins-iojs.nodesource.com/computer/iojs-nodesource-raspbian-wheezy-{{id}}/slave-agent.jnlp -secret {{secret}} &
