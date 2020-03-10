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
