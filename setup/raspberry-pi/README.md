# Node.js Raspberry Pi Cluster Setup

ssh config:

```
Host jump-nodejs-arm
  User jump
  HostName vagg-arm.nodejs.org
  Port 2222

Host iojs-ns-pi1p-1 release-nodesource_rvagg-debian7-arm_pi1p-1
  HostName 192.168.2.40
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi1p-2 release-nodesource_andineck-debian7-arm_pi1p-1
  HostName 192.168.2.41
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi1p-3 test-nodesource_andineck-debian7-arm_pi1p-1
  HostName 192.168.2.42
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi1p-4 test-nodesource_bengl-debian7-arm_pi1p-1
  HostName 192.168.2.43
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi1p-5 test-nodesource_bengl-debian7-arm_pi1p-2
  HostName 192.168.2.44
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi1p-6 test-nodesource_continuationlabs-debian7-arm_pi1p-1
  HostName 192.168.2.45
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi1p-7 test-nodesource_ceejbot-debian7-arm_pi1p-1
  HostName 192.168.2.46
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi1p-8 test-nodesource-mininodes-debian7-arm_pi1p-1
  HostName 192.168.2.47
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi1p-9 test-nodesource_indieisaconcept-debian7-arm_pi1p-1
  HostName 192.168.2.48
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi1p-10 test-nodesource_mhdawson-debian7-arm_pi1p-1
  HostName 192.168.2.49
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi1p-11 test-nodesource_securogroup-debian7-arm_pi1p-1
  HostName 192.168.2.50
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi1p-12 test-nodesource_securogroup-debian7-arm_pi1p-2
  HostName 192.168.2.51
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi

Host iojs-ns-pi2-1 test-nodesource_rvagg-debian7-arm_pi2-1
  HostName 192.168.2.60
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi2-2 test-nodesource_joeyvandijk-debian7-arm_pi2-1
  HostName 192.168.2.61
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi2-3 test-nodesource_joeyvandijk-debian7-arm_pi2-2
  HostName 192.168.2.62
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi2-4 test-nodesource_svincent-debian7-arm_pi2-1
  HostName 192.168.2.63
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi2-5 test-nodesource_mcollina-debian7-arm_pi2-1
  HostName 192.168.2.64
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi2-6 test-nodesource_ceejbot-debian7-arm_pi2-1
  HostName 192.168.2.65
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi2-7 test-nodesource_mininodes-debian7-arm_pi2-1
  HostName 192.168.2.66
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi2-8 test-nodesource_sambthompson-debian7-arm_pi2-1
  HostName 192.168.2.67
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi2-9 test-nodesource_louiscntr-debian7-arm_pi2-1
  HostName 192.168.2.68
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi2-10 test-nodesource_svincent-debian7-arm_pi2-2
  HostName 192.168.2.69
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi2-11 test-nodesource_svincent-debian7-arm_pi2-3
  HostName 192.168.2.70
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi2-12 test-nodesource_jasnell-debian7-arm_pi2-1
  HostName 192.168.2.71
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi

Host iojs-ns-pi3-1 test-nodesource_williamkapke-debian8-arm_pi3-1
  HostName 192.168.2.80
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi3-2 test-nodesource_williamkapke-debian8-arm_pi3-2
  HostName 192.168.2.81
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi3-3 test-nodesource_williamkapke-debian8-arm_pi3-3
  HostName 192.168.2.82
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi3-4 test-nodesource_davglass-debian8-arm_pi3-1
  HostName 192.168.2.83
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi3-5 test-nodesource_pivotalagency-debian8-arm_pi3-1
  HostName 192.168.2.84
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi3-6 test-nodesource_pivotalagency-debian8-arm_pi3-2
  HostName 192.168.2.85
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi3-7 test-nodesource_securogroup-debian8-arm_pi3-1
  HostName 192.168.2.86
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi3-8 test-nodesource_securogroup-debian8-arm_pi3-2
  HostName 192.168.2.87
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi3-9 test-nodesource_notthetup_sayanee-debian8-arm_pi3-1
  HostName 192.168.2.88
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi3-10 test-nodesource_piccoloaiutante-debian8-arm_pi3-1
  HostName 192.168.2.89
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
Host iojs-ns-pi3-11 test-nodesource_kahwee-debian8-arm_pi3-1
  HostName 192.168.2.90
  ProxyCommand ssh jump-nodejs-arm nc -q0 %h %p
  User pi
```

To set up a host, run:

```text
$ ansible-playbook -i ../ansible-inventory ansible-playbook.yaml
```

See the [manual setup instructions](../../docs/non-ansible-configuration-notes.md) for how to provision new hosts or reprovision existing hosts.