"use strict"

const ghrepos = require('ghrepos')


function latestCommit (type, ref, callback) {
  ghrepos.getRef(null, 'nodejs', 'node', ref, function (err, data) {
    if (err)
      return callback(err)

    if (!data || !data.object)
      return callback(new Error(`Got unexpected data from GitHub: ${JSON.stringify(data)}`))

    return callback(null, data.object.sha)
  })
}



module.exports = latestCommit
