#!/usr/bin/env node

// data example:
//
// day,country,region,path,version,os,arch,bytes
// 2019-10-31,US,,/dist/v13.0.1/node-v13.0.1-linux-x64.tar.xz,v13.0.1,linux,x64,20102340
//

const { Storage } = require('@google-cloud/storage')
const moment = require('moment')


function csvStream (chunk) {
    try {
      const line = []
      const schunk = chunk.toString()
      if (!schunk.startsWith('day,country')) { // ignore header
        line.push(schunk.split(','))
        return(line)
      }
      return
    } catch (e) {
      console.log(e)
    }
  
}

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

function summary (chunk) {
  const [date, country, region, path, version, os, arch, bytes] = chunk[0]
  increment('country', country)
  increment('version', version)
  increment('os', os)
  increment('arch', arch)
  counts.bytes += parseInt(bytes, 10)
  counts.total++
  return
 }

async function collectData () {

  const storage = new Storage({
    keyFilename: "metrics-processor-service-key.json",
  });

  let date = moment(new Date())
  date = moment(date, 'YYYYMMDD').subtract(1, 'days').format('YYYYMMDD')
  const filePrefix = date.toString().concat('/')
  console.log(filePrefix)

  const [files] = await storage.bucket('processed-logs-nodejs').getFiles({ prefix: `${filePrefix}`})
  for (const file of files){
    const data = await storage.bucket('processed-logs-nodejs').file(file.name).download() 
    const stringContents = data[0].toString()
    const contentsArray = stringContents.split('\n')
          
    for (const line of contentsArray) {
      try {
        const csvparse = csvStream(line)
        if (csvparse !== undefined && csvparse[0][0] !== '') { summary(csvparse) }
      } catch (err) { console.log(err) }
    }
    }
}

async function produceSummaries () {
  await collectData()
  prepare()
  console.log(counts)
}

produceSummaries()
