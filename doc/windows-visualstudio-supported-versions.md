# Windows and Visual Studio versions supported for Node.js

**Notes:**
- The exact Windows builds and Visual Studio releases are not tracked. Assume the latest or a recent version at the time of each commit.
- Only 64 bit machines are available in the CI system. Thus, all 32 bit binaries are cross-compiled and tested on WoW64.

## For running Node.js

Supported versions for running the Node.js installer and executable as released.

| Node.js Version | Windows Version            |
|-----------------|----------------------------|
| v10             | 7 / 2008 R2                |
| v12             | 7 / 2008 R2                |
| v13             | 7 / 2008 R2                |
| v14             | 8.1 / 2012 R2              |
| v15             | 8.1 / 2012 R2              |

## For building Node.js Core

Supported versions for building Node.js from source.

| Node.js Version | Visual Studio Version               |
|-----------------|-------------------------------------|
| v10             | 2017 <sup>[1]</sup>                 |
| v12             | 2017, 2019 (flag) <sup>[2]</sup>    |
| v13             | 2017, 2019 <sup>[3]</sup>           |
| v14             | 2017, 2019                          |
| v15             | 2019 <sup>[5]</sup>                |

## For building Node.js Addons

Supported versions for building Node.js addons. End-users should have one of these installed for building native modules.

| Node.js Version | Visual Studio Version                     |
|-----------------|-------------------------------------------|
| v10             | 2015, VCBT2015, 2017                      |
| v12             | 2015, VCBT2015, 2017, 2019 <sup>[4]</sup> |
| v13             | 2015, VCBT2015, 2017, 2019                |
| v14             | 2015, VCBT2015, 2017, 2019                |
| v15             | 2015, VCBT2015, 2017, 2019                |

## Official Releases

These versions are used to build the official releases.

| Node.js Version | Windows Version | Visual Studio Version |
|-----------------|-----------------|-----------------------|
| v10             | 2012 R2         | 2017 <sup>[1]</sup>   |
| v12             | 2012 R2         | 2017                  |
| v13             | 2012 R2         | 2017                  |
| v14             | 2012 R2         | 2019                  |
| v15             | 2012 R2         | 2019                  |

## References

1. Support for Visual Studio 2015 was removed in v10.0.0.
   - Pull Request: https://github.com/nodejs/node/pull/16868
   - Pull Request: https://github.com/nodejs/node/pull/16969
2. Support for Visual Studio 2019 was added behind a flag in v12.8.0.
   - Pull Request: https://github.com/nodejs/node/pull/28781
3. Support for Visual Studio 2019 by default was added in v13.0.1.
   - Pull Request: https://github.com/nodejs/node/pull/30022
4. Support for **building addons** with Visual Studio 2019 was added in v12.8.0 (node-gyp 5.0.0).
   - Pull Request: https://github.com/nodejs/node-gyp/pull/1762
   - Pull Request: https://github.com/nodejs/node/pull/28853
5. Support for Visual Studio 2017 was removed in v15.0.0.
   - Pull Request: https://github.com/nodejs/node/pull/33694
