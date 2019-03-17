'use strict'

const fs = require('fs')
const os = require('os')
const path = require('path')

const jsonist = require('jsonist')
    , chalk   = require('chalk')

// Read `.ncurc` file (from node-core-utils) for Jenkins token. This is brittle
// but the script is currently not working for anyone. Probably a good idea to
// add some error handling and a way to load the API key from an environment
// variable or something else.

const config = JSON.parse(fs.readFileSync(path.join(os.homedir(), '.ncurc')))

function rnd (d) {
  return Math.round(d * 100) / 100
}


function log (t, s) {
  if (t == 'bad')
    s = chalk.bold(chalk.red(s))
  if (t == 'title')
    s = chalk.bold(chalk.yellow(s))
  if (t == 'good')
    s = chalk.bold(s)
  console.log(s)
}


function onData (err, computers) {
  if (err)
    throw err

  computers.computer.forEach(function (c) {
    if (!c.offline && !c.temporarilyOffline)
      return

    let dsm = c.monitorData['hudson.node_monitors.DiskSpaceMonitor']
      , disk = dsm && dsm.size && rnd(dsm.size / 1014 / 1024 / 1024)
      , tsm = c.monitorData['hudson.node_monitors.TemporarySpaceMonitor']
      , temp = tsm && tsm.size && rnd(tsm.size / 1024 / 1024 / 1024)

    log('title', c.displayName)
    log('plain', `\t               Idle: ${c.idle}`)
    log(c.offline ? 'bad' : 'good', `\t            Offline: ${c.offline}`)
    log(c.temporarilyOffline ? 'bad' : 'good', `\tTemporarily offline: ${c.temporarilyOffline}`)
    log('plain', `\t               Disk: ${disk || '?'} G`)
    log('plain', `\t     Temporary disk: ${temp || '?'} G`)
  })
}

const apiUrl = `https://${config.username}:${config.jenkins_token}@ci.nodejs.org/computer/api/json?token=TOKEN`
jsonist.get(apiUrl, onData)
