"use strict"

const argv          = require('minimist')(process.argv.slice(2))
    , inspect       = require('util').inspect
    , buildRequired = require('./build-required')
    , triggerBuild  = require('./trigger-build')


if (typeof argv.type != 'string'
    || !/^(nightly|next-nightly)$/.test(argv.type)
    || typeof argv.ref != 'string'
    || typeof argv.token != 'string') {

  console.error('Usage: nightly-builder --type <nightly|next-nightly> --ref <git head ref> --token <jenkins job token>')
  return process.exit(1)
}

buildRequired(argv.type, argv.ref, function (err, data) {
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