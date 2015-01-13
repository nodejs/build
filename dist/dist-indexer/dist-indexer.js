#!/usr/bin/env node

const fs         = require('fs')
    , path       = require('path')
    , argv       = require('minimist')(process.argv.slice(2))
    , map        = require('map-async')
    , after      = require('after')
    , hyperquest = require('hyperquest')
    , bl         = require('bl')

    , versionCachePath = path.join(process.env.HOME, '.dist-indexer-version-cache')

    , dirre      = /^(v\d\.\d\.\d)(?:-nightly\d{8}(\w+))?$/ // get version or commit from dir name

    , types = {
          'tar.gz'              : 'src'
        , 'darwin-x64.tar.gz'   : 'osx-x64-tar'
        , 'pkg'                 : 'osx-x64-pkg'
        , 'linux-armv7l.tar.gz' : 'linux-armv7l'
        , 'linux-armv6l.tar.gz' : 'linux-armv6l'
        , 'linux-x64.tar.gz'    : 'linux-x64'
        , 'linux-x86.tar.gz'    : 'linux-x86'
        , 'x64.msi'             : 'win-x64-msi'
        , 'x86.msi'             : 'win-x86-msi'
        , 'win-x64/iojs.exe'    : 'win-x64-exe'
        , 'win-x86/iojs.exe'    : 'win-x86-exe'
      }

    , npmPkgJsonUrl  = 'https://raw.githubusercontent.com/iojs/io.js/{commit}/deps/npm/package.json'
    , v8VersionUrl   = 'https://raw.githubusercontent.com/iojs/io.js/{commit}/deps/v8/src/version.cc'
    , uvVersionUrl   = 'https://raw.githubusercontent.com/iojs/io.js/{commit}/deps/uv/include/uv-version.h'
    , sslVersionUrl  = 'https://raw.githubusercontent.com/iojs/io.js/{commit}/deps/openssl/openssl/Makefile'
    , zlibVersionUrl = 'https://raw.githubusercontent.com/iojs/io.js/{commit}/deps/zlib/zlib.h'
    , modVersionUrl  = 'https://raw.githubusercontent.com/iojs/io.js/{commit}/src/node_version.h'


if (typeof argv.dist != 'string')
  throw new Error('Missing --dist <directory> argument')

if (typeof argv.indexjson != 'string')
  throw new Error('Missing --indexjson <directory> argument')

if (typeof argv.indextab != 'string')
  throw new Error('Missing --indextab <directory> argument')

if (!fs.statSync(argv.dist).isDirectory())
  throw new Error('"%s" is not a directory')


var versionCache = {}

try {
  versionCache = JSON.parse(fs.readFileSync(versionCachePath, 'utf8'))
} catch (e) {}


function saveVersionCache () {
  fs.writeFileSync(versionCachePath, JSON.stringify(versionCache), 'utf8')
}


function cacheGet (commit, prop) {
  return versionCache[commit] && versionCache[commit][prop]
}


function cachePut (commit, prop, value) {
  (versionCache[commit] || (versionCache[commit] = {}))[prop] = value
}


function commitFromDir (dir) {
  var m = dir.match(dirre)
  return m && (m[2] || m[1])
}


function fetch (url, commit, callback) {
  url = url.replace("{commit}", commit)
  hyperquest.get(url).pipe(bl(function (err, data) {
    if (err)
      return callback(err)

    callback(null, data.toString())
  }))
}


function fetchNpmVersion (commit, callback) {
  var version = cacheGet(commit, 'npm')
  if (version)
    return setImmediate(callback.bind(null, null, version))

  fetch(npmPkgJsonUrl, commit, function (err, rawData) {
    if (err)
      return callback(err)

    var data

    try {
      data = JSON.parse(rawData)
    } catch (e) {
      return callback(e)
    }

    cachePut(commit, 'npm', data.version)
    return callback(null, data.version)
  })
}


