const assert = require('assert')
    , types = {
          'tar.gz'           : 'src'
        , 'darwin-x64'       : 'osx-x64-tar'
        , 'darwin-x86'       : 'osx-x86-tar'
        , 'pkg'              : 'osx-x64-pkg'
        , 'linux-arm64'      : 'linux-arm64'
        , 'linux-armv7l'     : 'linux-armv7l'
        , 'linux-armv6l'     : 'linux-armv6l'
        , 'linux-x64'        : 'linux-x64'
        , 'linux-x86'        : 'linux-x86'
        , 'sunos-x64'        : 'sunos-x64'
        , 'sunos-x86'        : 'sunos-x86'
        , 'x64.msi'          : 'win-x64-msi'
        , 'x86.msi'          : 'win-x86-msi'
        , 'win-x64/iojs.exe' : 'win-x64-exe'
        , 'win-x86/iojs.exe' : 'win-x86-exe'
        , 'node.exe'         : 'win-x86-exe'
        , 'x64/node.exe'     : 'win-x64-exe'
        , 'headers'          : 'headers'
      }


function transformFilename (file) {
  file = file && file.replace(/^(?:\.\/)?(?:iojs|node)-v\d+\.\d+\.\d+-?((rc\.\d+|(next-)?nightly\d{8}[^-\.]+)-?)?\.?/, '')
                     .replace(/\.tar\.gz$/, '')
  return types[file]
}


module.exports = transformFilename


