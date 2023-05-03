# Windows and Visual Studio versions supported for Node.js

**Notes:**
- The exact Windows builds and Visual Studio releases are not tracked. Assume the latest or a recent version at the time of each commit.
- Only 64 bit machines are available in the CI system. Thus, all 32 bit binaries are cross-compiled and tested on WoW64.

## For running Node.js

Supported versions for running the Node.js installer and executable as released.

| Node.js Version | Windows Version            |
|-----------------|----------------------------|
| v16             | 8.1 / 2012 R2              |
| v18             | 10 / 2016                  |
| v19             | 10 / 2016                  |
| v20             | 10 / 2016                  |

## For building Node.js Core

Supported versions for building Node.js from source.

| Node.js Version | Visual Studio Version               |
|-----------------|-------------------------------------|
| v16             | 2019 <sup>[1]</sup>                 |
| v18             | 2019                                |
| v19             | 2019                                |
| v20             | 2019                                |

## For building Node.js Addons

Supported versions for building Node.js addons. End-users should have one of these installed for building native modules.

| Node.js Version | Visual Studio Version                     |
|-----------------|-------------------------------------------|
| v16             | 2015, VCBT2015, 2017, 2019                |
| v18             | 2015, VCBT2015, 2017, 2019                |
| v19             | 2017, 2019 <sup>[2]</sup>                 |
| v20             | 2017, 2019 <sup>[2]</sup>                 |

## Official Releases

These versions are used to build the official releases.

| Node.js Version | Windows Version | Visual Studio Version |
|-----------------|-----------------|-----------------------|
| v16             | 2012 R2         | 2019                  |
| v18             | 2012 R2         | 2019                  |
| v19             | 2012 R2         | 2019                  |
| v20             | 2012 R2         | 2019                  |

## References

1. Support for Visual Studio 2017 was removed in v15.0.0.
   - Pull Request: https://github.com/nodejs/node/pull/33694
2. Support for building addons with Visual Studio 2015 was removed in v19.0.0.
   - Pull Request: https://github.com/nodejs/node-gyp/pull/2746
