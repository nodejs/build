"use strict"

const ghrepos = require('ghrepos')


function latestCommit (type, ref, config, callback) {
  ghrepos.getRef(
      { user: config.githubAuthUser, token: config.githubAuthToken }
    , config.githubOrg
    , config.githubRepo
    , ref
    , function (err, data) {
        if (err)
          return callback(err)

        if (!data || !data.object)
          return callback(new Error(`Got unexpected data from GitHub: ${JSON.stringify(data)}`))

        return callback(null, data.object.sha)
    }
  )
}



module.exports = latestCommit
