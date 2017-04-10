#!/usr/bin/env node


const through2  = require('through2')
    , split2    = require('split2')


if (process.argv.length < 3) {
  console.error('cat log | json-log-filter.js [<regex>[, <regex>[, <regex>...]]]')
  process.exit(1)
}


const matches = process.argv.slice(2).map(function argvToGlob (s) {
  return new RegExp(s)
})


const jsonify = through2.obj(function jsonifyLine (chunk, enc, callback) {
  let data = null
  try {
    data = JSON.parse(chunk)
  } catch (e) {}
  callback(null, data)
})


const filterResponse = through2.obj(function filterResponseLine (chunk, enc, callback) {
  if (((chunk.edgeResponse && chunk.edgeResponse.status == 200) || 
      (chunk.originResponse && chunk.originResponse.status == 200)) &&
      chunk.edgeResponse.bytes > 10) {
    return callback(null, chunk)
  }
  callback()
})


const filterUri = through2.obj(function filterUriLine (chunk, enc, callback) {
  for (let i = 0; i < matches.length; i++)
    if (matches[i].test(chunk.clientRequest.uri))
      return callback(null, chunk)
  callback()
})


const outWrite = through2.obj(function outWriteLine (chunk, enc, callback) {
  callback(null, `${JSON.stringify(chunk)}\n`)
})


process.stdin
  .pipe(split2())
  .pipe(jsonify)
  .pipe(filterResponse)
  .pipe(filterUri)
  .pipe(outWrite)
  .pipe(process.stdout)

