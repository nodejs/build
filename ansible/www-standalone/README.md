# Node.js Website Setup

Intended to mirror the configuration of the nodejs.org primary web server.

* Not actively tested against the live server so may not be idempotent.
* The server contains significant state that it is essential to the live functioning of nodejs.org so this Ansible setup can't be used to setup a new site and it mirror the current nodejs.org state.
* Not integrated with the existing Build WG Ansible configuration (hence "standalone")
