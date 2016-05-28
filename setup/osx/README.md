# Node.js Build OS X Setup

_Documentation pending ..._

Add this to your ssh config:

```text
Host release-voxer-osx1010-1
  User iojs
  HostName ci.nodejs.org
  Port 3222
  # IdentityFile nodejs_build_release
Host release-voxer-osx1010-2
  User iojs
  HostName ci.nodejs.org
  Port 3223
  # IdentityFile nodejs_build_release
Host test-voxer-osx1010-1
  User iojs
  HostName ci.nodejs.org
  Port 3224
  # IdentityFile nodejs_build_test
Host test-voxer-osx1010-2
  User iojs
  HostName ci.nodejs.org
  Port 3225
  # IdentityFile nodejs_build_test
```

The `start.sh` script starts and manages the slave process. `tunnel.sh` manages an outgoing HTTP proxy tunnel and incoming SSH and should always be running.
