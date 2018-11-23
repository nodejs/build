#!/usr/bin/env node

const fs = require('fs').promises
const path = require('path')
const childProcess = require('child_process')
const assert = require('assert')

const versionRe = /^v\d+\.\d+\.\d+$/

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

  if (bad) {
    console.error('Usage: check_assets.js <path to staging directory>')
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
  return version.replace(/^(v\d+)\.[\d.]+$/g, '$1.x')
}

async function loadExpectedAssets (version, line) {
  if (!line) {
    line = versionToLine(version)
  }
  try {
    const templateFile = path.join(__dirname, 'expected_assets', line)
    let files = await fs.readFile(templateFile, 'utf8')
    return files.replace(/{VERSION}/g, version).split(/\n/g)
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
  const version = path.basename(stagingDir)
  const line = versionToLine(version)
  const lineI = parseInt(line.replace(/[v.x]/g, ''), 10)
  let expectedLineI

  const stagingAssets = await lsDepth2(stagingDir, true)
  const distAssets = await lsDepth2(distDir, false)
  let expectedAssets

  // load expected asset list, use a prior version if one isn't available for this line
  for (let i = 0; expectedAssets == null && i < 2; i++) {
    expectedLineI = lineI - i
    expectedAssets = await loadExpectedAssets(version, `v${expectedLineI}.x`)
  }

  // No expected asset list available for this line, wut?
  if (!expectedAssets) {
    console.log(` \u001b[31m\u001b[1m✖\u001b[22m\u001b[39m  No expected asset list is available for ${line}, does one need to be created?`)
    console.log(`    https://github.com/nodejs/build/tree/master/setup/www/tools/promote/expected_assets/${line}`)
    process.exit(0)
  }

  // Picked an older release line that did have an expected asset list, better warn
  if (expectedLineI !== lineI) {
    console.log(` \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  No expected asset list is available for ${line}, using the list for v${expectedLineI}.x instead`)
    console.log(`    Should a new list be created for ${line}?`)
    console.log(`    https://github.com/nodejs/build/tree/master/setup/www/tools/promote/expected_assets/${line}`)
  }

  console.log(`... Expecting a total of ${expectedAssets.length} assets for ${line}`)
  console.log(`... ${stagingAssets.length} assets waiting in staging`)

  // what might be overwritten by promotion?
  const stagingDistIntersection = intersection(stagingAssets, distAssets)
  if (stagingDistIntersection.length) {
    caution = true
    console.log(` \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  ${stagingDistIntersection.length} assets already promoted will be overwritten, is this OK?`)
    if (stagingDistIntersection.length <= 10) {
      stagingDistIntersection.forEach((a) => console.log(`    • ${a}`))
    }
  } else {
    console.log(`... ${distAssets.length} assets already promoted`)
  }

  const stagingDistUnion = union(stagingAssets, distAssets)
  let notInActual = []
  let stagingNotInExpected = []

  for (let asset of expectedAssets) {
    if (!stagingDistUnion.includes(asset)) {
      notInActual.push(asset)
    }
  }

  for (let asset of stagingAssets) {
    if (!expectedAssets.includes(asset)) {
      stagingNotInExpected.push(asset)
    }
  }

  if (!notInActual.length && !stagingNotInExpected.length) { // perfect staging state, we have everything we need
    console.log(` \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for ${line}`)
  } else if (notInActual.length) { // missing some assets and they're not in staging, are you impatient?
    caution = true
    console.log(` \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  The following assets are expected for ${line} but are currently missing from staging:`)
    notInActual.forEach((a) => console.log(`    • ${a}`))
  } else if (stagingNotInExpected.length) { // bogus unexpected files found, not good
    caution = true
    console.log(` \u001b[31m\u001b[1m✖\u001b[22m\u001b[39m  The following assets were found but are not expected for ${line}:`)
    stagingNotInExpected.forEach((a) => console.log(`    • ${a}`))
    console.log(`    Does the expected assets list for ${line} need to be updated?`)
    console.log(`    https://github.com/nodejs/build/tree/master/setup/www/tools/promote/expected_assets/${line}`)
  }

  if (caution) {
    console.log('    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m')
  }
}

/* TESTS ***********************************************************************/

function test () {
  // makes a staging or dist directory given a version string
  async function makeFixture (version, isStaging, dir, assets) {
    if (!assets) {
      assets = await loadExpectedAssets(version)
    }
    for (let asset of assets) {
      let absoluteAsset = path.join(dir, asset)
      if (asset.endsWith('/')) {
        await fs.mkdir(absoluteAsset, { recursive: true })
      } else {
        await fs.writeFile(absoluteAsset, asset, 'utf8')
      }
      let dashPos = isStaging && asset.indexOf('/')
      if (isStaging && (dashPos === -1 || dashPos === asset.length - 1)) {
        // in staging, all files and directories that are ready have a
        // duplicate empty file with .done in the name
        await fs.writeFile(absoluteAsset.replace(/\/?$/, '.done'), asset, 'utf8')
      }
    }
    return assets
  }

  async function rimraf (dir) {
    const stat = await fs.stat(dir)
    if (!stat.isDirectory()) {
      await fs.unlink(dir)
      return
    }
    const ls = await fs.readdir(dir)
    for (let f of ls) {
      f = path.join(dir, f)
      const stat = await fs.stat(f)
      if (stat.isDirectory()) {
        await rimraf(f)
      } else {
        await fs.unlink(f)
      }
    }
    await fs.rmdir(dir)
  }

  // execute check_assets.js with the given staging and dist dirs, collect output
  async function executeMe (stagingDir, distDir) {
    return new Promise((resolve, reject) => {
      const args = [ '--no-warnings', __filename, stagingDir, distDir ]
      childProcess.execFile(process.execPath, args, (err, stdout, stderr) => {
        if (err) {
          return reject(err)
        }
        if (stderr) {
          console.log('STDERR:', stderr)
        }
        resolve(stdout)
      })
    })
  }

  // TEST 1: Everything is in staging, nothing in dist, good to go
  async function test1 () {
    const version = 'v8.13.0'
    const testDir = await fs.mkdtemp(`${__filename}_`)
    const fixtureStagingDir = path.join(testDir, `staging/${version}`)
    const fixtureDistDir = path.join(testDir, `dist/${version}`)
    await makeFixture(version, true, fixtureStagingDir)
    const stdout = await executeMe(fixtureStagingDir, fixtureDistDir)
    console.log('\nTest 1 Assertions ???')
    console.log(`STDOUT------------------------------------------\n\n${stdout}\n------------------------------------------------`)
    assert.equal(stdout, '... Checking assets\n' +
      '... Expecting a total of 44 assets for v8.x\n' +
      '... 44 assets waiting in staging\n' +
      '... 0 assets already promoted\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v8.x\n')
    console.log('Test 1 Assertions ✓✓✓')
    await rimraf(testDir)
  }

  // TEST 2: Not quite everything is in staging, missing two assets, nothing in dist
  async function test2 () {
    const version = 'v10.1.0'
    const testDir = await fs.mkdtemp(`${__filename}_`)
    const fixtureStagingDir = path.join(testDir, `staging/${version}`)
    const fixtureDistDir = path.join(testDir, `dist/${version}`)
    await makeFixture(version, true, fixtureStagingDir)
    await Promise.all([
      fs.unlink(path.join(fixtureStagingDir, 'node-v10.1.0-linux-armv6l.tar.gz')),
      fs.unlink(path.join(fixtureStagingDir, 'node-v10.1.0-linux-armv6l.tar.gz.done')),
      fs.unlink(path.join(fixtureStagingDir, 'node-v10.1.0-linux-armv6l.tar.xz')),
      fs.unlink(path.join(fixtureStagingDir, 'node-v10.1.0-linux-armv6l.tar.xz.done')),
      fs.unlink(path.join(fixtureStagingDir, 'node-v10.1.0.pkg')),
      fs.unlink(path.join(fixtureStagingDir, 'node-v10.1.0.pkg.done'))
    ])
    const stdout = await executeMe(fixtureStagingDir, fixtureDistDir)
    console.log('\nTest 2 Assertions ???')
    console.log(`STDOUT------------------------------------------\n\n${stdout}\n------------------------------------------------`)
    assert.equal(stdout, '... Checking assets\n' +
      '... Expecting a total of 40 assets for v10.x\n' +
      '... 37 assets waiting in staging\n' +
      '... 0 assets already promoted\n' +
      ' \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  The following assets are expected for v10.x but are currently missing from staging:\n' +
      '    • node-v10.1.0-linux-armv6l.tar.gz\n' +
      '    • node-v10.1.0-linux-armv6l.tar.xz\n' +
      '    • node-v10.1.0.pkg\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n'
    )
    console.log('Test 2 Assertions ✓✓✓')
    await rimraf(testDir)
  }

  // TEST 3: Everything in staging, 3 files in dist
  async function test3 () {
    const version = 'v6.0.1'
    const testDir = await fs.mkdtemp(`${__filename}_`)
    const fixtureStagingDir = path.join(testDir, `staging/${version}`)
    const fixtureDistDir = path.join(testDir, `dist/${version}`)
    await makeFixture(version, true, fixtureStagingDir)
    const distAssets = await makeFixture(version, false, fixtureDistDir)
    await Promise.all(
      distAssets.filter((a) => {
        return a !== 'node-v6.0.1-headers.tar.gz' &&
          a !== 'node-v6.0.1.tar.gz' &&
          a !== 'node-v6.0.1-x86.msi' &&
          // deleting all directories, so we don't need to delete the children
          !/^win-x64\/.+/.test(a) &&
          !/^win-x86\/.+/.test(a) &&
          !/^docs\/.+/.test(a)
      }).map((e) => rimraf(path.join(fixtureDistDir, e)))
    )
    const stdout = await executeMe(fixtureStagingDir, fixtureDistDir)
    console.log('\nTest 3 Assertions ???')
    console.log(`STDOUT------------------------------------------\n\n${stdout}\n------------------------------------------------`)
    assert.equal(stdout, '... Checking assets\n' +
      '... Expecting a total of 46 assets for v6.x\n' +
      '... 46 assets waiting in staging\n' +
      ' \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  3 assets already promoted will be overwritten, is this OK?\n' +
      '    • node-v6.0.1-headers.tar.gz\n' +
      '    • node-v6.0.1-x86.msi\n' +
      '    • node-v6.0.1.tar.gz\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v6.x\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n')
    console.log('Test 3 Assertions ✓✓✓')
    await rimraf(testDir)
  }

  // TEST 4: Everything in staging and everything in dist
  async function test4 () {
    const version = 'v11.11.11'
    const testDir = await fs.mkdtemp(`${__filename}_`)
    const fixtureStagingDir = path.join(testDir, `staging/${version}`)
    const fixtureDistDir = path.join(testDir, `dist/${version}`)
    await makeFixture(version, true, fixtureStagingDir)
    await makeFixture(version, false, fixtureDistDir)
    const stdout = await executeMe(fixtureStagingDir, fixtureDistDir)
    console.log('\nTest 4 Assertions ???')
    console.log(`STDOUT------------------------------------------\n\n${stdout}\n------------------------------------------------`)
    assert.equal(stdout, '... Checking assets\n' +
      '... Expecting a total of 40 assets for v11.x\n' +
      '... 40 assets waiting in staging\n' +
      ' \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  40 assets already promoted will be overwritten, is this OK?\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v11.x\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n')
    console.log('Test 4 Assertions ✓✓✓')
    await rimraf(testDir)
  }

  // TEST 5: No expected files list is available for this version, it has to guess
  async function test5 () {
    const version = 'v9.9.9'
    const testDir = await fs.mkdtemp(`${__filename}_`)
    const fixtureStagingDir = path.join(testDir, `staging/${version}`)
    const fixtureDistDir = path.join(testDir, `dist/${version}`)
    // use the 10.x list, which is missing the x86 files, it'll check the 9.x
    const expectedAssets = await loadExpectedAssets(version, 'v10.x')
    await makeFixture(version, true, fixtureStagingDir, expectedAssets)
    const stdout = await executeMe(fixtureStagingDir, fixtureDistDir)
    console.log('\nTest 5 Assertions ???')
    console.log(`STDOUT------------------------------------------\n\n${stdout}\n------------------------------------------------`)
    assert.equal(stdout, '... Checking assets\n' +
      ' \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  No expected asset list is available for v9.x, using the list for v8.x instead\n' +
      '    Should a new list be created for v9.x?\n' +
      '    https://github.com/nodejs/build/tree/master/setup/www/tools/promote/expected_assets/v9.x\n' +
      '... Expecting a total of 44 assets for v9.x\n' +
      '... 40 assets waiting in staging\n' +
      '... 0 assets already promoted\n' +
      ' \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  The following assets are expected for v9.x but are currently missing from staging:\n' +
      '    • node-v9.9.9-linux-x86.tar.gz\n' +
      '    • node-v9.9.9-linux-x86.tar.xz\n' +
      '    • node-v9.9.9-sunos-x86.tar.gz\n' +
      '    • node-v9.9.9-sunos-x86.tar.xz\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n')
    console.log('Test 5 Assertions ✓✓✓')
    await rimraf(testDir)
  }

  // TEST 6: Everything is in dist except for the armv6l files, but they are in staging
  async function test6 () {
    const version = 'v10.0.0'
    const testDir = await fs.mkdtemp(`${__filename}_`)
    const fixtureStagingDir = path.join(testDir, `staging/${version}`)
    const fixtureDistDir = path.join(testDir, `dist/${version}`)
    await fs.mkdir(fixtureStagingDir, { recursive: true })
    await makeFixture(version, true, fixtureStagingDir, [
      'node-v10.0.0-linux-armv6l.tar.gz',
      'node-v10.0.0-linux-armv6l.tar.xz'
    ])
    await makeFixture(version, false, fixtureDistDir)
    await Promise.all([
      fs.unlink(path.join(fixtureDistDir, 'node-v10.0.0-linux-armv6l.tar.gz')),
      fs.unlink(path.join(fixtureDistDir, 'node-v10.0.0-linux-armv6l.tar.xz'))
    ])
    const stdout = await executeMe(fixtureStagingDir, fixtureDistDir)
    console.log('\nTest 6 Assertions ???')
    console.log(`STDOUT------------------------------------------\n\n${stdout}\n------------------------------------------------`)
    assert.equal(stdout, '... Checking assets\n' +
      '... Expecting a total of 40 assets for v10.x\n' +
      '... 2 assets waiting in staging\n' +
      '... 38 assets already promoted\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v10.x\n')
    console.log('Test 6 Assertions ✓✓✓')
    await rimraf(testDir)
  }

  // TEST 7: Some unexpected files in staging
  async function test7 () {
    const version = 'v10.0.0'
    const testDir = await fs.mkdtemp(`${__filename}_`)
    const fixtureStagingDir = path.join(testDir, `staging/${version}`)
    const fixtureDistDir = path.join(testDir, `dist/${version}`)
    await fs.mkdir(fixtureStagingDir, { recursive: true })
    await makeFixture(version, true, fixtureStagingDir, [
      'ooolaalaa.tar.gz',
      'whatdis.tar.xz'
    ])
    await makeFixture(version, false, fixtureDistDir)
    const stdout = await executeMe(fixtureStagingDir, fixtureDistDir)
    console.log('\nTest 7 Assertions ???')
    console.log(`STDOUT------------------------------------------\n\n${stdout}\n------------------------------------------------`)
    assert.equal(stdout, '... Checking assets\n' +
      '... Expecting a total of 40 assets for v10.x\n' +
      '... 2 assets waiting in staging\n' +
      '... 40 assets already promoted\n' +
      ' \u001b[31m\u001b[1m✖\u001b[22m\u001b[39m  The following assets were found but are not expected for v10.x:\n' +
      '    • ooolaalaa.tar.gz\n' +
      '    • whatdis.tar.xz\n' +
      '    Does the expected assets list for v10.x need to be updated?\n' +
      '    https://github.com/nodejs/build/tree/master/setup/www/tools/promote/expected_assets/v10.x\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n')
    console.log('Test 7 Assertions ✓✓✓')
    await rimraf(testDir)
  }

  // run in parallel and just print failures to stderr
  test1().catch(console.error)
  test2().catch(console.error)
  test3().catch(console.error)
  test4().catch(console.error)
  test5().catch(console.error)
  test6().catch(console.error)
  test7().catch(console.error)
}
