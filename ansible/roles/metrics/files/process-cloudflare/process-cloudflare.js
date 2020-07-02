#!/usr/bin/env node

const { pipeline, Transform } = require('stream')
const split2 = require('split2')
const strftime = require('strftime').timezone(0)
const {Storage} = require('@google-cloud/storage');

const storage = new Storage({keyFilename: "metrics-processor-service-key.json"});

const jsonStream = new Transform({
  readableObjectMode: true,
  transform (chunk, encoding, callback) {
    try {
      this.push(JSON.parse(chunk.toString()))
      callback()
    } catch (e) {
      callback(e)
    }
  }
})

const extensionRe = /\.(tar\.gz|tar\.xz|pkg|msi|exe|zip|7z)$/
const uriRe = /(\/+(dist|download\/+release)\/+(node-latest\.tar\.gz|([^/]+)\/+((win-x64|win-x86|x64)?\/+?node\.exe|(x64\/)?node-+(v[0-9.]+)[.-]([^? ]+))))/
const versionRe = /^v[0-9.]+$/

function determineOS (path, file, fileType) {
  if (/node\.exe$/.test(file)) {
    return 'win'
  } else if (/\/node-latest\.tar\.gz$/.test(path)) {
    return 'src'
  } else if (fileType == null) {
    return ''
  } else if (/msi$/.test(fileType) || /^win-/.test(fileType)) {
    return 'win'
  } else if (/^tar\..z$/.test(fileType)) {
    return 'src'
  } else if (/^headers\.tar\..z$/.test(fileType)) {
    return 'headers'
  } else if (/^linux-/.test(fileType)) {
    return 'linux'
  } else if (fileType === 'pkg' || /^darwin-/.test(fileType)) {
    return 'osx'
  } else if (/^sunos-/.test(fileType)) {
    return 'sunos'
  } else if (/^aix-/.test(fileType)) {
    return 'aix'
  } else {
    return ''
  }
}

function determineArch (fileType, winArch, os) {
  if (fileType != null) {
    if (fileType.indexOf('x64') >= 0 || fileType === 'pkg') {
      // .pkg for Node.js <= 0.12 were universal so may be used for either x64 or x86
      return 'x64'
    } else if (fileType.indexOf('x86') >= 0) {
      return 'x86'
    } else if (fileType.indexOf('armv6') >= 0) {
      return 'armv6l'
    } else if (fileType.indexOf('armv7') >= 0) { // 4.1.0 had a misnamed binary, no 'l' in 'armv7l'
      return 'armv7l'
    } else if (fileType.indexOf('arm64') >= 0) {
      return 'arm64'
    } else if (fileType.indexOf('ppc64le') >= 0) {
      return 'ppc64le'
    } else if (fileType.indexOf('ppc64') >= 0) {
      return 'ppc64'
    } else if (fileType.indexOf('s390x') >= 0) {
      return 's390x'
    }
  }

  if (os === 'win') {
    // we get here for older .msi files and node.exe files
    if (winArch && winArch.indexOf('x64') >= 0) {
      // could be 'x64' or 'win-x64'
      return 'x64'
    } else {
      // could be 'win-x86' or ''
      return 'x86'
    }
  }

  return ''
}

const logTransformStream = new Transform({
  writableObjectMode: true,
  transform (chunk, encoding, callback) {
    if (chunk.ClientRequestMethod !== 'GET' ||
        chunk.EdgeResponseStatus < 200 ||
        chunk.EdgeResponseStatus >= 300) {
      return callback()
    }

    if (chunk.EdgeResponseBytes < 1024) { // unreasonably small for something we want to measure
      return callback()
    }

    if (!extensionRe.test(chunk.ClientRequestPath)) { // not a file we care about
      return callback()
    }

    const requestPath = chunk.ClientRequestPath.replace(/\/\/+/g, '/')
    const uriMatch = requestPath.match(uriRe)
    if (!uriMatch) { // what is this then?
      return callback()
    }

    const path = uriMatch[1]
    const pathVersion = uriMatch[4]
    const file = uriMatch[5]
    const winArch = uriMatch[6]
    const fileVersion = uriMatch[8]
    const fileType = uriMatch[9]

    let version = ''
    // version can come from the filename or the path, filename is best
    // but it may not be there (e.g. node.exe) so fall back to path version
    if (versionRe.test(fileVersion)) {
      version = fileVersion
    } else if (versionRe.test(pathVersion)) {
      version = pathVersion
    }

    const os = determineOS(path, file, fileType)
    const arch = determineArch(fileType, winArch, os)

    const line = []
    line.push(strftime('%Y-%m-%d', new Date(chunk.EdgeStartTimestamp / 1000 / 1000))) // date
    line.push(chunk.ClientCountry.toUpperCase()) // country
    line.push('') // state/province, derived from chunk.EdgeColoCode probably
    line.push(chunk.ClientRequestPath) // URI
    line.push(version) // version
    line.push(os) // os
    line.push(arch) // arch
    line.push(chunk.EdgeResponseBytes)

    this.push(`${line.join(',')}\n`)

    callback()
  }
})


exports.processLogs = (data, context, callback) => {
  console.log('Node version is: ' + process.version);
  const file = data;
  bucketName = file.bucket;
  fileName = file.name;
  console.log("DATA " + data);
  console.log("BUCKET " + bucketName);
  console.log("FILENAME " + fileName);
  processedFile = fileName.split(".")[0];
  processedFile = processedFile.split("_")[0].concat("_", processedFile.split("_")[1]); 
  console.log("PROCESSEDFILENAME " + processedFile);

  storage.bucket(bucketName).file(file.name).createReadStream()
  .on('error', function(err) { console.error(err) })
  .pipe(split2())
  .pipe(jsonStream)
  .pipe(logTransformStream)
  .pipe(storage.bucket('processed-logs-nodejs').file(processedFile).createWriteStream({resumable: false})
        .on("error", err => {
          console.log("ERROR: >> ", err)
        })
        .on("finish", () => {
        console.log("FINISHED")
        callback()
      }));
}
