#!/bin/sh

DISTRO=debian-stable  nohup \
  java -jar slave.jar -jnlpUrl https://jenkins-iojs.nodesource.com/computer/iojs-digitalocean-containers-debian+stable-{{id}}/slave-agent.jnlp  \
    -secret {{iojs-debian-stable-secret}} &
DISTRO=debian-testing nohup \
  java -jar slave.jar -jnlpUrl https://jenkins-iojs.nodesource.com/computer/iojs-digitalocean-containers-debian+testing-{{id}}/slave-agent.jnlp \
    -secret {{iojs-debian-testing-secret}} &

DISTRO=ubuntu-lucid   nohup \
  java -jar slave.jar -jnlpUrl https://jenkins-iojs.nodesource.com/computer/iojs-digitalocean-containers-ubuntu+lucid-{{id}}/slave-agent.jnlp   \
    -secret {{iojs-ubuntu-lucid-secret}} &
DISTRO=ubuntu-precise nohup \
  java -jar slave.jar -jnlpUrl https://jenkins-iojs.nodesource.com/computer/iojs-digitalocean-containers-ubuntu+precise-{{id}}/slave-agent.jnlp \
    -secret {{iojs-ubuntu-precise-secret}} &
DISTRO=ubuntu-trusty  nohup \
  java -jar slave.jar -jnlpUrl https://jenkins-iojs.nodesource.com/computer/iojs-digitalocean-containers-ubuntu+trusty-{{id}}/slave-agent.jnlp  \
    -secret {{iojs-ubuntu-trusty-secret}} &
