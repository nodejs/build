import assert from 'node:assert';
import { execFile } from 'node:child_process';
import { mkdir, mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { basename, join } from 'node:path';
import { afterEach, beforeEach, describe, it } from 'node:test';

// execute check_assets.js with the given staging and dist dirs, collect output
async function executeMe (stagingDir, distDir) {
  return new Promise((resolve, reject) => {
    const args = [ '--no-warnings', join(import.meta.dirname, 'check_assets.js'), stagingDir, distDir ];
    execFile(process.execPath, args, (err, stdout, stderr) => {
      if (err) {
        return reject(err);
      }
      if (stderr) {
        console.log('STDERR:', stderr);
      }
      resolve(stdout);
    });
  });
}

async function loadExpectedAssets (version, line) {
  if (!line) {
    line = versionToLine(version);
  }
  try {
    const templateFile = join(import.meta.dirname, 'expected_assets', line);
    let files = await readFile(templateFile, 'utf8');
    return files.replace(/{VERSION}/g, version).split(/\n/g).filter(Boolean);
  } catch (e) { }
  return null;
}

// makes a staging or dist directory given a version string
async function makeFixture (version, isStaging, dir, assets) {
  if (!assets) {
    assets = await loadExpectedAssets(version);
  }
  for (let asset of assets) {
    let absoluteAsset = join(dir, asset);
    if (asset.endsWith('/')) {
      await mkdir(absoluteAsset, { recursive: true });
    } else {
      await writeFile(absoluteAsset, asset, 'utf8');
    }
    let dashPos = isStaging && asset.indexOf('/');
    if (isStaging && (dashPos === -1 || dashPos === asset.length - 1)) {
      // in staging, all files and directories that are ready have a
      // duplicate empty file with .done in the name
      await writeFile(absoluteAsset.replace(/\/?$/, '.done'), asset, 'utf8');
    }
  }
  return assets;
}

async function runTest (context, version, expectedStdout, setup) {
  const fixtureStagingDir = join(context.fixtureStagingDir, version);
  const fixtureDistDir = join(context.fixtureDistDir, version);
  await setup(fixtureStagingDir, fixtureDistDir);

  const stdout = await executeMe(fixtureStagingDir, fixtureDistDir);
  assert.strictEqual(stdout, expectedStdout);
}

function versionToLine (version) {
    return version.replace(/^(v\d+)\.[\d.]+.*/g, '$1.x')
}

describe('tests', async () => {
  beforeEach(async (context) => {
    context.testDir = await mkdtemp(join(tmpdir(), `${basename(import.meta.filename)}_`));
    context.fixtureDistDir = join(context.testDir, 'dist');
    context.fixtureStagingDir = join(context.testDir, 'staging');
    await mkdir(context.fixtureDistDir);
    await mkdir(context.fixtureStagingDir);
  });
  afterEach(async (context) => {
    await rm(context.testDir, { recursive: true, force: true, maxRetries: 10 });
  });
  it('Everything is in staging, nothing in dist, good to go', async (context) => {
    const version = 'v8.13.0';
    const expectedStdout =
      '... Checking assets\n' +
      '... Expecting a total of 44 assets for v8.x\n' +
      '... 44 assets waiting in staging\n' +
      '... 0 assets already promoted\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v8.x\n';
    async function setup (fixtureStagingDir, fixtureDistDir) {
      await makeFixture(version, true, fixtureStagingDir);
    }

    await runTest(context, version, expectedStdout, setup);
  });
});
