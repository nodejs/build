# Node.js Build OS X Setup

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

## Configuration

Required steps:

* Create user `iojs`
* `xcode-select --install` to install XCode tools, or install from App Store
* Sun Java (JDK)
* `git clone http://git.chromium.org/external/gyp.git /Users/iojs/gyp`
* For release machines:
  - Install PackageMaker, download "Auxiliary Tools for Xcode - Late July 2012" from the Apple Developer site to get it
  - Install Packages from http://s.sudre.free.fr/Software/Packages/about.html
  - Install Node.js Foundation code signing and package signing tools, available from the Node.js Foundation Apple Developer account (shared org, you need to be a member), `/usr/bin/codesign` and `/usr/bin/productsign` need to be able to use the keys non-interactively, Keychain Access may be able to be used for this except on El Capitain where you'll have to pull your hair out for a few hours before figuring it out (note that Keychain Access won't accept user/password for some actions unless your keyboard is connected directly to the physical computer) [TODO: insert instructions for doing this on El Capitain and prior versions next time hair pulling is performed and the magical incantation is figured out].
* Install `start.sh` and `tunnel.sh` to `/Users/iojs`
* Install `org.nodejs.osx.jenkins.plist` and `org.nodejs.osx.tunnel.plist` to `/Library/LaunchDaemons`
* As root (or using `sudo`), run:
  - `launchctl load /Library/LaunchDaemons/org.nodejs.osx.tunnel.plist`
  - `launchctl load /Library/LaunchDaemons/org.nodejs.osx.jenkins.plist`
  - `launchctl start org.nodejs.osx.tunnel`
  - `launchctl start org.nodejs.osx.jenkins`

## Operating

The tunnel connects the machines to ci.nodejs.org for a local tunnel to handle HTTP proxying and a remote tunnel to allow external SSH connections. It should always be running.

The Jenkins process is managed by launched and should be automatically restarted when it dies. It can be manually started and stopped using:

* `launchctl stop org.nodejs.osx.jenkins`
* `launchctl start org.nodejs.osx.jenkins`
