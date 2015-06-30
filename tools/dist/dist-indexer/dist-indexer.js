#!/usr/bin/env node

'use strict';

const fs         = require('fs')
    , path       = require('path')
    , argv       = require('minimist')(process.argv.slice(2))
    , map        = require('map-async')
    , after      = require('after')
    , hyperquest = require('hyperquest')
    , bl         = require('bl')

    , transformFilename = require('./transform-filename')
    , decodeRef  = require('./decode-ref')

    , versionCachePath = path.join(process.env.HOME, '.dist-indexer-version-cache')

    // needs auth: githubContentUrl = 'https://api.github.com/repos/nodejs/io.js/contents'
    , githubContentUrl = 'https://raw.githubusercontent.com/nodejs/io.js/{gitref}'
    , npmPkgJsonUrl    = `${githubContentUrl}/deps/npm/package.json`
    , v8VersionUrl     = [
          `${githubContentUrl}/deps/v8/src/version.cc`
        , `${githubContentUrl}/deps/v8/include/v8-version.h`
      ]
    , uvVersionUrl     = `${githubContentUrl}/deps/uv/include/uv-version.h`
    , sslVersionUrl    = `${githubContentUrl}/deps/openssl/openssl/Makefile`
    , zlibVersionUrl   = `${githubContentUrl}/deps/zlib/zlib.h`
    , modVersionUrl    = `${githubContentUrl}/src/node_version.h`
    , githubOptions    = { headers: {
          'accept': 'text/plain,application/vnd.github.v3.raw'
      } }


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


function cacheGet (gitref, prop) {
  return versionCache[gitref] && versionCache[gitref][prop]
}


function cachePut (gitref, prop, value) {
  if (prop && value)
    (versionCache[gitref] || (versionCache[gitref] = {}))[prop] = value
}


function fetch (url, gitref, callback) {
  url = url.replace('{gitref}', gitref) + `?rev=${gitref}`
  hyperquest.get(url, githubOptions).pipe(bl(function (err, data) {
    if (err)
      return callback(err)

    callback(null, data.toString())
  }))
}


function fetchNpmVersion (gitref, callback) {
  var version = cacheGet(gitref, 'npm')
  if (version)
    return setImmediate(callback.bind(null, null, version))

  fetch(npmPkgJsonUrl, gitref, function (err, rawData) {
    if (err)
      return callback(err)

    var data

    try {
      data = JSON.parse(rawData)
    } catch (e) {
      return callback(e)
    }

    cachePut(gitref, 'npm', data.version)
    return callback(null, data.version)
  })
}


