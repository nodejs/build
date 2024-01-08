# Windows and Visual Studio versions supported for Node.js

**Notes:**
- The exact Windows builds and Visual Studio releases are not tracked. Assume the latest or a recent version at the time of each commit.
- Only 64 bit machines are available in the CI system. Thus, all 32 bit binaries are cross-compiled and tested on WoW64.

## For running Node.js

Supported versions for running the Node.js installer and executable as released.

| Node.js Version | Windows Version            |
|-----------------|----------------------------|
| v18             | 10 / 2016                  |
| v20             | 10 / 2016                  |
| v21             | 10 / 2016                  |
| v22             | 10 / 2016                  |

## For building Node.js Core

Supported versions for building Node.js from source.

| Node.js Version | Visual Studio Version               |
|-----------------|-------------------------------------|
| v18             | 2019                                |
| v20             | 2019                                |
| v21             | 2022                                |
| v22             | 2022                                |

## For building Node.js Addons

Supported versions for building Node.js addons. End-users should have one of these installed for building native modules.

| Node.js Version | Visual Studio Version                     |
|-----------------|-------------------------------------------|
| v18             | 2015, VCBT2015, 2017, 2019                |
| v20             | 2017, 2019 <sup>[1]</sup>                 |
| v21             | 2017, 2019, 2022 <sup>[1]</sup>           |
| v22             | 2019, 2022 <sup>[2]</sup>                 |

## Official Releases

These versions are used to build the official releases.

| Node.js Version | Windows Version | Visual Studio Version |
|-----------------|-----------------|-----------------------|
| v18             | 2012 R2         | 2019                  |
| v20             | 2012 R2         | 2019                  |
| v21             | 2022            | 2022                  |
| v22             | 2022            | 2022                  |

## References

1. Support for building addons with Visual Studio 2015 was removed in v19.0.0.
   - Pull Request: https://github.com/nodejs/node-gyp/pull/2746
2. Support for building addons with Visual Studio 2017 was removed in v22.0.0.
