#!/usr/bin/env node

'use strict'

const fs     = require('fs')
    , path   = require('path')
    , semver = require('semver')
    , map    = require('map-async')


if (process.argv.length < 3)
  throw new Error('Please provide a downloads directory location')

const dir = process.argv[2]

if (!fs.statSync(dir).isDirectory())
  throw new Error('Please provide a downloads directory location')

map(
    fs.readdirSync(dir).map(function (d) { return path.join(dir, d) })
  , function (d, callback) {
      fs.stat(d, function (err, stat) { callback(null, { d: d, stat: stat }) })
   }
  , afterMap
)

function afterMap (err, dirs) {
  if (err)
    throw err

  dirs = dirs.filter(function (d) { return d.stat && d.stat.isDirectory() })
    .map(function (d) { return path.basename(d.d) })
    .map(function (d) { try { return semver(d) } catch (e) {} })
    .filter(Boolean)
    .filter(function (d) { return semver.satisfies(d, '~0.10 || ~0.12 || >= 1.0') })
    .map(function (d) { return d.raw })

  dirs.sort(function (d1, d2) { return semver.compare(d1, d2) })

  link('0.10.x', dirs)
  max = link('0.12.x', dirs)
  for (var i = 1;; i++)
    if (!link(`${i}.x`, dirs)) break

  var max   = link(null, dirs)
    , tbreg = new RegExp(`(\\w+)-${max}.tar.gz`)

  var tarball = fs.readdirSync(path.join(dir, 'latest'))
    .filter(function (f) {
      return tbreg.test(f)
    })

  if (tarball.length != 1)
    throw new Error('Could not find latest.tar.gz')

  tarball = tarball[0]
  var name = tarball.match(tbreg)[1]
  var dst = path.join(dir, `${name}-latest.tar.gz`)
  try { fs.unlinkSync(dst) } catch (e) {}
  fs.symlinkSync(path.join(dir, 'latest', tarball), dst)
}


function link (line, dirs) {
  var range = line ? `${line[0] == '0' ? '~' : '^'}${line}` : '*'
    , max   = semver.maxSatisfying(dirs, range)

  if (!max) return false

  function symlink (name) {
    var dst = path.join(dir, name)
    try { fs.unlinkSync(dst) } catch (e) {}
    fs.symlinkSync(path.join(dir, max), dst)
  }


  if (line) {
    symlink(`latest-v${line}`)
  } else {
    symlink('latest')
  }

  return max
}

