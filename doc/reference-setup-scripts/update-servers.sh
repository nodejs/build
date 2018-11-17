#!/bin/sh

ansible -i ansible-inventory iojs-centos -m shell -a 'yum upgrade -y'
ansible -i ansible-inventory iojs-ubuntu -m shell -a 'pkill apt-get; apt-get update && apt-get upgrade -y && apt-get autoremove -y'
