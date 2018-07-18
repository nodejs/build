# Windows and Visual Studio versions supported for Node.js

## For running Node.js

Supported versions for running the Node.js installer and executable as released.

| Node.js Version | Windows Version            |
|-----------------|----------------------------|
| v4              | XP                         |
| v5              | XP                         |
| v6              | 7 / 2008 R2 <sup>[1]</sup> |
| v7              | 7 / 2008 R2                |
| v8              | 7 / 2008 R2                |
| v9              | 7 / 2008 R2                |
| v10             | 7 / 2008 R2                |
| v11             | 7 / 2008 R2                |

## For building Node.js Core

Supported versions for building Node.js from source.

| Node.js Version | Visual Studio Version               |
|-----------------|-------------------------------------|
| v4              | 2013, 2015, VCBT2015 <sup>[2]</sup> |
| v5              | 2013, 2015, VCBT2015 <sup>[2]</sup> |
| v6.0.0 - v6.7.0 | 2013, 2015, VCBT2015                |
| v6.8.0 onwards  | 2015, VCBT2015 <sup>[3]</sup>       |
| v7              | 2015, VCBT2015 <sup>[3]</sup>       |
| v8              | 2015, VCBT2015, 2017 <sup>[4]</sup> |
| v9              | 2015, VCBT2015, 2017                |
| v10             | 2017 <sup>[5]</sup>                 |
| v11             | 2017                                |

## For building Node.js Addons

Supported versions for building Node.js addons. End-users should have one of these installed for building native modules.

| Node.js Version | Visual Studio Version                     |
|-----------------|-------------------------------------------|
| v4              | 2013, 2015, VCBT2015                      |
| v5              | 2013, 2015, VCBT2015                      |
| v6              | 2013, 2015, VCBT2015                      |
| v7              | 2013, 2015, VCBT2015                      |
| v8              | 2013, 2015, VCBT2015, 2017 <sup>[6]</sup> |
| v9              | 2015, VCBT2015, 2017 <sup>[7]</sup>       |
| v10             | 2015, VCBT2015, 2017                      |
| v11             | 2015, VCBT2015, 2017                      |

## Official Releases

These versions are used to build the official releases.

| Node.js Version | Windows Version | Visual Studio Version |
|-----------------|-----------------|-----------------------|
| v4              | 2008 R2         | 2013                  |
| v5              | 2008 R2         | 2013                  |
| v6.0.0 - v6.7.0 | 2008 R2         | 2013                  |
| v6.8.0 onwards  | 2008 R2         | 2015 <sup>[3]</sup>   |
| v7              | 2008 R2         | 2015                  |
| v8              | 2008 R2         | 2015                  |
| v9              | 2008 R2         | 2015                  |
| v10             | 2012 R2         | 2017 <sup>[5]</sup>   |
| v11             | 2012 R2         | 2017                  |

## References

1. Support for Windows XP and Windows Vista was removed in v6.0.0.
   - Issue: https://github.com/nodejs/node/issues/3804
   - Pull Request: https://github.com/nodejs/node/pull/5167
2. Support for Visual C++ Build Tools 2015 was added in v4.4.1 and v5.9.0.
   - Pull Request: https://github.com/nodejs/node/pull/5627
3. Support for Visual Studio 2013 was removed in v6.8.0 and v7.0.0.
   - Issue for v7: https://github.com/nodejs/node/issues/7484
   - Issue for v6: https://github.com/nodejs/node/issues/7989
   - Pull Request: https://github.com/nodejs/node/pull/8067
4. Support for Visual Studio 2017 was added in v8.0.0.
   - Pull Request: https://github.com/nodejs/node/pull/11852
5. Support for Visual Studio 2015 was removed in v10.0.0.
   - Pull Request: https://github.com/nodejs/node/pull/16868
   - Pull Request: https://github.com/nodejs/node/pull/16969
6. Support for **building addons** with Visual Studio 2017 was added in v8.0.0.
   - Pull Request: https://github.com/nodejs/node-gyp/pull/1130
7. Support for **building addons** with Visual Studio 2013 was removed in v9.0.0.
   - Issue: https://github.com/nodejs/node/issues/13372
   - Pull Request: https://github.com/nodejs/node/pull/14764

