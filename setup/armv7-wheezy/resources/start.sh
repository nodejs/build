#!/bin/sh

rm -f nohup.out
ARCH=armv7l DESTCPU=arm PATH=/usr/lib/ccache/:$PATH JOBS=1 NODE_COMMON_PIPE=/home/iojs/test.pipe OSTYPE=linux-gnu nohup /usr/lib/jvm/java-7-openjdk-armhf/bin/java -jar slave.jar -jnlpUrl https://jenkins-iojs.nodesource.com/computer/nodejs-scaleway-armv7-wheezy-{{id}}/slave-agent.jnlp -secret {{secret}} &
