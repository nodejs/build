"use strict";

const hyperquest = require('hyperquest')
    , bl         = require('bl')
    , qs         = require('querystring')



function triggerBuild(options, callback) {
  let url  = `${options.jenkinsJobUrl}/build?token=${options.jenkinsToken}`
    , data = {
          token     : options.jenkinsToken
        , parameter : [
              {
                  name  : 'repository'
                , value : `${options.githubScheme}${options.githubOrg}/${options.githubRepo}.git`
              }
            , {
                  name  : 'commit'
                , value : options.commit
              }
            , {
                  name  : 'datestring'
                , value : options.date
              }
            , {
                  name  : 'disttype'
                , value : options.type
              }
            , {
                  name  : 'release_urlbase'
                , value : `${options.releaseUrlBase}${options.type}/`
              }
            , {
                  name  : 'rc'
                , value : '0'
              }
          ]
      }
    , post = qs.encode({
          token : options.jenkinsToken
        , json  : JSON.stringify(data)
      })

  let req = hyperquest(url, {
      method:  'post'
    , headers: { 'content-type': 'application/x-www-form-urlencoded' }
    , auth:    `${options.githubAuthUser}:${options.githubAuthToken}`
  })
  req.end(post)
  req.pipe(bl(callback))
}


module.exports = triggerBuild