function fetchV8Version (commit, callback) {
  var version = cacheGet(commit, 'v8')
  if (version)
    return setImmediate(callback.bind(null, null, version))

  fetch(v8VersionUrl, commit, function (err, rawData) {
    if (err)
      return callback(err)

    version = rawData.split('\n').map(function (line) {
      return line.match(/^#define (?:MAJOR_VERSION|MINOR_VERSION|BUILD_NUMBER|PATCH_LEVEL)\s+(\d+)$/)
    })
    .filter(Boolean)
    .map(function (m) { return m[1] })
    .join('.')

    cachePut(commit, 'v8', version)
    callback(null, version)
  })
}


function fetchUvVersion (commit, callback) {
  var version = cacheGet(commit, 'uv')
  if (version)
    return setImmediate(callback.bind(null, null, version))

  fetch(uvVersionUrl, commit, function (err, rawData) {
    if (err)
      return callback(err)

    version = rawData.split('\n').map(function (line) {
      return line.match(/^#define UV_VERSION_(?:MAJOR|MINOR|PATCH)\s+(\d+)$/)
    })
    .filter(Boolean)
    .map(function (m) { return m[1] })
    .join('.')

    cachePut(commit, 'uv', version)
    callback(null, version)
  })
}


function fetchSslVersion (commit, callback) {
  var version = cacheGet(commit, 'ssl')
  if (version)
    return setImmediate(callback.bind(null, null, version))

  fetch(sslVersionUrl, commit, function (err, rawData) {
    if (err)
      return callback(err)

    var m = rawData.match(/^VERSION=(.+)$/m)
    version = m && m[1]
    cachePut(commit, 'ssl', version)

    callback(null, version)
  })
}


function fetchZlibVersion (commit, callback) {
  var version = cacheGet(commit, 'zlib')
  if (version)
    return setImmediate(callback.bind(null, null, version))

  fetch(zlibVersionUrl, commit, function (err, rawData) {
    if (err)
      return callback(err)

    var m = rawData.match(/^#define ZLIB_VERSION\s+"(.+)"$/m)
    version = m && m[1]
    cachePut(commit, 'zlib', version)

    callback(null, version)
  })
}


function fetchModVersion (commit, callback) {
  var version = cacheGet(commit, 'mod')
  if (version)
    return setImmediate(callback.bind(null, null, version))

  fetch(modVersionUrl, commit, function (err, rawData) {
    if (err)
      return callback(err)

    var m = rawData.match(/^#define NODE_MODULE_VERSION\s+([^\s]+)\s+.+$/m)
    version = m && m[1]
    cachePut(commit, 'mod', version)

    callback(null, version)
  })
}


function dirDate (dir, callback) {
  fs.readdir(path.join(argv.dist, dir), function (err, files) {
    if (err)
      return callback(err)

    map(files, mtime, afterMap)

    function mtime (file, callback) {
      fs.stat(path.join(argv.dist, dir, file), function (err, stat) {
        callback(null, stat && stat.mtime)
      })
    }

    function afterMap (err, mtimes) {
      mtimes = mtimes.filter(Boolean).sort()
      callback(null, mtimes[0])
    }
  })
}


function transformFilenames (file) {
  file = file && file.replace(/^iojs-v\d\.\d\.\d(-nightly\d{8}[^-\.]+[-\.]?)?/, '')
                     .replace(/\.tar\.gz$/, '')

  return types[file]
}


function dirFiles (dir, callback) {
  fs.readFile(path.join(argv.dist, dir, 'SHASUMS256.txt'), 'utf8', afterReadFile)

  function afterReadFile (err, contents) {
    if (err)
      return callback(err)

    files = contents.split('\n').map(function (line) {
      var seg = line.split(/\s+/)
      return seg.length >= 2 && seg[1]
    })
    .map(transformFilenames)
    .filter(Boolean)
    .sort()

    callback(null, files)
  }
}


function inspectDir (dir, callback) {
  var commit = commitFromDir(dir)
    , files
    , npmVersion
    , v8Version
    , uvVersion
    , sslVersion
    , zlibVersion
    , date

  if (!commit) {
    console.error('Ignoring directory "%s"', dir)
    return callback()
  }

  dirFiles(dir, function (err, _files) {
    if (err) {
      console.error('Ignoring directory "%s"', dir)
      return callback() // not a dir we care about
    }

    files = _files

    var done = after(7, afterAll)

    dirDate(dir, function (err, _date) {
      if (err)
        return done(err)

      date = _date
      done()
    })

    fetchNpmVersion(commit, function (err, version) {
      if (err) {
        console.error(err)
        console.error('(ignoring error fetching npm version for %s)', commit)
      }
      npmVersion = version
      done()
    })

    fetchV8Version(commit, function (err, version) {
      if (err) {
        console.error(err)
        console.error('(ignoring error fetching V8 version for %s)', commit)
      }
      v8Version = version
      done()
    })

    fetchUvVersion(commit, function (err, version) {
      if (err) {
        console.error(err)
        console.error('(ignoring error fetching uv version for %s)', commit)
      }
      uvVersion = version
      done()
    })

    fetchSslVersion(commit, function (err, version) {
      if (err) {
        console.error(err)
        console.error('(ignoring error fetching OpenSSL version for %s)', commit)
      }
      sslVersion = version
      done()
    })

    fetchZlibVersion(commit, function (err, version) {
      if (err) {
        console.error(err)
        console.error('(ignoring error fetching zlib version for %s)', commit)
      }
      zlibVersion = version
      done()
    })

    fetchModVersion(commit, function (err, version) {
      if (err) {
        console.error(err)
        console.error('(ignoring error fetching modules version for %s)', commit)
      }
      modVersion = version
      done()
    })
  })

  function afterAll (err) {
    if (err) {
      console.error(err)
      console.error('(ignoring directory due to error %s)', dir)
      return callback()
    }

    callback(null, {
        version   : dir
      , date      : date.toISOString().substring(0, 10)
      , files     : files
      , npm       : npmVersion
      , v8        : v8Version
      , uv        : uvVersion
      , zlib      : zlibVersion
      , openssl   : sslVersion
      , modules   : modVersion
    })
  }
}


map(fs.readdirSync(argv.dist).sort().reverse(), inspectDir, afterMap)


function afterMap (err, dirs) {
  if (err)
    throw err

  saveVersionCache()

  dirs = dirs.filter(Boolean)

  var jsonOut = fs.createWriteStream(argv.indexjson, 'utf8')
    , tabOut  = fs.createWriteStream(argv.indextab, 'utf8')

  function tabWrite () {
    tabOut.write(Array.prototype.join.call(arguments, '\t') + '\n')
  }

  jsonOut.write('[\n')
  tabWrite('version', 'date', 'files', 'npm', 'v8', 'uv', 'zlib', 'openssl', 'modules')

  dirs.forEach(function (dir, i) {
    jsonOut.write(JSON.stringify(dir) + (i != dirs.length - 1 ? ',\n' : '\n'))
    tabWrite(dir.version, dir.date, dir.files.join(','), dir.npm, dir.v8, dir.uv, dir.zlib, dir.openssl, dir.modules)
  })

  jsonOut.write(']\n')

  jsonOut.end()
  tabOut.end()
}
