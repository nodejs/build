"use strict"

const jsonist = require('jsonist')

const indexUrl = 'https://iojs.org/download/{type}/index.json'


function latestBuild (type, callback) {
  let url = indexUrl.replace(/\{type\}/, type)

  function onGet (err, data) {
    if (err)
      return callback(err)

    let i = -1

    while (data[++i]) {
      let m      = data[i].version.match(/nightly(20\d\d)(\d\d)(\d\d)(\w{10,})/)
        , date   = new Date(m && `${m[1]}-${m[2]}-${m[3]}` || data[i].date)
        , commit = m && m[4]

      if (m && commit) {
        return callback(null, {
            version : data[i].version
          , date    : date
          , commit  : commit
        })
      }
    }

    return callback(new Error(`no latest version for "${type}"`))
  }

  jsonist.get(url, onGet)
}


module.exports = latestBuild

latestBuild('nightly', function (err, data) {
  if (err)
    throw err

  console.log('data', data)
})
