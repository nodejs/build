#!/usr/bin/env node

const { pipeline, Transform } = require('stream')
const split2 = require('split2')
const strftime = require('strftime').timezone(0)
const {Storage} = require('@google-cloud/storage');
const express = require('express');
const bodyParser = require('body-parser');
const app = express();

app.use(bodyParser.json());

const storage = new Storage({keyFilename: "metrics-processor-service-key.json"});

const jsonStream = new Transform({
  readableObjectMode: true,
  transform (chunk, encoding, callback) {
    try {
      this.push(JSON.parse(chunk.toString()))
      callback()
    } catch (e) {
      callback()
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


async function processLogs (bucket, filename) {
  console.log('Node version is: ' + process.version);
  console.log("BUCKET " + bucket);
  console.log("FILENAME " + filename);
  let processedFile = filename.split(".")[0];
  processedFile = processedFile.split("_")[0].concat("_", processedFile.split("_")[1]);
  console.log("PROCESSEDFILENAME " + processedFile);



  return new Promise((resolve, reject) => {
    pipeline(
      storage.bucket(bucket).file(filename).createReadStream()
      .on("close", () => {
        console.log("Stream closed");
      })
      .on("end", () => {
        console.log("READ STREAM ENDED");
      }),
      split2(),
      jsonStream,
      logTransformStream,
      //storage.bucket('processed-logs-nodejs').file(processedFile).createWriteStream({ resumable: false }),
      process.stdout
      .on("end", () => {
        console.log("FINISHED");
      }),
      (err) => {
        if (err) {
          console.log("PIPELINE HAS FAILED", err)
          reject();
        } else {
          console.log("PIPELINE SUCCESS")
          resolve();
        }
      }
    )
    .on("error", (err) =>{
      console.log("ERROR IN PIPELINE, ", err);
    })
  })
}


app.post('/', async (req, res) => {

  if (!req.body) {
    const msg = "No Pub/Sub Message received";
    console.error(msg);
    res.status(400).send("Bad Request: " + msg);
    return;
  }
  if (!req.body.message) {
    const msg = 'invalid Pub/Sub message format';
    console.error(`error: ${msg}`);
    res.status(400).send(`Bad Request: ${msg}`);
    return;
  }

  const eventType = req.body.message.attributes.eventType;

  if (eventType != "OBJECT_FINALIZE"){
    const msg = `Event type is ${eventType} not OBJECT_FINALIZE`;
    console.error(`error ${msg}`);
    res.status(400).send(`Bad Request: ${msg}`);
    return;
  }

  const bucket = req.body.message.attributes.bucketId;
  const filename = req.body.message.attributes.objectId;
  console.log("EVENT TYPE: ", eventType);

  await processLogs(bucket, filename);

  res.status(200).send();
});

const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log("Listening on port: ", port);
});

module.exports = app;
