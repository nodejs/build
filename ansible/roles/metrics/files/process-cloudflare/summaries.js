#!/usr/bin/env node

// data example:
//
// day,country,region,path,version,os,arch,bytes
// 2019-10-31,US,,/dist/v13.0.1/node-v13.0.1-linux-x64.tar.xz,v13.0.1,linux,x64,20102340
//

const { pipeline, Transform } = require('stream')
const split2 = require('split2')
const { Storage } = require('@google-cloud/storage')

const csvStream = new Transform({
  readableObjectMode: true,
  transform (chunk, encoding, callback) {
    try {
      const schunk = chunk.toString()
      if (!schunk.startsWith('day,country')) { // ignore header
        this.push(schunk.split(','))
      }
      callback()
    } catch (e) {
      callback(e)
    }
  }
})

const counts = { bytes: 0, total: 0 }
function increment (type, key) {
  if (!key) {
    key = 'unknown'
  }

  if (!counts[type]) {
    counts[type] = {}
  }

  if (counts[type][key] === undefined) {
    counts[type][key] = 1
  } else {
    counts[type][key]++
  }
}

function prepare () {
  function sort (type) {
    const ca = Object.entries(counts[type])
    ca.sort((e1, e2) => e2[1] > e1[1] ? 1 : e2[1] < e1[1] ? -1 : 0)
    counts[type] = ca.reduce((p, c) => {
      p[c[0]] = c[1]
      return p
    }, {})
  }

  'country version os arch'.split(' ').forEach(sort)
}

const summaryStream = new Transform({
  writableObjectMode: true,
  transform (chunk, encoding, callback) {
    const [date, country, region, path, version, os, arch, bytes] = chunk
    increment('country', country)
    increment('version', version)
    increment('os', os)
    increment('arch', arch)
    counts.bytes += parseInt(bytes, 10)
    counts.total++
    callback()
  }
})

const storage = new Storage({
  keyFilename: "metrics-processor-service-key.json",
});

storage.bucket('processed-logs-nodejs').getFiles({ prefix: '20210112/'}, function(err, files) {
  if (!err){
    for (const file of files){
      //storage.bucket('processed-logs-nodejs').file('20210114/20210114T081500Z_20210114T082000Z').download(function(err, contents) {
        // if (err) {
        //   console.log("ERROR IN DOWNLOAD ",  err);
        //   // callback(500);
        //   callback();
        // } else {
        // const stringContents = contents.toString()
        // console.log("String length: ", stringContents.length)
        // const contentsArray = stringContents.split('\n');
        // console.log("Array Length: ", contentsArray.length)
        // let results = ""
        // for (const line of contentsArray){
        //   x++
        //   try {
        //     const csvparse = csvStream(line)
        //     console.log(csvparse);
        //     //const printout = logTransform2(jsonparse)
        //     //if (printout != undefined) { results = results.concat(printout)}
        //   } catch (err) {console.log(err)}
        // }


      pipeline(
        storage.bucket('processed-logs-nodejs').file(file.name).createReadStream(),
        split2(),
        csvStream,
        summaryStream,
        (err) => {
          prepare()
          console.log(JSON.stringify(counts, null, 2))
          if (err) {
            console.error('ERROR', err)
            process.exit(1)
          }
        }
      )
}
}
})

// pipeline(
//   process.stdin,
//   split2(),
//   csvStream,
//   summaryStream,
//   (err) => {
//     prepare()
//     console.log(JSON.stringify(counts, null, 2))
//     if (err) {
//       console.error('ERROR', err)
//       process.exit(1)
//     }
//   }
// )
