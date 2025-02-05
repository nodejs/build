#!/usr/bin/env node

import { exec } from 'node:child_process';
import { readFile } from 'node:fs/promises';
import { basename, join } from 'node:path';

const versionRe = /^v\d+\.\d+\.\d+/
// These are normally generated as part of the release process after the asset
// check, but may be present if a release has already been partially promoted.
const additionalAssets = new Set([
  'SHASUMS256.txt',
  'SHASUMS256.txt.asc',
  'SHASUMS256.txt.sig'
]);

if (process.argv[1] === import.meta.filename) {
  checkArgs(process.argv).then(run(process.argv[2], process.argv[3])).catch(console.error);
}

async function checkArgs (argv) {
  let bad = false;
  if (!argv || argv.length < 4) {
    bad = true;
  } else {
    if (!versionRe.test(basename(argv[2]))) {
      bad = true;
      console.error(`Bad staging directory name: ${argv[2]}`);
    }
    if (!versionRe.test(basename(argv[3]))) {
      bad = true;
      console.error(`Bad dist directory name: ${argv[3]}`);
    }
  }
  if (bad) {
    console.error(`Usage: ${basename(import.meta.filename)} <path to staging directory> <path to dist directory>`);
    process.exit(1);
  }
}

async function loadExpectedAssets (version, line) {
  try {
    const templateFile = join(import.meta.dirname, 'expected_assets', line);
    let files = await readFile(templateFile, 'utf8');
    return files.replace(/{VERSION}/g, version).split(/\n/g).filter(Boolean);
  } catch (e) { }
  return null;
}

async function lsRemoteDepth2 (dir) {
  return new Promise((resolve, reject) => {
    const command = `rclone lsjson ${dir} --no-modtime --no-mimetype -R --max-depth 2`;
    exec(command, {}, (err, stdout, stderr) => {
      if (err) {
        return reject(err);
      }
      if (stderr) {
        console.log('STDERR:', stderr);
      }
      const assets = JSON.parse(stdout).map(({ Path, IsDir }) => {
        if (IsDir) {
          return `${Path}/`;
        }
        return Path;
      })
      resolve(assets);
    });
  });
}

async function run (stagingDir, distDir) {
  const version = basename(stagingDir);
  const line = versionToLine(version);
  const stagingAssets = new Set(await lsRemoteDepth2(stagingDir)).difference(additionalAssets);
  const distAssets = new Set((await lsRemoteDepth2(distDir))).difference(additionalAssets);
  const expectedAssets = new Set(await loadExpectedAssets(version, line));

  let caution = false;
  let update = false;

  // generate comparison lists
  const stagingDistIntersection = stagingAssets.intersection(distAssets);
  const stagingDistUnion = stagingAssets.union(distAssets);
  let notInActual = expectedAssets.difference(stagingAssets);
  let stagingNotInExpected = stagingAssets.difference(expectedAssets);
  let distNotInExpected = distAssets.difference(expectedAssets);

  console.log('... Checking R2 assets');
  // No expected asset list available for this line
  if (expectedAssets.size === 0) {
    console.log(` \u001b[31m\u001b[1m✖\u001b[22m\u001b[39m  No expected asset list is available for ${line}, does one need to be created?`);
    console.log(`    https://github.com/nodejs/build/tree/main/ansible/www-standalone/tools/promote/expected_assets/${line}`);
    return;
  }

  console.log(`... Expecting a total of ${expectedAssets.size} assets for ${line}`);
  console.log(`... ${stagingAssets.size} assets waiting in R2 staging`);

   // what might be overwritten by promotion?
   if (stagingDistIntersection.size) {
    caution = true;
    console.log(` \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  ${stagingDistIntersection.size} assets already promoted in R2 will be overwritten, is this OK?`);
    if (stagingDistIntersection.size <= 10) {
      stagingDistIntersection.forEach((a) => console.log(`    • ${a}`));
    }
  } else {
    console.log(`... ${distAssets.size} assets already promoted in R2`);
  }

  if (!notInActual.size) { // perfect staging state, we have everything we need
    console.log(` \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for ${line}`);
  } else { // missing some assets and they're not in staging, are you impatient?
    caution = true;
    console.log(` \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  The following assets are expected for ${line} but are currently missing from R2 staging:`);
    notInActual.forEach((a) => console.log(`    • ${a}`));
  }

  // bogus unexpected files found in staging, not good
  if (stagingNotInExpected.size) {
    caution = true;
    update = true;
    console.log(` \u001b[31m\u001b[1m✖\u001b[22m\u001b[39m  The following assets were found in R2 staging but are not expected for ${line}:`);
    stagingNotInExpected.forEach((a) => console.log(`    • ${a}`));
  }

  // bogus unexpected files found in dist, not good
  if (distNotInExpected.size) {
    caution = true;
    update = true;
    console.log(` \u001b[31m\u001b[1m✖\u001b[22m\u001b[39m  The following assets were already promoted in R2 but are not expected for ${line}:`);
    distNotInExpected.forEach((a) => console.log(`    • ${a}`));
  }

  // do we need to provide final notices?
  if (update) {
    console.log(`    Does the expected assets list for ${line} need to be updated?`);
    console.log(`    https://github.com/nodejs/build/tree/main/ansible/www-standalone/tools/promote/expected_assets/${line}`);
  }
  if (caution) {
    console.log('    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m');
  }
}

function versionToLine (version) {
  return version.replace(/^(v\d+)\.[\d.]+.*/g, '$1.x');
}

export { checkArgs, run };
