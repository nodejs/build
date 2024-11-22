#!/usr/bin/env node

const fs = require('fs').promises
const path = require('path')

const versionRe = /^v\d+\.\d+\.\d+/
const additionalDistAssets = [
  'SHASUMS256.txt',
  'SHASUMS256.txt.asc',
  'SHASUMS256.txt.sig'
]

const stagingDir = process.argv[2]
const distDir = process.argv[3]

// `check_assets.js test` kicks it into test mode
if (stagingDir === 'test') {
  test()
} else {
  checkArgs().then(execute).catch(console.error)
}

// must provide a valid staging directory that exists and a valid dist dir name
async function checkArgs () {
  let bad = false
  let dirStat

  if (stagingDir && distDir) {
    try {
      dirStat = await fs.stat(stagingDir)
    } catch (e) {}

    if (!dirStat || !dirStat.isDirectory()) {
      bad = true
      console.error('Staging directory not found')
    }

    if (!versionRe.test(path.basename(stagingDir))) {
      bad = true
      console.error(`Bad staging directory name: ${stagingDir}`)
    }

    if (!distDir || !versionRe.test(path.basename(distDir))) {
      bad = true
      console.error(`Bad dist directory name: ${distDir}`)
    }
  } else {
    bad = true
  }

  if (bad) {
    console.error('Usage: check_assets.js <path to staging directory> <path to dist directory>')
    process.exit(1)
  }
}

// equivalent to `find -maxdepth 2`
async function lsDepth2 (dir, isStaging) {
  let assets = []

  let subdirs
  try {
    subdirs = await ls(dir, isStaging)
  } catch (e) {
    return assets
  }
  await Promise.all(subdirs.map((dir) => ls(dir, false)))
  assets.sort()
  return assets

  // convenience fs.stat that preserves the original path across async calls
  async function statPlus (file) {
    const stat = await fs.stat(file)
    return { stat: stat, path: file }
  }

  // ls <dir> plus a stat on each file so we know if there are directories
  // each entry is pushed to `assets` with directories having a trailing '/'
  // return the directory entries in an array
  async function ls (subdir, onlyDone) {
    let files = await fs.readdir(subdir)
    if (onlyDone) {
      files = files.filter((f) => {
        // include only files with an additional file by the same name with a
        // .done extension, this is how staging is organised
        return files.includes(`${f}.done`)
      })
    }
    let stats = await Promise.all(files.map((a) => statPlus(path.join(subdir, a))))
    stats.forEach((s) => {
      assets.push(`${path.relative(dir, s.path)}${s.stat.isDirectory() ? '/' : ''}`)
    })
    return stats.filter((s) => s.stat.isDirectory()).map((s) => s.path)
  }
}

function versionToLine (version) {
  return version.replace(/^(v\d+)\.[\d.]+.*/g, '$1.x')
}

async function loadExpectedAssets (version, line) {
  if (!line) {
    line = versionToLine(version)
  }
  try {
    const templateFile = path.join(__dirname, 'expected_assets', line)
    let files = await fs.readFile(templateFile, 'utf8')
    return files.replace(/{VERSION}/g, version).split(/\n/g).filter(Boolean)
  } catch (e) { }
  return null
}

function intersection (a1, a2) {
  return a1.filter((e) => a2.includes(e))
}

function union (a1, a2) {
  let u = [].concat(a1)
  a2.forEach((e) => {
    if (!a1.includes(e)) {
      u.push(e)
    }
  })
  return u
}

async function execute () {
  console.log('... Checking assets')

  let caution = false
  let update = false

  const version = path.basename(stagingDir)
  const line = versionToLine(version)
  const lineI = parseInt(line.replace(/[v.x]/g, ''), 10)
  let expectedLineI

  // load asset lists
  const stagingAssets = await lsDepth2(stagingDir, true)
  let distAssets = await lsDepth2(distDir, false)
  distAssets = distAssets.filter((a) => !additionalDistAssets.includes(a))
  let expectedAssets

  // load expected asset list, use a prior version if one isn't available for this line
  for (let i = 0; expectedAssets == null && i < 2; i++) {
    expectedLineI = lineI - i
    expectedAssets = await loadExpectedAssets(version, `v${expectedLineI}.x`)
  }

  // No expected asset list available for this line, wut?
  if (!expectedAssets) {
    console.log(` \u001b[31m\u001b[1m✖\u001b[22m\u001b[39m  No expected asset list is available for ${line}, does one need to be created?`)
    console.log(`    https://github.com/nodejs/build/tree/main/ansible/www-standalone/tools/promote/expected_assets/${line}`)
    process.exit(0)
  }

  // Picked an older release line that did have an expected asset list, better warn
  if (expectedLineI !== lineI) {
    console.log(` \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  No expected asset list is available for ${line}, using the list for v${expectedLineI}.x instead`)
    console.log(`    Should a new list be created for ${line}?`)
    console.log(`    https://github.com/nodejs/build/tree/main/ansible/www-standalone/tools/promote/expected_assets/${line}`)
  }

  // generate comparison lists
  const stagingDistIntersection = intersection(stagingAssets, distAssets)
  const stagingDistUnion = union(stagingAssets, distAssets)
  let notInActual = expectedAssets.filter((a) => !stagingDistUnion.includes(a))
  let stagingNotInExpected = stagingAssets.filter((a) => !expectedAssets.includes(a))
  let distNotInExpected = distAssets.filter((a) => !expectedAssets.includes(a))

  console.log(`... Expecting a total of ${expectedAssets.length} assets for ${line}`)
  console.log(`... ${stagingAssets.length} assets waiting in staging`)

  // what might be overwritten by promotion?
  if (stagingDistIntersection.length) {
    caution = true
    console.log(` \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  ${stagingDistIntersection.length} assets already promoted will be overwritten, is this OK?`)
    if (stagingDistIntersection.length <= 10) {
      stagingDistIntersection.forEach((a) => console.log(`    • ${a}`))
    }
  } else {
    console.log(`... ${distAssets.length} assets already promoted`)
  }

  if (!notInActual.length) { // perfect staging state, we have everything we need
    console.log(` \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for ${line}`)
  } else { // missing some assets and they're not in staging, are you impatient?
    caution = true
    console.log(` \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  The following assets are expected for ${line} but are currently missing from staging:`)
    notInActual.forEach((a) => console.log(`    • ${a}`))
  }

  // bogus unexpected files found in staging, not good
  if (stagingNotInExpected.length) {
    caution = true
    update = true
    console.log(` \u001b[31m\u001b[1m✖\u001b[22m\u001b[39m  The following assets were found in staging but are not expected for ${line}:`)
    stagingNotInExpected.forEach((a) => console.log(`    • ${a}`))
  }

  // bogus unexpected files found in dist, not good
  if (distNotInExpected.length) {
    caution = true
    update = true
    console.log(` \u001b[31m\u001b[1m✖\u001b[22m\u001b[39m  The following assets were already promoted but are not expected for ${line}:`)
    distNotInExpected.forEach((a) => console.log(`    • ${a}`))
  }

  // do we need to provide final notices?
  if (update) {
    console.log(`    Does the expected assets list for ${line} need to be updated?`)
    console.log(`    https://github.com/nodejs/build/tree/main/ansible/www-standalone/tools/promote/expected_assets/${line}`)
  }
  if (caution) {
    console.log('    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m')
  }
}
