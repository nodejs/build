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
* `git clone https://chromium.googlesource.com/external/gyp /Users/iojs/gyp`
* `git clone --mirror https://github.com/nodejs/node.git /Users/iojs/io.js.reference`
* For release machines:
  - Install PackageMaker, download "Auxiliary Tools for Xcode - Late July 2012" from the Apple Developer site to get it, put it in ~iojs/PackageMaker.app
  - Install Packages from http://s.sudre.free.fr/Software/Packages/about.html
  - Install Node.js Foundation code signing and package signing certificates
    * Available from either the secrets repository under "release" as a passwordless .p12 file
    * OS X 10.10: In Keychain Access, "Import Items" and add both the Installer and Application certificates to the "System" (not "login" which is default)
    * OS X 10.10: Find the private key for Node.js Foundation under System in Keychain Access, "Get Info" for it, switch to "Access Control" and allow access by all applications. This step requires a physical keyboard under El Capitan and onward.
    * Command line alternative (all OS X?): `sudo security import /path/to/id.p12 -k /Library/Keychains/System.keychain -T /usr/bin/codesign -T /usr/bin/productsign`
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
