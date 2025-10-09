import assert from 'node:assert';
import { randomUUID } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import { basename, join } from 'node:path';
import { before, beforeEach, describe, it, mock } from 'node:test';
import { exit } from 'node:process';

const testcases = [
  {
    name: 'No rclone',
    version: 'v22.12.0',
    expectedStdout: '',
    setup: async function setup (context) {
      const command = `rclone lsjson ${context.r2StagingDir} --no-modtime --no-mimetype -R --max-depth 2`;
      context.rcloneErr = new Error(`Command failed: ${command}\n/bin/sh: line 1: rclone: command not found`);
      context.rcloneErr.code = 127;
      context.rcloneErr.killed = false;
      context.rcloneErr.signal = null;
      context.rcloneErr.cmd = command;
    }
  },
  {
    name: 'Missing asset file',
    version: 'v9.0.0', // No asset file for v9.x.
    expectedStdout:
      '... Checking R2 assets\n' +
      ' \x1B[31m\x1B[1m✖\x1B[22m\x1B[39m  No expected asset list is available for v9.x, does one need to be created?\n' +
      '    https://github.com/nodejs/build/tree/main/ansible/www-standalone/tools/promote/expected_assets/v9.x\n',
  },
  {
    name: 'Everything is in staging, nothing in dist, good to go',
    version: 'v22.12.0',
    expectedStdout:
      '... Checking R2 assets\n' +
      '... Expecting a total of 47 assets for v22.x\n' +
      '... 47 assets waiting in R2 staging\n' +
      '... 0 assets already promoted in R2\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v22.x\n',
    setup: async function setup (context) {
      context.rcloneLs[context.r2StagingDir] = await fixture('all-present-v22.12.0.json');
    }
  },
  {
    name: 'Not quite everything is in staging, missing two assets, nothing in dist',
    version: 'v22.12.0',
    expectedStdout:
      '... Checking R2 assets\n' +
      '... Expecting a total of 47 assets for v22.x\n' +
      '... 45 assets waiting in R2 staging\n' +
      '... 0 assets already promoted in R2\n' +
      ' \x1B[33m\x1B[1m⚠\x1B[22m\x1B[39m  The following assets are expected for v22.x but are currently missing from R2 staging:\n' +
      '    • node-v22.12.0-linux-armv7l.tar.gz\n' +
      '    • node-v22.12.0-linux-armv7l.tar.xz\n' +
      '... Canceling the promotion',
    setup: async function setup (context) {
      context.rcloneLs[context.r2StagingDir] = await fixture('partial-v22.12.0.json');
    }
  },
  {
    name: 'Everything is in staging and everything in dist',
    version: 'v22.12.0',
    expectedStdout:
      '... Checking R2 assets\n' +
      '... Expecting a total of 47 assets for v22.x\n' +
      '... 47 assets waiting in R2 staging\n' +
      ' \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  47 assets already promoted in R2 will be overwritten, is this OK?\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v22.x\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n',
    setup: async function setup (context) {
      context.rcloneLs[context.r2StagingDir] = await fixture('all-present-v22.12.0.json');
      context.rcloneLs[context.r2DistDir] = await fixture('all-present-v22.12.0.json');
    }
  },
  {
    name: 'Everything is in dist except for the armv7l files, but they are in staging',
    version: 'v22.12.0',
    expectedStdout:
      '... Checking R2 assets\n' +
      '... Expecting a total of 47 assets for v22.x\n' +
      '... 47 assets waiting in R2 staging\n' +
      ' \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  45 assets already promoted in R2 will be overwritten, is this OK?\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v22.x\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n',
    setup: async function setup (context) {
      context.rcloneLs[context.r2StagingDir] = await fixture('all-present-v22.12.0.json');
      context.rcloneLs[context.r2DistDir] = await fixture('partial-v22.12.0.json');
    }
  },
  {
    name: 'Everything is in dist except for the armv7l files, but they are in staging. Ignores SHASUMS in staging.',
    version: 'v22.12.0',
    expectedStdout:
      '... Checking R2 assets\n' +
      '... Expecting a total of 47 assets for v22.x\n' +
      '... 47 assets waiting in R2 staging\n' +
      ' \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  45 assets already promoted in R2 will be overwritten, is this OK?\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v22.x\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n',
    setup: async function setup (context) {
      context.rcloneLs[context.r2StagingDir] = await fixture('with-shasums-v22.12.0.json');
      context.rcloneLs[context.r2DistDir] = await fixture('partial-v22.12.0.json');
    }
  },
  {
    name: 'Everything is in dist except for the armv7l files, but they are in staging. Ignores SHASUMS in dist.',
    version: 'v22.12.0',
    expectedStdout:
      '... Checking R2 assets\n' +
      '... Expecting a total of 47 assets for v22.x\n' +
      '... 47 assets waiting in R2 staging\n' +
      ' \u001b[33m\u001b[1m⚠\u001b[22m\u001b[39m  45 assets already promoted in R2 will be overwritten, is this OK?\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v22.x\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n',
    setup: async function setup (context) {
      context.rcloneLs[context.r2StagingDir] = await fixture('with-shasums-v22.12.0.json');
      context.rcloneLs[context.r2DistDir] = await fixture('partial-with-shasums-v22.12.0.json');
    }
  },
  {
    name: 'Unexpected files in dist',
    version: 'v22.12.0',
    expectedStdout:
      '... Checking R2 assets\n' +
      '... Expecting a total of 47 assets for v22.x\n' +
      '... 47 assets waiting in R2 staging\n' +
      '... 2 assets already promoted in R2\n' +
      ' \u001b[32m\u001b[1m✓\u001b[22m\u001b[39m  Complete set of expected assets in place for v22.x\n' +
      ' \x1B[31m\x1B[1m✖\x1B[22m\x1B[39m  The following assets were already promoted in R2 but are not expected for v22.x:\n' +
      '    • foo.tar.gz\n' +
      '    • bar.tar.xz\n' +
      '    Does the expected assets list for v22.x need to be updated?\n' +
      '    https://github.com/nodejs/build/tree/main/ansible/www-standalone/tools/promote/expected_assets/v22.x\n' +
      '    \u001b[33mPromote if you are certain this is the the correct course of action\u001b[39m\n',
      setup: async function setup (context) {
      context.rcloneLs[context.r2StagingDir] = await fixture('all-present-v22.12.0.json');
      context.rcloneLs[context.r2DistDir] = await fixture('unexpected-files.json');
    }
  },
];

