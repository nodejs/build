#!/bin/sh

REMOTE_PORT=3222
SSH_KEY=~/.ssh/ci-osx
REMOTE_HOST=ci.nodejs.org
PROXY_PORT=8118

ssh -C -N -o ServerAliveInterval=3 -R "*:${REMOTE_PORT}:localhost:22" -L "${PROXY_PORT}:localhost:${PROXY_PORT}" $REMOTE_HOST -l osx -i $SSH_KEY
sleep 10 # give the server a break before auto restart