function fetchV8Version (gitref, callback) {
  var version = cacheGet(gitref, 'v8')
  if (version)
    return setImmediate(callback.bind(null, null, version))

  fetch(v8VersionUrl[0], gitref, function (err, rawData) {
    if (err)
      return callback(err)

    version = rawData.split('\n').map(function (line) {
        return line.match(/^#define (?:MAJOR_VERSION|MINOR_VERSION|BUILD_NUMBER|PATCH_LEVEL)\s+(\d+)$/)
      })
      .filter(Boolean)
      .map(function (m) { return m[1] })
      .join('.')

    if (version) {
      cachePut(gitref, 'v8', version)
      return callback(null, version)
    }

    fetch(v8VersionUrl[1], gitref, function (err, rawData) {
      if (err)
        return callback(err)

      version = rawData.split('\n').map(function (line) {
          return line.match(/^#define V8_(?:MAJOR_VERSION|MINOR_VERSION|BUILD_NUMBER|PATCH_LEVEL)\s+(\d+)$/)
        })
        .filter(Boolean)
        .map(function (m) { return m[1] })
        .join('.')

      cachePut(gitref, 'v8', version)
      callback(null, version)
    })
  })
}


function fetchUvVersion (gitref, callback) {
  var version = cacheGet(gitref, 'uv')
  if (version)
    return setImmediate(callback.bind(null, null, version))

  fetch(uvVersionUrl, gitref, function (err, rawData) {
    if (err)
      return callback(err)

    version = rawData.split('\n').map(function (line) {
      return line.match(/^#define UV_VERSION_(?:MAJOR|MINOR|PATCH)\s+(\d+)$/)
    })
    .filter(Boolean)
    .map(function (m) { return m[1] })
    .join('.')

    cachePut(gitref, 'uv', version)
    callback(null, version)
  })
}


function fetchSslVersion (gitref, callback) {
  var version = cacheGet(gitref, 'ssl')
  if (version)
    return setImmediate(callback.bind(null, null, version))

  fetch(sslVersionUrl, gitref, function (err, rawData) {
    if (err)
      return callback(err)

    var m = rawData.match(/^VERSION=(.+)$/m)
    version = m && m[1]
    cachePut(gitref, 'ssl', version)

    callback(null, version)
  })
}


function fetchZlibVersion (gitref, callback) {
  var version = cacheGet(gitref, 'zlib')
  if (version)
    return setImmediate(callback.bind(null, null, version))

  fetch(zlibVersionUrl, gitref, function (err, rawData) {
    if (err)
      return callback(err)

    var m = rawData.match(/^#define ZLIB_VERSION\s+"(.+)"$/m)
    version = m && m[1]
    cachePut(gitref, 'zlib', version)

    callback(null, version)
  })
}


function fetchModVersion (gitref, callback) {
  var version = cacheGet(gitref, 'mod')
  if (version)
    return setImmediate(callback.bind(null, null, version))

  fetch(modVersionUrl, gitref, function (err, rawData) {
    if (err)
      return callback(err)

    var m = rawData.match(/^#define NODE_MODULE_VERSION\s+([^\s]+)\s+.+$/m)
    version = m && m[1]
    cachePut(gitref, 'mod', version)

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


function dirFiles (dir, callback) {
  fs.readFile(path.join(argv.dist, dir, 'SHASUMS256.txt'), 'utf8', afterReadFile)

  function afterReadFile (err, contents) {
    if (err)
      return callback(err)

    var files = contents.split('\n').map(function (line) {
      var seg = line.split(/\s+/)
      return seg.length >= 2 && seg[1]
    })
    .map(transformFilename)
    .filter(Boolean)
    .sort()

    callback(null, files)
  }
}


function inspectDir (dir, callback) {
  var gitref = decodeRef(dir)
    , files
    , npmVersion
    , v8Version
    , uvVersion
    , sslVersion
    , zlibVersion
    , modVersion
    , date

  if (!gitref) {
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

    fetchNpmVersion(gitref, function (err, version) {
      if (err) {
        console.error(err)
        console.error('(ignoring error fetching npm version for %s)', gitref)
      }
      npmVersion = version
      done()
    })

    fetchV8Version(gitref, function (err, version) {
      if (err) {
        console.error(err)
        console.error('(ignoring error fetching V8 version for %s)', gitref)
      }
      v8Version = version
      done()
    })

    fetchUvVersion(gitref, function (err, version) {
      if (err) {
        console.error(err)
        console.error('(ignoring error fetching uv version for %s)', gitref)
      }
      uvVersion = version
      done()
    })

    fetchSslVersion(gitref, function (err, version) {
      if (err) {
        console.error(err)
        console.error('(ignoring error fetching OpenSSL version for %s)', gitref)
      }
      sslVersion = version
      done()
    })

    fetchZlibVersion(gitref, function (err, version) {
      if (err) {
        console.error(err)
        console.error('(ignoring error fetching zlib version for %s)', gitref)
      }
      zlibVersion = version
      done()
    })

    fetchModVersion(gitref, function (err, version) {
      if (err) {
        console.error(err)
        console.error('(ignoring error fetching modules version for %s)', gitref)
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
