import { spawnSync } from 'child_process';
import { basename, dirname, resolve } from 'path';
import chalk from 'chalk';
import columnify from 'columnify';
const { green } = chalk;

const __filename = new URL(import.meta.url).pathname;
const __dirname = dirname(__filename);

const dir = resolve(__dirname, '..', '..', 'ansible');
const childProc = spawnSync('python3', ['plugins/inventory/nodejs_yaml.py'],
  { cwd: dir, encoding: 'utf8' });
const hosts = JSON.parse(childProc.stdout);

const inventory = hosts._meta.hostvars;

const typeFilter = (type, hostVars) => {
  return hostVars.type === type;
};

let inventoryFilter;
if (process.argv.length > 2) {
  const type = process.argv[2];
  if (['infra', 'release', 'test'].includes(type)) {
    inventoryFilter = typeFilter.bind(this, type);
  } else {
    console.error(`Unknown inventory type '${type}'.`);
    process.exit(-2);
  }
} else {
  console.error(`Usage: node ${basename(__filename)} <infra|release|test>`);
  process.exit(-1);
}

// Shorten provider names to shorten table width.
// Also map, e.g. SoftLayer to IBM Cloud.
const providerMap = new Map([
  ['digitalocean', 'do'],
  ['iinthecloud', 'iitc'],
  ['rackspace', 'rs'],
  ['softlayer', 'ibm']
]);
const mapProvider = (provider) => {
  return providerMap.get(provider) || provider;
};

// Disambiguate containers, jenkins workspaces, etc.
const getPlatform = (host) => {
  let { arch, os } = host;
  if (host.containers) {
    os += '_docker';
  }
  if (host.alias && host.alias.startsWith('jenkins-workspace')) {
    os += '_workspace';
  }
  // TODO: work out how to disambiguate Windows hosts.
  const platform = [os, arch].join('-');
  return platform;
};

// Platforms and providers are our rows and columns.
const platforms = new Set();
const providers = new Set();
for (const vars of Object.values(inventory)) {
  if (inventoryFilter(vars)) {
    providers.add(mapProvider(vars.provider));
    platforms.add(getPlatform(vars));
  }
}

const sortedProviders = [...providers].sort();
const data = [];
for (const p of [...platforms].sort()) {
  const entry = { platform: p };
  for (const provider of sortedProviders) {
    entry[provider] = 0;
  }
  data.push(entry);
}

// Count the hosts per platform per provider.
for (const host of Object.values(inventory)) {
  if (inventoryFilter(host)) {
    const platform = getPlatform(host);
    data.find((e) => e.platform === platform)[mapProvider(host.provider)]++;
  }
}

console.log(columnify(data,
  {
    align: 'right',
    columnSplitter: '|',
    preserveNewLines: true,
    dataTransform: (data) => {
      // Hide zeroes to make the table easier to read.
      return data > 0 ? data : '';
    },
    headingTransform: (data) => {
      // Add heading separator.
      return `${data}\n${'-'.repeat(data.length)}\n`;
    },
    config: {
      platform: {
        align: 'left',
        dataTransform: (platform) => {
          // Highlight platforms spread across multiple providers.
          let providerCount = 0;
          const entry = data.find((n) => n.platform === platform);
          for (const provider of sortedProviders) {
            if (entry[provider] > 0) {
              providerCount++;
            }
          }
          return providerCount > 1 ? green(platform) : platform;
        }
      }
    }
  }));
