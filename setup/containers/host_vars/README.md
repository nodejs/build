This directory should contain a file for each host being set up, where the files are named after the hostnames, e.g. `iojs-build-containers-1`. The files should contain the unique secrets provided by Jenkins for each of the build slaves on that server. There should be no duplicate secrets across the files.

Additionally the `server_id` entry should be a unique number for each server and match the ids set up on Jenkins, e.g. `iojs-digitalocean-containers-debian+stable-1` has an ID of `"1"`.

The file should look like this:

```
---
server_id: "X"
distributions:
  debian-stable:
    secret: "INSERT SECRET HERE"
  debian-testing:
    secret: "INSERT SECRET HERE"
  ubuntu-lucid:
    secret: "INSERT SECRET HERE"
  ubuntu-precise:
    secret: "INSERT SECRET HERE"
  ubuntu-trusty:
    secret: "INSERT SECRET HERE"
```
