const types = {
          'tar.gz'           : 'src'
        , 'darwin-x64'       : 'osx-x64-tar'
        , 'pkg'              : 'osx-x64-pkg'
        , 'linux-arm64'      : 'linux-arm64'
        , 'linux-armv7l'     : 'linux-armv7l'
        , 'linux-armv6l'     : 'linux-armv6l'
        , 'linux-x64'        : 'linux-x64'
        , 'linux-x86'        : 'linux-x86'
        , 'x64.msi'          : 'win-x64-msi'
        , 'x86.msi'          : 'win-x86-msi'
        , 'win-x64/iojs.exe' : 'win-x64-exe'
        , 'win-x86/iojs.exe' : 'win-x86-exe'
      }


function transformFilename (file) {
  file = file && file.replace(/^iojs-v\d\.\d\.\d-?((next-)?nightly\d{8}[^-\.]+-?)?\.?/, '')
                     .replace(/\.tar\.gz$/, '')

  return types[file]
}


module.exports = transformFilename
