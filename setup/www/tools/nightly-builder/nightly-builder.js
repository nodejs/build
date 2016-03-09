"use strict"

/* config file example:

{
  "jenkinsToken": "X",
  "jenkinsJobUrl": "https://ci-release.nodejs.org/job/iojs+release",
  "githubAuthUser": "node-forward-bot",
  "githubAuthToken": "X",
  "githubOrg": "nodejs",
  "githubRepo": "https://github.com/nodejs/node.git",
  "githubScheme": "https://github.com/",
  "releaseUrlBase": "https://nodejs.org/download/"
}

*/

const argv          = require('minimist')(process.argv.slice(2))
    , inspect       = require('util').inspect
    , xtend         = require('xtend')
    , buildRequired = require('./build-required')
    , triggerBuild  = require('./trigger-build')
    , config        = argv.config && require(argv.config)

if (typeof argv.type != 'string'
    || !/^(nightly|next-nightly)$/.test(argv.type)
    || typeof argv.ref != 'string'
    || !config
    || typeof config.jenkinsToken    != 'string'
    || typeof config.jenkinsJobUrl   != 'string'
    || typeof config.githubAuthToken != 'string'
    || typeof config.githubAuthUser  != 'string'
    || typeof config.githubRepo      != 'string'
    || typeof config.githubOrg       != 'string'
    || typeof config.githubScheme    != 'string'
  ) {

  console.error('Usage: nightly-builder --type <nightly|next-nightly> --ref <git head ref> --config <config file>')
  return process.exit(1)
}

buildRequired(argv.type, argv.ref, argv.force, config, function (err, data) {
  if (err)
    throw err

  if (!data)
    return console.log('No build required')

  triggerBuild(xtend(data, config), function (err) {
    if (err)
      throw err

    console.log(`Build triggered: ${inspect(data)}`)
  })
})
