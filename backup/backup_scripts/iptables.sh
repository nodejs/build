#!/usr/bin/env bash
ssh -i /root/.ssh/nodejs_build_backup ci-release.nodejs.org "iptables-save | xz -c" > ci-release.nodejs.org.xz
ssh -i /root/.ssh/nodejs_build_backup ci.nodejs.org "iptables-save | xz -c" > ci.nodejs.org.xz
