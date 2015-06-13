"use strict"

const strftime     = require('strftime').timezone(0)
    , after        = require('after')
    , latestBuild  = require('./latest-build')
    , latestCommit = require('./latest-commit')

const dateFormat = '%Y%m%d'


function timeString () {
  return strftime(dateFormat)
}


function buildRequired (type, callback) {
  let done = after(2, onData)
    , build
    , commit

  function onData (err) {
    if (err)
      return callback(err)

    let buildCommit = build.commit.substr(0, 10)
      , buildDate   = strftime(dateFormat, build.date)
      , nowDate     = timeString()

    commit = commit.substr(0, 10)

    if (buildCommit != commit) // only need to compare commit
      return callback(null, { type: type, commit: commit, date: nowDate })

    return callback()
  }

  latestBuild(type, function (err, data) {
    build = data
    done(err)
  })

  latestCommit(type, function (err, data) {
    commit = data
    done(err)
  })
}


module.exports = buildRequired