"use strict"

const ghrepos = require('ghrepos')

const typeRefs = {
          'nightly'      : 'heads/master'
        , 'next-nightly' : 'heads/next'
      }


function latestCommit (type, callback) {
  let ref = typeRefs[type]

  if (!ref)
    throw new Error(`Unknown type "${type}"`)

  ghrepos.getRef(null, 'nodejs', 'io.js', ref, function (err, data) {
    if (err)
      return callback(err)

    if (!data || !data.object)
      return callback(new Error(`Got unexpected data from GitHub: ${JSON.stringify(data)}`))

    return callback(null, data.object.sha)
  })
}



module.exports = latestCommit
