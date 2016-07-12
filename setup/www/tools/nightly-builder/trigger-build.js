"use strict";

const hyperquest = require('hyperquest')
    , jsonist    = require('jsonist')
    , bl         = require('bl')
    , qs         = require('querystring')



function triggerBuild(options, callback) {
  let url  = `${options.jenkinsJobUrl}/build?token=${options.jenkinsToken}`
    , auth = `${options.githubAuthUser}:${options.githubAuthToken}`
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

  if (!options.jenkinsCrumbUrl)
    return requestTrigger()

  jsonist.get(options.jenkinsCrumbUrl, { auth: auth }, function (err, data) {
    if (err)
      return callback(err)

    requestTrigger(data)
  })

  function requestTrigger (crumb) {
    let postData = {
            token    : options.jenkinsToken
          , json     : JSON.stringify(data)
        }
      , post
      , req

    postData[crumb.crumbRequestField] = crumb.crumb
    post = qs.encode(postData)
    req = hyperquest(url, {
        method   :  'post'
      , headers  : { 'content-type' : 'application/x-www-form-urlencoded' }
      , auth     : auth
    })

    req.end(post)
    req.pipe(bl(callback))
  }
}


module.exports = triggerBuild
