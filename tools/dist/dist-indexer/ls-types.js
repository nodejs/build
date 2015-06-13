#!/usr/bin/env node

const fs   = require('fs')
    , path = require('path')

    , transformFilename = require('./transform-filename')


function lsTypes (dir, dones, callback) {
  if (typeof dones == 'function') {
    callback = dones
    dones = false
  }

  fs.readdir(dir, afterReaddir)

  function afterReaddir (err, files) {
    if (err)
      return callback(err)

    if (dones) {
      files = files.map(function (f) {
        if (/\.done$/.test(f))
          return f.replace(/\.done$/, '')
        return false
      }).filter(Boolean)
    }

    files = files.map(transformFilename)
      .filter(Boolean)
      .sort()

    callback(null, files)
  }
}


if (require.main === module) {
  var dones = process.argv[2] == '-d'
    , dirs = process.argv.slice(dones ? 3 : 2)

  ;(function ls () {
    var dir = dirs.shift()
    if (!dir)
      return

    fs.stat(dir, function (err, stat) {
      if (err || !stat.isDirectory())
        return ls()

      lsTypes(dir, dones, function (err, files) {
        if (err)
          throw err

        files.length && console.log('%s: %s', dir, files.join(' '))
        ls()
      })
    })
  }())
}