async function fixture (name) {
  return readFile(join(import.meta.dirname, 'fixtures', name));
};

describe(`${basename(import.meta.filename, '.mjs')} tests`, async () => {
  let execMockFn = mock.fn();
  let check_r2_assets;
  let consoleLogFn;
  let consoleErrorFn;
  const captureConsole = (context) => {
    context.stderr = '';
    context.stdout = '';
    consoleErrorFn = mock.method(console, 'error', (text) => { context.stderr += `${text}\n` });
    consoleLogFn = mock.method(console, 'log', (text) => { context.stdout += `${text}\n` });
  };
  const restoreConsole = () => {
    consoleErrorFn?.mock.restore();
    consoleLogFn?.mock.restore();
  };
  before(async () => {
    mock.module('node:child_process', {
      namedExports: { exec: execMockFn }
    });
    // Dynamic import so that mocks are set up before the import starts.
    check_r2_assets = await import('../check_r2_assets.mjs');
  });
  beforeEach(async (context) => {
    context.r2StagingBucket = `r2:${randomUUID()}`;
    context.r2ProdBucket = `r2:${randomUUID()}`;
    context.rcloneLs = {};
    context.rcloneErr = undefined;
  });
  it('No arguments', async (context) => {
    const expectedStderr =
      'Usage: check_r2_assets.mjs <path to staging directory> <path to dist directory>\n';
    captureConsole(context);
    const exitFunc = context.mock.fn();
    process.exit = exitFunc;
    await check_r2_assets.checkArgs();
    process.exit = exit;
    restoreConsole();
    assert.strictEqual(exitFunc.mock.callCount(), 1);
    assert.strictEqual(context.stderr, expectedStderr);
  });
  it('Insufficient number of arguments', async (context) => {
    const expectedStderr =
      'Usage: check_r2_assets.mjs <path to staging directory> <path to dist directory>\n';
    captureConsole(context);
    const exitFunc = context.mock.fn();
    process.exit = exitFunc;
    await check_r2_assets.checkArgs([ process.execPath, 'check_r2_assets.mjs' ]);
    process.exit = exit;
    restoreConsole();
    assert.strictEqual(exitFunc.mock.callCount(), 1);
    assert.strictEqual(context.stderr, expectedStderr);
  });
  it('Bad staging directory', async (context) => {
    const expectedStderr =
      'Bad staging directory name: foo\n' +
      'Usage: check_r2_assets.mjs <path to staging directory> <path to dist directory>\n';
    captureConsole(context);
    const exitFunc = context.mock.fn();
    process.exit = exitFunc;
    await check_r2_assets.checkArgs([ process.execPath, 'check_r2_assets.mjs', 'foo', 'v22.12.0' ]);
    process.exit = exit;
    restoreConsole();
    assert.strictEqual(exitFunc.mock.callCount(), 1);
    assert.strictEqual(context.stderr, expectedStderr);
  });
  it('Bad dist directory', async (context) => {
    const expectedStderr =
      'Bad dist directory name: bar\n' +
      'Usage: check_r2_assets.mjs <path to staging directory> <path to dist directory>\n';
    captureConsole(context);
    const exitFunc = context.mock.fn();
    process.exit = exitFunc;
    await check_r2_assets.checkArgs([ process.execPath, 'check_r2_assets.mjs', 'v22.12.0', 'bar' ]);
    process.exit = exit;
    restoreConsole();
    assert.strictEqual(exitFunc.mock.callCount(), 1);
    assert.strictEqual(context.stderr, expectedStderr);
  });
  it('Bad staging and dist directories', async (context) => {
    const expectedStderr =
      'Bad staging directory name: foo\n' +
      'Bad dist directory name: bar\n' +
      'Usage: check_r2_assets.mjs <path to staging directory> <path to dist directory>\n';
    captureConsole(context);
    const exitFunc = context.mock.fn();
    process.exit = exitFunc;
    await check_r2_assets.checkArgs([ process.execPath, 'check_r2_assets.mjs', 'foo', 'bar' ]);
    process.exit = exit;
    restoreConsole();
    assert.strictEqual(exitFunc.mock.callCount(), 1);
    assert.strictEqual(context.stderr, expectedStderr);
  });
  for (const { name, version, expectedStdout, setup } of testcases) {
    it(name, async (context) => {
      context.version = version;
      context.r2DistDir = join(context.r2ProdBucket, 'nodejs', 'release', version);
      context.r2StagingDir = join(context.r2StagingBucket, 'nodejs', 'release', version);
      await setup?.(context);
      execMockFn.mock.mockImplementation(async (command, opts, cb) => {
        if (context.rcloneErr) {
          return cb(context.rcloneErr);
        }
        const [ _, stdout ] = Object.entries(context.rcloneLs)?.find(([ key, _ ]) => command.includes(key)) || [ , '[\n]\n' ];
        return cb(undefined, stdout);
      });
      captureConsole(context);
      try {
        await check_r2_assets.run(context.r2StagingDir, context.r2DistDir);
      } catch (err) {
        assert.strictEqual(err, context.rcloneErr);
      } finally {
        restoreConsole();
      }
      assert.strictEqual(context.stdout, expectedStdout);
    });
  }
});
