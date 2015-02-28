#!/bin/sh

rm -f nohup.out
NODE_COMMON_PIPE=/home/iojs/test.pipe OSTYPE=smartos nohup java -jar slave.jar -jnlpUrl https://jenkins-iojs.nodesource.com/computer/iojs-digitalocean-smartos-{{id}}/slave-agent.jnlp -secret {{secret}} &