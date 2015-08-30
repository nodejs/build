"use strict"

const argv          = require('minimist')(process.argv.slice(2))
    , inspect       = require('util').inspect
    , buildRequired = require('./build-required')
    , triggerBuild  = require('./trigger-build')


if (typeof argv.type != 'string'
    || !/^(nightly|next-nightly)$/.test(argv.type)
    || typeof argv.token != 'string') {

  console.error('Usage: nightly-builder --type <nightly|next-nightly> --token <jenkins job token>')
  return process.exit(1)
}

buildRequired(argv.type, function (err, data) {
  if (err)
    throw err

  if (!data)
    return console.log('No build required')

  triggerBuild(argv.token, data, function (err) {
    if (err)
      throw err

    console.log(`Build triggered: ${inspect(data)}`)
  })
})