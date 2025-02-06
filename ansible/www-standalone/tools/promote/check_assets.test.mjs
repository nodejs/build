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
  await mkdir(dir, { recursive: true });
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

function versionToLine (version) {
    return version.replace(/^(v\d+)\.[\d.]+.*/g, '$1.x')
}

const testcases = [
  {
    name: 'Everything is in staging, nothing in dist, good to go',
    version: 'v8.13.0',
    expectedStdout:
      '... Checking assets\n' +
      '... Expecting a total of 44 assets for v8.x\n' +
      '... 44 assets waiting in staging\n' +
      '... 0 assets already promoted\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v8.x\n',
    setup: async function setup (version, fixtureStagingDir, fixtureDistDir) {
      await makeFixture(version, true, fixtureStagingDir);
    }
  },
  {
    name: 'Not quite everything is in staging, missing two assets, nothing in dist',
    version: 'v10.1.0',
    expectedStdout:
      '... Checking assets\n' +
      '... Expecting a total of 41 assets for v10.x\n' +
      '... 38 assets waiting in staging\n' +
      '... 0 assets already promoted\n' +
      ' \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  The following assets are expected for v10.x but are currently missing from staging:\n' +
      '    • node-v10.1.0-linux-armv6l.tar.gz\n' +
      '    • node-v10.1.0-linux-armv6l.tar.xz\n' +
      '    • node-v10.1.0.pkg\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n',
    setup: async function setup (version, fixtureStagingDir, fixtureDistDir) {
      await makeFixture(version, true, fixtureStagingDir);
      await Promise.all([
        rm(join(fixtureStagingDir, 'node-v10.1.0-linux-armv6l.tar.gz')),
        rm(join(fixtureStagingDir, 'node-v10.1.0-linux-armv6l.tar.gz.done')),
        rm(join(fixtureStagingDir, 'node-v10.1.0-linux-armv6l.tar.xz')),
        rm(join(fixtureStagingDir, 'node-v10.1.0-linux-armv6l.tar.xz.done')),
        rm(join(fixtureStagingDir, 'node-v10.1.0.pkg')),
        rm(join(fixtureStagingDir, 'node-v10.1.0.pkg.done'))
      ]);
    }
  },
  {
    name: 'Everything in staging, 3 files in dist',
    version: 'v6.0.1',
    expectedStdout:
      '... Checking assets\n' +
      '... Expecting a total of 46 assets for v6.x\n' +
      '... 46 assets waiting in staging\n' +
      ' \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  3 assets already promoted will be overwritten, is this OK?\n' +
      '    • node-v6.0.1-headers.tar.gz\n' +
      '    • node-v6.0.1-x86.msi\n' +
      '    • node-v6.0.1.tar.gz\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v6.x\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n',
    setup: async function setup (version, fixtureStagingDir, fixtureDistDir) {
      await makeFixture(version, true, fixtureStagingDir);
      const distAssets = await makeFixture(version, false, fixtureDistDir);
      await Promise.all(
        distAssets.filter((a) => {
          return a !== 'node-v6.0.1-headers.tar.gz' &&
            a !== 'node-v6.0.1.tar.gz' &&
            a !== 'node-v6.0.1-x86.msi' &&
            // deleting all directories, so we don't need to delete the children
            !/^win-x64\/.+/.test(a) &&
            !/^win-x86\/.+/.test(a) &&
            !/^docs\/.+/.test(a)
        }).map((e) => rm(join(fixtureDistDir, e), { force: true, recursive: true }))
      );
    }
  },
  {
    name: 'Everything in staging and everything in dist',
    version: 'v11.11.11',
    expectedStdout:
      '... Checking assets\n' +
      '... Expecting a total of 41 assets for v11.x\n' +
      '... 41 assets waiting in staging\n' +
      ' \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  41 assets already promoted will be overwritten, is this OK?\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v11.x\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n',
    setup: async function setup (version, fixtureStagingDir, fixtureDistDir) {
      await makeFixture(version, true, fixtureStagingDir);
      await makeFixture(version, false, fixtureDistDir);
    }
  },
  {
    name: 'No expected files list is available for this version, it has to guess',
    version: 'v9.9.9',
    expectedStdout:
      '... Checking assets\n' +
      ' \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  No expected asset list is available for v9.x, using the list for v8.x instead\n' +
      '    Should a new list be created for v9.x?\n' +
      '    https://github.com/nodejs/build/tree/main/ansible/www-standalone/tools/promote/expected_assets/v9.x\n' +
      '... Expecting a total of 44 assets for v9.x\n' +
      '... 41 assets waiting in staging\n' +
      '... 0 assets already promoted\n' +
      ' \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  The following assets are expected for v9.x but are currently missing from staging:\n' +
      '    • node-v9.9.9-linux-x86.tar.gz\n' +
      '    • node-v9.9.9-linux-x86.tar.xz\n' +
      '    • node-v9.9.9-sunos-x86.tar.gz\n' +
      '    • node-v9.9.9-sunos-x86.tar.xz\n' +
      ' \u001b[31m\u001b[1m✖\u001b[22m\u001b[39m  The following assets were found in staging but are not expected for v9.x:\n' +
      '    • docs/apilinks.json\n' +
      '    Does the expected assets list for v9.x need to be updated?\n' +
      '    https://github.com/nodejs/build/tree/main/ansible/www-standalone/tools/promote/expected_assets/v9.x\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n',
    setup: async function setup (version, fixtureStagingDir, fixtureDistDir) {
      // use the 10.x list, which is missing the x86 files, it'll check the 9.x
      const expectedAssets = await loadExpectedAssets(version, 'v10.x');
      await makeFixture(version, true, fixtureStagingDir, expectedAssets);
    }
  },
  {
    name: 'Everything is in dist except for the armv6l files, but they are in staging',
    version: 'v10.0.0',
    expectedStdout:
      '... Checking assets\n' +
      '... Expecting a total of 41 assets for v10.x\n' +
      '... 2 assets waiting in staging\n' +
      '... 39 assets already promoted\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v10.x\n',
    setup: async function setup (version, fixtureStagingDir, fixtureDistDir) {
      await makeFixture(version, true, fixtureStagingDir, [
        'node-v10.0.0-linux-armv6l.tar.gz',
        'node-v10.0.0-linux-armv6l.tar.xz'
      ]);
      await makeFixture(version, false, fixtureDistDir);
      await Promise.all([
        rm(join(fixtureDistDir, 'node-v10.0.0-linux-armv6l.tar.gz')),
        rm(join(fixtureDistDir, 'node-v10.0.0-linux-armv6l.tar.xz'))
      ]);
    }
  },
  {
    name: 'Some unexpected files in staging',
    version: 'v10.0.0',
    expectedStdout:
      '... Checking assets\n' +
      '... Expecting a total of 41 assets for v10.x\n' +
      '... 2 assets waiting in staging\n' +
      '... 41 assets already promoted\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v10.x\n' +
      ' \u001b[31m\u001b[1m✖\u001b[22m\u001b[39m  The following assets were found in staging but are not expected for v10.x:\n' +
      '    • ooolaalaa.tar.gz\n' +
      '    • whatdis.tar.xz\n' +
      '    Does the expected assets list for v10.x need to be updated?\n' +
      '    https://github.com/nodejs/build/tree/main/ansible/www-standalone/tools/promote/expected_assets/v10.x\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n',
    setup: async function setup (version, fixtureStagingDir, fixtureDistDir) {
      await makeFixture(version, true, fixtureStagingDir, [
        'ooolaalaa.tar.gz',
        'whatdis.tar.xz'
      ]);
      await makeFixture(version, false, fixtureDistDir);
    }
  },
  {
    name: 'Unexpected files in subdirectories, only check 2 levels deep',
    version: 'v11.11.1',
    expectedStdout:
      '... Checking assets\n' +
      '... Expecting a total of 41 assets for v11.x\n' +
      '... 43 assets waiting in staging\n' +
      '... 0 assets already promoted\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v11.x\n' +
      ' \u001b[31m\u001b[1m✖\u001b[22m\u001b[39m  The following assets were found in staging but are not expected for v11.x:\n' +
      '    • docs/bar\n' +
      '    • docs/foo\n' +
      '    Does the expected assets list for v11.x need to be updated?\n' +
      '    https://github.com/nodejs/build/tree/main/ansible/www-standalone/tools/promote/expected_assets/v11.x\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n',
    setup: async function setup (version, fixtureStagingDir, fixtureDistDir) {
      await makeFixture(version, true, fixtureStagingDir);
      await Promise.all([
        writeFile(join(fixtureStagingDir, 'docs/foo'), 'foo'),
        writeFile(join(fixtureStagingDir, 'docs/bar'), 'foo'),
        writeFile(join(fixtureStagingDir, 'docs/api/baz'), 'bar')
      ]);
    }
  },
  {
    name: 'Some unexpected files in dist',
    version: 'v6.7.8',
    expectedStdout: '... Checking assets\n' +
      '... Expecting a total of 46 assets for v6.x\n' +
      '... 46 assets waiting in staging\n' +
      '... 2 assets already promoted\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v6.x\n' +
      ' \u001b[31m\u001b[1m✖\u001b[22m\u001b[39m  The following assets were already promoted but are not expected for v6.x:\n' +
      '    • ooolaalaa.tar.gz\n' +
      '    • whatdis.tar.xz\n' +
      '    Does the expected assets list for v6.x need to be updated?\n' +
      '    https://github.com/nodejs/build/tree/main/ansible/www-standalone/tools/promote/expected_assets/v6.x\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n',
    setup: async function setup (version, fixtureStagingDir, fixtureDistDir) {
      await makeFixture(version, false, fixtureDistDir, [
        'ooolaalaa.tar.gz',
        'whatdis.tar.xz'
      ]);
      await makeFixture(version, true, fixtureStagingDir);
    }
  },
  {
    name: 'SHASUMS in dist already, shouldn\'t bother us',
    version: 'v8.0.0',
    expectedStdout:
      '... Checking assets\n' +
      '... Expecting a total of 44 assets for v8.x\n' +
      '... 44 assets waiting in staging\n' +
      ' \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  4 assets already promoted will be overwritten, is this OK?\n' +
      '    • docs/\n' +
      '    • docs/api/\n' +
      '    • node-v8.0.0-linux-armv6l.tar.gz\n' +
      '    • node-v8.0.0-linux-armv6l.tar.xz\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v8.x\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n',
    setup: async function setup (version, fixtureStagingDir, fixtureDistDir) {
      await Promise.all([
        makeFixture(version, true, fixtureStagingDir),
        makeFixture(version, false, fixtureDistDir, [
          'SHASUMS256.txt',
          'SHASUMS256.txt.asc',
          'SHASUMS256.txt.sig',
          'docs/',
          'docs/api/',
          'docs/api/bar',
          'node-v8.0.0-linux-armv6l.tar.gz',
          'node-v8.0.0-linux-armv6l.tar.xz'
        ])
      ]);
    }
  },
];

describe(`${basename(import.meta.filename, '.test.mjs')} tests`, async () => {
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
  for (const { name, version, expectedStdout, setup } of testcases) {
    it(name, async (context) => {
      const fixtureStagingDir = join(context.fixtureStagingDir, version);
      const fixtureDistDir = join(context.fixtureDistDir, version);
      await setup(version, fixtureStagingDir, fixtureDistDir);
    
      const stdout = await executeMe(fixtureStagingDir, fixtureDistDir);
      assert.strictEqual(stdout, expectedStdout);
    });
  }
});
