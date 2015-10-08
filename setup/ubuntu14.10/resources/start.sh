#!/bin/sh

rm -f nohup.out
NODE_COMMON_PIPE=/home/iojs/test.pipe OSTYPE=linux-gnu nohup java -jar slave.jar -jnlpUrl https://ci.nodejs.org/computer/iojs-digitalocean-ubuntu1410-{{id}}/slave-agent.jnlp -secret {{secret}} &