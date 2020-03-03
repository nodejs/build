# Non-Ansible Configuration Notes

There are a number of infrastructure setup tasks that are not currently automated by Ansible, either for technical reasons or due to lack of time available by the individuals involved in these processes. This document is intended to collect that information, to serve as a task list for additional Ansible work and as a central place to note special tasks.

## nodejs.org / web host

For dist.libuv.org we use letsencrypt.org for HTTPS certificate. Use Certbot to register and generate a certificate on the main nodejs.org server; only the single server serves dist.libuv.org so this configuration is simple. Certbot sets up auto-renewal for the certificate in /etc/cron.d/certbot.

```sh
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-nginx
certbot --nginx run -d dist.libuv.org -m build@iojs.org --agree-tos --no-redirect
certbot --nginx run -d iojs.org -m build@iojs.org --agree-tos --no-redirect
certbot --nginx run -d www.iojs.org -m build@iojs.org --agree-tos --no-redirect
certbot --nginx run -d roadmap.iojs.org -m build@iojs.org --agree-tos --no-redirect
```

## macOS release servers

Previous notes: [#1393](https://github.com/nodejs/build/issues/1393)

### Full Xcode

Xcode Command-line tools are not enough to perform a full notarization cycle, full Xcode must be installed manually.

As root:

* Download Xcode: https://developer.apple.com/download/more/ - find non-beta version, open Developer Tools in browser, Networking tab, start download (then cancel), in Networking tab "Copy as cURL" (available in Chrome & FF)
* Download onto release machine using the copied curl command (may need `-o xcode.xip` appended to curl command) to `/tmp`
* Extract: `xip --extract xcode.xip`
* Move `Xcode.app` directory to `/Applications`
* `xcode-select --switch /Applications/Xcode.app`
* `xcode-select -r` - accept license

### Signing certificates

* Extract from secrets/build/release: `dotgpg cat Apple\ Developer\ ID\ Node.js\ Foundation.p12.base64 | base64 -d > /tmp/Apple\ Developer\ ID\ Node.js\ Foundation.p12`
* Transfer to release machine (scp to /tmp)
* `sudo security import /tmp/Apple\ Developer\ ID\ Node.js\ Foundation.p12 -k /Library/Keychains/System.keychain -T /usr/bin/codesign -T /usr/bin/productsign -P 'XXXX'` (where XXXX is found in secrets/build/release/apple.md) (`security unlock-keychain -u /Library/Keychains/System.keychain` _may_ be required prior to running this command).

### SSH

(This step is identical for all release machines.)

As iojs:

* `mkdir .ssh`
* Add `.ssh/config`:

```
Host node-www
  HostName direct.nodejs.org
  User staging
  IdentityFile ~/.ssh/id_rsa
```

* Add `.ssh/id_rsa` with release SSH key.
* `chown 700 .ssh && chmod 600 .ssh/*`
* `ssh node-www` to set up known_hosts entry and check that it works
