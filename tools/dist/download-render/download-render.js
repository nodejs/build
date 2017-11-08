#!/usr/bin/env node

const dir      = process.argv[2]
    , prefix   = process.argv[3]
    , fs       = require('fs')
    , path     = require('path')
    , map      = require('map-async')
    , after    = require('after')
    , strftime = require('strftime')

    , extras = [
          'doc/api/index.html'
        , 'win-x64/iojs.exe'
        , 'win-x64/iojs.lib'
        , 'win-x86/iojs.exe'
        , 'win-x86/iojs.lib'
      ]


if (!dir)
  throw new Error('Supply a dir string as the first argument')

if (!prefix)
  throw new Error('Supply a prefix string as the second argument')


var version = path.basename(dir)
  , files   = fs.readdirSync(dir).concat(extras)

map(files, function (file, callback) {
  fs.stat(path.join(dir, file), function (err, stat) {
    if (stat)
      stat.name = file
    callback(null, stat)
  })
}, function (err, files) {
  if (err)
    throw err

  render(files.filter(function (stat) { return stat }).sort())
})


function render (files) {
  var webPath = path.join(prefix, version)
    , date    = files.reduce(function (p, c) {
        return !p || c.ctime < p ? c.ctime : p
      }, null)
    , currentPlatform
    , platformClass = ''

  function hasFile (reg) {
    var f = files.filter(function (file) {
      return reg.test(file.name)
    })[0]
    return f && f.name
  }

  function newPlatform (platform) {
    if (platform != currentPlatform) {
      currentPlatform = platform
      platformClass = 'release-platform-divider'
    } else
      platformClass = ''
  }

  out = ''
  out += `

<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Release ${version} | io.js - JavaScript I/O</title>
  <meta http-equiv="x-ua-Compatible" content="ie=edge">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link href="https://fonts.googleapis.com/css?family=Lato:400,700" rel="stylesheet">
  <link href="https://iojs.org/main.css" rel="stylesheet">
  <link href="dist.css" rel="stylesheet">
  <link rel="icon" href="https://iojs.org/images/1.0.0.ico" type="image/x-icon">
  <link rel="apple-touch-icon" href="https://iojs.org/images/apple-touch-icon-1.0.0.png">
  <meta property="og:image" content="https://iojs.org/images/1.0.0.png">
  <meta property="og:image:type" content="image/png">
  <meta property="og:image:width" content="1369">
  <meta property="og:image:height" content="1563">
</head>

<body>

  <header>
    <nav class="content" role="navigation">
      <a href="/" class="logo">io.js</a>
    </nav>
  </header>

  <div class="content content--dist clearfix" role="main">
    <h2>Release <span>${version}</span></h2>
    <time>${strftime('%d-%b-%Y %H:%M', date)}</time> (nightly)<br>
    <p>
  `

  if (hasFile(/^doc\/api\/index.html$/))
    out += '<a href="doc/api/">API Docs</a><br>'

  if (hasFile(/^SHASUMS256.txt$/))
    out += '<a href="SHASUMS256.txt">SHA Checksums</a>'

  out += `
    <table class="release">
      <tbody>
  `

  function printRow (p, th, td32, td64) {
    var line = ''
      , f32, f64

    if (p)
      newPlatform(p)

    line += '<tr>'
    line += `<th class="${platformClass}">${th}</th>`
    if (td32 && (f32 = hasFile(td32)))
      line += `<td class="${platformClass}"><a href="${f64}">32-bit</a></td>`
    else
      line += `<td class="${platformClass}"></td>`
    if (td64 && (f64 = hasFile(td64)))
      line += `<td class="${platformClass}"><a href="${f64}">64-bit</a></td>`
    else
      line += `<td class="${platformClass}"></td>`
    line += '</tr>'
    return line
  }

  if (hasFile(/\.msi$/))
    out += printRow(null, 'Windows Installer (.msi)', /-x86\.msi$/, /-x64\.msi$/)

  if (hasFile(/\.exe$/))
    out += printRow(null, 'Windows Binary (.exe)', /win-x86\/iojs\.exe$/, /win-x64\/iojs\.exe$/)

  if (hasFile(/\.pkg$/))
    out += printRow('osx', 'Mac OS X Installer (.pkg)', null, /\.pkg$/)

  if (hasFile(/-darwin-.+\.tar\.gz/))
    out += printRow('osx', 'Mac OS X Binaries (.tar.gz)', /-darwin-x86\.tar\.gz/, /-darwin-x64\.tar\.gz/)

  if (hasFile(/-darwin-.+\.tar\.xz/))
    out += printRow('osx', 'Mac OS X Binaries (.tar.xz)', /-darwin-x86\.tar\.xz/, /-darwin-x64\.tar\.xz/)

  if (hasFile(/-linux-x(64|86)\.tar\.gz/))
    out += printRow('linux', 'Linux Binaries (.tar.gz)', /-linux-x86\.tar\.gz/, /-linux-x64\.tar\.gz/)

  if (hasFile(/-linux-x(64|86)\.tar\.xz/))
    out += printRow('linux', 'Linux Binaries (.tar.xz)', /-linux-x86\.tar\.xz/, /-linux-x64\.tar\.xz/)

  if (hasFile(/-linux-armv6l?\.tar\.gz/))
    out += printRow('linux', 'Linux ARMv6 Binaries (.tar.gz)', /-linux-armv6l?\.tar\.gz/, /-linux-armv6l?\.tar\.gz/)

  if (hasFile(/-linux-armv6l?\.tar\.xz/))
    out += printRow('linux', 'Linux ARMv6 Binaries (.tar.xz)', /-linux-armv6l?\.tar\.xz/, /-linux-armv6l?\.tar\.xz/)

  if (hasFile(/-linux-armv7l?\.tar\.gz/))
    out += printRow('linux', 'Linux ARMv7 Binaries (.tar.gz)', /-linux-armv7l?\.tar\.gz/, /-linux-armv7l?\.tar\.gz/)

  if (hasFile(/-linux-armv7l?\.tar\.xz/))
    out += printRow('linux', 'Linux ARMv7 Binaries (.tar.xz)', /-linux-armv7l?\.tar\.xz/, /-linux-armv7l?\.tar\.xz/)

  if (hasFile(new RegExp(version + '\\.tar\\.gz')))
    out += printRow('source', 'Source Code (.tar.gz)', null, new RegExp(version + '\\.tar\\.gz'))

  if (hasFile(new RegExp(version + '\\.tar\\.xz')))
    out += printRow('source', 'Source Code (.tar.xz)', null, new RegExp(version + '\\.tar\\.xz'))

  out += `
      </tbody>
    </table>
  </div>
  `

  out += `
  <div class="content content--dist content--full-index clearfix">
      <h2>Index of ${webPath}/</h2>
      <table>
        <tr><td><a href="../">../</a></td><td></td><td></td></tr>
`

  function printFile (file) {
    var name = file.name + (file.isDirectory() ? '/' : '')

    var outf = `<tr><td><a href="${name}">${name}</a></td>`
    outf    += `<td>${strftime('%d-%b-%Y %H:%M', file.ctime)}</td>`
    if (file.isDirectory())
      outf  += `<td>-</td>`
    else
      outf  += `<td>${file.size}</td>`
    outf    += '</tr>\n'

    return outf
  }

  files.forEach(function (file) {
    if (file.isDirectory())
      out += printFile(file)
  })
  files.forEach(function (file) {
    if (!file.isDirectory() && file.name.indexOf('/') == -1)
      out += printFile(file)
  })

  out += `
      </table>
    </div>
  </div>
</body>
</html>
  `

  console.log(out)
}