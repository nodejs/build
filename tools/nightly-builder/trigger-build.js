"use strict";

const hyperquest = require('hyperquest')
    , bl         = require('bl')
    , qs         = require('querystring')


const urlbase      = 'https://jenkins-iojs.nodesource.com/job/iojs+release/build?token='
    , buildUser    = 'iojs'
    , buildProject = 'io.js'


function triggerBuild(token, options, callback) {
  let url  = `${urlbase}${token}`
    , data = {
          parameter : [
              {
                  name  : 'user'
                , value : buildUser
              }
            , {
                  name  : 'project'
                , value : buildProject
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
                  name  : 'buildtype'
                , value : options.type
              }
          ]
      }
    , post = qs.encode({
          token : token
        , json  : JSON.stringify(data)
      })

  let req = hyperquest(url, {
      method: 'post'
    , headers: { 'content-type': 'application/x-www-form-urlencoded' }
  })
  req.end(post)
  req.pipe(bl(callback))
}


module.exports = triggerBuild
