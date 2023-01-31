import tls from 'node:tls';
import { randomUUID } from 'node:crypto';

const daysThreshold = 30;
const now = Date.now();
const secondsPerDay = 86_400_000;
const servers = [
  'ci.nodejs.org',
  'ci-release.nodejs.org',
  'nodejs.org',
  'direct.nodejs.org',
  'unencrypted.nodejs.org',
];
function expiringSoon(dateString) {
  return (Date.parse(dateString) - now) / secondsPerDay < daysThreshold;
};
function formatDate(date) {
  // Return date in ISO format but without the time component.
  const isoString = new Date(date).toISOString();
  return isoString.substring(0, isoString.indexOf('T'));
};
function getCertificate(port, host) {
  return new Promise((resolve, reject) => {
    const socket = tls.connect(port, host, () => {
      const certificate = socket.getPeerX509Certificate();
      socket.destroy();
      resolve({ host, certificate });
    });
  });
};

const certificates = await Promise.all(servers.map((host) => getCertificate(443, host)));
const sortedCertificates = certificates.sort((a, b) => {
  return Date.parse(a.certificate.validTo) > Date.parse(b.certificate.validTo);
});
const earliestExpiry = sortedCertificates[0].certificate.validTo;

const output = certificates.sort((a, b) => {
  return a.host.localeCompare(b.host);
}).map(({ host, certificate: { validTo } }) => {
  const prefix = expiringSoon(validTo) ? '- [ ]' : '- [x]';
  const linkedHost = `[${host}](https://${host})`;
  return `${prefix} ${linkedHost}, certificate valid until ${formatDate(validTo)}`;
}).join('\n');

if (expiringSoon(earliestExpiry)) {
  process.exitCode = 1;
};
const delimiter = randomUUID();
console.log(`earliestExpiry=${formatDate(earliestExpiry)}`);
console.log(`certificates<<${delimiter}`);
console.log(output);
console.log(delimiter);
