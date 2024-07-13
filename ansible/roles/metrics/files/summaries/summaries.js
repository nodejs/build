// data example:
//
// day,country,region,path,version,os,arch,bytes
// 2019-10-31,US,,/dist/v13.0.1/node-v13.0.1-linux-x64.tar.xz,v13.0.1,linux,x64,20102340
//

const { Storage } = require('@google-cloud/storage')
const express = require('express')
const app = express()

app.use(express.json())

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

// ToDo: Remove global variable when refactoring.
const cache = {}

function increment (date, type, key) {
  const counts = cache[date]
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

function prepare (date) {
  const counts = cache[date]
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

function summary (date, chunk) {
  const [, country, region, path, version, os, arch, bytes] = chunk[0]

  if (!cache[date]) {
    cache[date] = { bytes: 0, total: 0 }
  }

  increment(date, 'country', country)
  increment(date, 'version', version)
  increment(date, 'os', os)
  increment(date, 'arch', arch)
  cache[date].bytes += parseInt(bytes, 10)
  cache[date].total++
  return
 }

async function collectData (date) {
  const storage = new Storage()
  const filePrefix = date.toString().concat('/')
  console.log(filePrefix)
  const [files] = await storage.bucket('processed-logs-nodejs').getFiles({ prefix: `${filePrefix}`})
  for (const file of files) {
    const data = await storage.bucket('processed-logs-nodejs').file(file.name).download()
    const stringContents = data[0].toString()
    const contentsArray = stringContents.split('\n')
    for (const line of contentsArray) {
      try {
        const csvparse = csvStream(line)
        if (csvparse !== undefined && csvparse[0][0] !== '') { summary(date, csvparse) }
      } catch (err) { console.log(err) }
    }
  }
}

async function produceSummaries (date) {
  const storage = new Storage()
  await collectData(date)
  prepare(date)

  const fileContents = JSON.stringify(cache[date])
  const fileName = `nodejs.org-access.log.${date.toString()}.json`
  try {
    await storage.bucket('access-logs-summaries-nodejs').file(fileName).save(fileContents)
    console.log(`Upload complete: ${fileName}`)
  } catch (error) {
    console.error(`ERROR UPLOADING FILE: ${fileName} - ${error}`)
  }
}

app.post('/', async (req, res) => {
  const yesterday = new Date().getTime() - (24 * 60 * 60 * 1000)
  const date = new Date(yesterday).toISOString().slice(0, 10).replace(/-/g, '')
  await produceSummaries(date)
  res.status(200).send()
})

app.post('/date/:date', async (req, res) => {
  const date = req.params.date

  if (!/^\d{8}$/.test(req.params.date)) {
    res.status(400).send('Invalid date. Must be in YYYYMMDD format.')
    return
  }

  await produceSummaries(date)
  res.status(200).send()
})

const port = process.env.PORT || 8080
app.listen(port, () => {
  console.log('Listening on port: ', port)
})

module.exports = app
