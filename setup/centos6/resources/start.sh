#!/bin/sh

rm -f nohup.out
NODE_COMMON_PIPE=/home/iojs/test.pipe OSTYPE=linux-gnu nohup scl enable devtoolset-2 'java -jar slave.jar -jnlpUrl https://ci.nodejs.org/computer/iojs-digitalocean-centos6-64-{{id}}/slave-agent.jnlp -secret {{secret}}' &
OSTYPE=linux-gnu nohup scl enable git19 'java -jar slave.jar -jnlpUrl https://ci.nodejs.org/computer/iojs-digitalocean-centos6-64-gcc44-{{gcc44_id}}/slave-agent.jnlp -secret {{gcc44_secret}}' &
