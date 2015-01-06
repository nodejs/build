#!/bin/sh

rm -f nohup.out
NODE_COMMON_PIPE=/home/iojs/test.pipe OSTYPE=linux-gnu nohup scl enable devtoolset-2 'java -jar slave.jar -jnlpUrl https://jenkins-iojs.nodesource.com/computer/iojs-digitalocean-centos6-64-{{id}}/slave-agent.jnlp -secret {{secret}}' &