if (module === require.main) {
  var tests = [
      { file: 'doc' }
    , { file: 'iojs-v3.0.0-darwin-x64.tar.gz', type: 'osx-x64-tar' }
    , { file: 'iojs-v3.0.0-darwin-x64.tar.xz' }
    , { file: 'iojs-v3.0.0-headers.tar.gz', type: 'headers' }
    , { file: 'iojs-v3.0.0-headers.tar.xz' }
    , { file: 'iojs-v3.0.0-linux-armv7l.tar.gz', type: 'linux-armv7l' }
    , { file: 'iojs-v3.0.0-linux-armv7l.tar.xz' }
    , { file: 'iojs-v3.0.0-linux-armv6l.tar.gz', type: 'linux-armv6l' }
    , { file: 'iojs-v3.0.0-linux-armv6l.tar.xz' }
    , { file: 'iojs-v3.0.0-linux-x64.tar.gz', type: 'linux-x64' }
    , { file: 'iojs-v3.0.0-linux-x64.tar.xz' }
    , { file: 'iojs-v3.0.0-linux-x86.tar.gz', type: 'linux-x86' }
    , { file: 'iojs-v3.0.0-linux-x86.tar.xz' }
    , { file: 'iojs-v3.0.0.pkg', type: 'osx-x64-pkg' }
    , { file: 'iojs-v3.0.0.tar.gz', type: 'src' }
    , { file: 'iojs-v3.0.0.tar.xz' }
    , { file: 'iojs-v3.0.0-x64.msi', type: 'win-x64-msi' }
    , { file: 'iojs-v3.0.0-x86.msi', type: 'win-x86-msi' }
    , { file: 'iojs-v3.0.0-nightly20150625dcbb9e1da6-darwin-x64.tar.gz', type: 'osx-x64-tar' }
    , { file: 'iojs-v3.0.0-nightly20150625dcbb9e1da6-darwin-x64.tar.xz' }
    , { file: 'iojs-v3.0.0-nightly20150625dcbb9e1da6-headers.tar.gz', type: 'headers' }
    , { file: 'iojs-v3.0.0-nightly20150625dcbb9e1da6-headers.tar.xz' }
    , { file: 'iojs-v3.0.0-nightly20150625dcbb9e1da6-linux-armv7l.tar.gz', type: 'linux-armv7l' }
    , { file: 'iojs-v3.0.0-nightly20150625dcbb9e1da6-linux-armv7l.tar.xz' }
    , { file: 'iojs-v3.0.0-nightly20150625dcbb9e1da6-linux-armv6l.tar.gz', type: 'linux-armv6l' }
    , { file: 'iojs-v3.0.0-nightly20150625dcbb9e1da6-linux-armv6l.tar.xz' }
    , { file: 'iojs-v3.0.0-nightly20150625dcbb9e1da6-linux-x64.tar.gz', type: 'linux-x64' }
    , { file: 'iojs-v3.0.0-nightly20150625dcbb9e1da6-linux-x64.tar.xz' }
    , { file: 'iojs-v3.0.0-nightly20150625dcbb9e1da6-linux-x86.tar.gz', type: 'linux-x86' }
    , { file: 'iojs-v3.0.0-nightly20150625dcbb9e1da6-linux-x86.tar.xz' }
    , { file: 'iojs-v3.0.0-nightly20150625dcbb9e1da6.pkg', type: 'osx-x64-pkg' }
    , { file: 'iojs-v3.0.0-nightly20150625dcbb9e1da6.tar.gz', type: 'src' }
    , { file: 'iojs-v3.0.0-nightly20150625dcbb9e1da6.tar.xz' }
    , { file: 'iojs-v3.0.0-nightly20150625dcbb9e1da6-x64.msi', type: 'win-x64-msi' }
    , { file: 'iojs-v3.0.0-nightly20150625dcbb9e1da6-x86.msi', type: 'win-x86-msi' }
    , { file: 'iojs-v3.0.0-next-nightly20150625dcbb9e1da6-darwin-x64.tar.gz', type: 'osx-x64-tar' }
    , { file: 'iojs-v3.0.0-next-nightly20150625dcbb9e1da6-darwin-x64.tar.xz' }
    , { file: 'iojs-v3.0.0-next-nightly20150625dcbb9e1da6-headers.tar.gz', type: 'headers' }
    , { file: 'iojs-v3.0.0-next-nightly20150625dcbb9e1da6-headers.tar.xz' }
    , { file: 'iojs-v3.0.0-next-nightly20150625dcbb9e1da6-linux-armv7l.tar.gz', type: 'linux-armv7l' }
    , { file: 'iojs-v3.0.0-next-nightly20150625dcbb9e1da6-linux-armv7l.tar.xz' }
    , { file: 'iojs-v3.0.0-next-nightly20150625dcbb9e1da6-linux-armv6l.tar.gz', type: 'linux-armv6l' }
    , { file: 'iojs-v3.0.0-next-nightly20150625dcbb9e1da6-linux-armv6l.tar.xz' }
    , { file: 'iojs-v3.0.0-next-nightly20150625dcbb9e1da6-linux-x64.tar.gz', type: 'linux-x64' }
    , { file: 'iojs-v3.0.0-next-nightly20150625dcbb9e1da6-linux-x64.tar.xz' }
    , { file: 'iojs-v3.0.0-next-nightly20150625dcbb9e1da6-linux-x86.tar.gz', type: 'linux-x86' }
    , { file: 'iojs-v3.0.0-next-nightly20150625dcbb9e1da6-linux-x86.tar.xz' }
    , { file: 'iojs-v3.0.0-next-nightly20150625dcbb9e1da6.pkg', type: 'osx-x64-pkg' }
    , { file: 'iojs-v3.0.0-next-nightly20150625dcbb9e1da6.tar.gz', type: 'src' }
    , { file: 'iojs-v3.0.0-next-nightly20150625dcbb9e1da6.tar.xz' }
    , { file: 'iojs-v3.0.0-next-nightly20150625dcbb9e1da6-x64.msi', type: 'win-x64-msi' }
    , { file: 'iojs-v3.0.0-next-nightly20150625dcbb9e1da6-x86.msi', type: 'win-x86-msi' }
    , { file: 'iojs-v3.0.0-rc.1-darwin-x64.tar.gz', type: 'osx-x64-tar' }
    , { file: 'iojs-v3.0.0-rc.1-darwin-x64.tar.xz' }
    , { file: 'iojs-v3.0.0-rc.1-headers.tar.gz', type: 'headers' }
    , { file: 'iojs-v3.0.0-rc.1-headers.tar.xz' }
    , { file: 'iojs-v3.0.0-rc.1-linux-armv7l.tar.gz', type: 'linux-armv7l' }
    , { file: 'iojs-v3.0.0-rc.1-linux-armv7l.tar.xz' }
    , { file: 'iojs-v3.0.0-rc.1-linux-armv6l.tar.gz', type: 'linux-armv6l' }
    , { file: 'iojs-v3.0.0-rc.1-linux-armv6l.tar.xz' }
    , { file: 'iojs-v3.0.0-rc.1-linux-x64.tar.gz', type: 'linux-x64' }
    , { file: 'iojs-v3.0.0-rc.1-linux-x64.tar.xz' }
    , { file: 'iojs-v3.0.0-rc.1-linux-x86.tar.gz', type: 'linux-x86' }
    , { file: 'iojs-v3.0.0-rc.1-linux-x86.tar.xz' }
    , { file: 'iojs-v3.0.0-rc.1.pkg', type: 'osx-x64-pkg' }
    , { file: 'iojs-v3.0.0-rc.1.tar.gz', type: 'src' }
    , { file: 'iojs-v3.0.0-rc.1.tar.xz' }
    , { file: 'iojs-v3.0.0-rc.1-x64.msi', type: 'win-x64-msi' }
    , { file: 'iojs-v3.0.0-rc.1-x86.msi', type: 'win-x86-msi' }
    , { file: 'SHASUMS256.txt' }
    , { file: 'win-x64/iojs.exe', type: 'win-x64-exe' }
    , { file: 'win-x86/iojs.exe', type: 'win-x86-exe' }
    , { file: 'node-v0.11.9-darwin-x64.tar.gz', type: 'osx-x64-tar' }
    , { file: 'node-v0.11.9-darwin-x86.tar.gz', type: 'osx-x86-tar' }
    , { file: 'node-v0.11.9-linux-x64.tar.gz', type: 'linux-x64' }
    , { file: 'node-v0.11.9-linux-x86.tar.gz', type: 'linux-x86' }
    , { file: 'node-v0.11.9-sunos-x64.tar.gz', type: 'sunos-x64' }
    , { file: 'node-v0.11.9-sunos-x86.tar.gz', type: 'sunos-x86' }
    , { file: 'node-v0.11.9.tar.gz', type: 'src' }
    , { file: 'node.exe', type: 'win-x86-exe' }
    , { file: 'x64/node.exe', type: 'win-x64-exe' }
  ]

  tests.forEach(function (test) {
    console.log(`testing ${test.file} -> ${test.type}`)
    assert.equal(transformFilename(test.file), test.type)
  })
}
