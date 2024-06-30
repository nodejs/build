#!/usr/bin/env node

'use strict'

const { Storage } = require('@google-cloud/storage')
const express = require('express')
const bodyParser = require('body-parser')
const app = express()

app.use(bodyParser.json())

const extensionRe = /\.(tar\.gz|tar\.xz|pkg|msi|exe|zip|7z)$/
const uriRe = /(\/+(dist|download\/+release)\/+(node-latest\.tar\.gz|([^/]+)\/+((win-x64|win-x86|win-arm64|x64)?\/+?node\.exe|(x64\/)?node-+(v[0-9.]+)[.-]([^? ]+))))/
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

function logTransform2 (jsonObj) {
  if (jsonObj.ClientRequestMethod !== 'GET' || // Drop anything that isnt a GET or a 200 range response
    jsonObj.EdgeResponseStatus < 200 ||
    jsonObj.EdgeResponseStatus >= 300) {
    return
  }

  if (jsonObj.EdgeResponseBytes < 1024) { // unreasonably small for something we want to measure
    return
  }

  if (!extensionRe.test(jsonObj.ClientRequestPath)) { // not a file we care about
    return
  }

  const requestPath = jsonObj.ClientRequestPath.replace(/\/\/+/g, '/')
  const uriMatch = requestPath.match(uriRe) // Check that the request is for an actual node file
  if (!uriMatch) { // what is this then?
    return
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
  const date = new Date(jsonObj.EdgeStartTimestamp / 1000 / 1000)
  line.push(date.toISOString().slice(0, 10)) // date
  line.push(jsonObj.ClientCountry.toUpperCase()) // country
  line.push('') // state/province, derived from chunk.EdgeColoCode probably
  line.push(jsonObj.ClientRequestPath) // URI
  line.push(version) // version
  line.push(os) // os
  line.push(arch) // arch
  line.push(jsonObj.EdgeResponseBytes)

  return (`${line.join(',')}\n`)
}

async function processLogs (bucket, filename, callback) {
  console.log('Node version is: ' + process.version)
  console.log('BUCKET ' + bucket)
  console.log('FILENAME ' + filename)
  let processedFile = filename.split('.')[0]
  processedFile = processedFile.split('_')[0].concat('_', processedFile.split('_')[1])
  console.log('PROCESSEDFILENAME ' + processedFile)
  createPipeline(bucket, filename, processedFile, callback)
}

function createPipeline (bucket, filename, processedFile, callback) {
  const storage = new Storage({
    keyFilename: 'metrics-processor-service-key.json'
  })
  console.log('INSIDE CREATE PIPELINE')

  const readBucket = storage.bucket(bucket)
  const writeBucket = storage.bucket('processed-logs-nodejs')

  readBucket.file(filename).download(function (err, contents) {
    if (err) {
      console.log('ERROR IN DOWNLOAD ', filename, err)
      // callback(500)
      callback()
    } else {
      const stringContents = contents.toString()
      console.log('String length: ', stringContents.length)
      const contentsArray = stringContents.split('\n')
      console.log('Array Length: ', contentsArray.length)
      let results = ''
      for (const line of contentsArray) {
        if (line.length === 0) {
          continue
        }
        try {
          const jsonparse = JSON.parse(line)
          const printout = logTransform2(jsonparse)
          if (printout !== undefined) { results = results.concat(printout) }
        } catch (err) { console.log(err) }
      }

      writeBucket.file(processedFile).save(results, function (err) {
        if (err) {
          console.log('ERROR UPLOADING: ', err)
          const used = process.memoryUsage()
          for (const key in used) {
            console.log(`${key} ${Math.round(used[key] / 1024 / 1024 * 100) / 100} MB`)
          }
          callback(500)
        } else {
          console.log('Upload complete')
          const used = process.memoryUsage()
          for (const key in used) {
            console.log(`${key} ${Math.round(used[key] / 1024 / 1024 * 100) / 100} MB`)
          }
          callback(200)
        }
      })
    }
  })
}

app.post('/', async (req, res) => {
  if (!req.body) {
    const msg = 'No Pub/Sub Message received'
    console.error(msg)
    res.status(400).send('Bad Request: ' + msg)
    return
  }
  if (!req.body.message) {
    const msg = 'invalid Pub/Sub message format'
    console.error(`error: ${msg}`)
    res.status(400).send(`Bad Request: ${msg}`)
    return
  }
  const eventType = req.body.message.attributes.eventType

  if (eventType !== 'OBJECT_FINALIZE') {
    const msg = `Event type is ${eventType} not OBJECT_FINALIZE`
    console.error(`error ${msg}`)
    res.status(400).send(`Bad Request: ${msg}`)
    return
  }

  const bucket = req.body.message.attributes.bucketId
  const filename = req.body.message.attributes.objectId
  console.log('EVENT TYPE: ', eventType)
  processLogs(bucket, filename, function (status) {
    res.status(status).send()
  })
})

const port = process.env.PORT || 8080
app.listen(port, () => {
  console.log('Listening on port: ', port)
})

module.exports = app
