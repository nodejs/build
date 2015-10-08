#!/bin/sh

rm -f nohup.out
PATH=/usr/lib/ccache:$PATH NODE_COMMON_PIPE=/home/iojs/test.pipe OSTYPE=linux-gnu nohup java -jar slave.jar -jnlpUrl https://ci.nodejs.org/computer/iojs-digitalocean-ubuntu1504-{{id}}/slave-agent.jnlp -secret {{secret}} &
