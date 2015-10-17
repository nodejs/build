"use strict";

const hyperquest = require('hyperquest')
    , bl         = require('bl')
    , qs         = require('querystring')


const urlbase    = 'https://ci.nodejs.org/job/iojs+release/build?token='
    , repository = 'https://github.com/nodejs/node.git'


function triggerBuild(token, options, callback) {
  let url  = `${urlbase}${token}`
    , data = {
          token     : token
        , parameter : [
              {
                  name  : 'repository'
                , value : repository
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
                , value : `https://nodejs.org/download/${options.type}/`
              }
            , {
                  name  : 'rc'
                , value : '0'
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
