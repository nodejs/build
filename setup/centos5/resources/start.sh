#!/bin/sh

rm -f nohup.out
PATH=/home/iojs/bin:${PATH} NODE_COMMON_PIPE=/home/iojs/test.pipe OSTYPE=linux-gnu nohup scl enable devtoolset-2 'java -jar slave.jar -jnlpUrl https://ci.nodejs.org/computer/iojs-digitalocean-centos5-{{id}}/slave-agent.jnlp -secret {{secret}}' &
OSTYPE=linux-gnu nohup java -jar slave.jar -jnlpUrl https://ci.nodejs.org/computer/iojs-digitalocean-centos5-gcc41-{{gcc41_id}}/slave-agent.jnlp -secret {{gcc41_secret}} &
