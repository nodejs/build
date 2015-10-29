#!/usr/bin/env node

'use strict'

const fs     = require('fs')
    , path   = require('path')
    , semver = require('semver')
    , map    = require('map-async')


if (process.argv.length < 3)
  throw new Error('Usage: latest-linker.js <downloads directory> [docs directory]')

const dir = path.resolve(process.argv[2])
    , docsDir = process.argv[3] && path.resolve(process.argv[3])

if (!fs.statSync(dir).isDirectory())
  throw new Error('Usage: latest-linker.js <downloads directory> [docs directory]')

if (docsDir && !fs.statSync(docsDir).isDirectory())
  throw new Error('Usage: latest-linker.js <downloads directory> [docs directory]')

map(
    fs.readdirSync(dir).map(function (d) { return path.join(dir, d) })
  , function (d, callback) {
      fs.stat(d, function (err, stat) { callback(null, { d: d, stat: stat }) })
   }
  , afterMap
)

function afterMap (err, allDirs) {
  if (err)
    throw err

  allDirs = allDirs.filter(function (d) { return d.stat && d.stat.isDirectory() })
                   .map(function (d) { return path.basename(d.d) })
                   .map(function (d) { try { return semver(d) } catch (e) {} })
                   .filter(Boolean)

  makeDocsLinks(allDirs.map(function (v) { return v.raw }))

  var dirs = allDirs.filter(function (d) { return semver.satisfies(d, '~0.10 || ~0.12 || >= 1.0') })
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


function makeDocsLinks (versions) {
  if (!docsDir)
    return

  versions.forEach(function (version) {
    var src = path.join(dir, version, 'docs')
      , dst = path.join(docsDir, version)

    fs.stat(src, function (err, stat) {
      if (err || !stat.isDirectory())
        return

      fs.unlink(dst, function () {
        fs.symlink(src, dst, function (err) {
          if (err)
            throw err
        })
      })
    })
  })
}

function link (line, dirs) {
  var range = line ? `${line[0] == '0' ? '~' : '^'}${line}` : '*'
    , max   = semver.maxSatisfying(dirs, range)

  if (!max) return false

  function symlink (name) {
    var dst = path.join(dir, name)
      , src = path.join(dir, max)

    try { fs.unlinkSync(dst) } catch (e) {}
    fs.symlinkSync(src, dst)

    if (!docsDir)
      return

    var dsrc = path.join(dir, max, 'docs')
      , ddst = path.join(docsDir, name)

    try { fs.unlinkSync(ddst) } catch (e) {}
    fs.symlinkSync(dsrc, ddst)
  }

  if (line) {
    symlink(`latest-v${line}`)
  } else {
    symlink('latest')
  }

  return max
}

