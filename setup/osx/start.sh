#!/bin/sh

curl -O https://ci.nodejs.org/jnlpJars/slave.jar

SECRET=<INSERT SECRET>
SERVER_ID=<INSERT SERVER>
CI_SERVER=ci.nodejs.org

export JOBS=2
export NODE_COMMON_PIPE=/Users/iojs/test.pipe
export OSTYPE=osx

java -jar slave.jar -jnlpUrl https://${CI_SERVER}/computer/${SERVER_ID}/slave-agent.jnlp -secret $SECRET
