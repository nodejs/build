#!/usr/bin/env node

// data example:
//
// day,country,region,path,version,os,arch,bytes
// 2019-10-31,US,,/dist/v13.0.1/node-v13.0.1-linux-x64.tar.xz,v13.0.1,linux,x64,20102340
//

const { pipeline, Transform } = require('stream')
const split2 = require('split2')

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

pipeline(
  process.stdin,
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
