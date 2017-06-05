'use strict';

const assert = require('assert');
const test = require('./lib/test.js');
const redirects = require('./redirects.js');


describe('nodejs.org', function () {

    it('should have an English homepage', function (done) {

        test.url('https://nodejs.org/en/', function (status) {

            assert.equal(status, 200);
            done();
        });
    });

    redirects.main['301'].forEach(test.redirect(301));
    redirects.main['302'].forEach(test.redirect(302));
});


describe('blog.nodejs.org', function () {

    redirects.blog['301'].forEach(test.redirect(301));
    redirects.blog['302'].forEach(test.redirect(302));
});

// describe('doc(s).nodejs.org');
describe('dist.nodejs.org', function () {

    let nodeVersions;

    before(function (done) {

        test.download('https://nodejs.org/dist/index.json', function (err, versions) {
            if (err) { return done(err); }
            nodeVersions = versions;
            done();
        });
    });


    it('https://nodejs.org/dist/latest/ should contain the latest release', function (done) {

        test.url(`https://nodejs.org/dist/latest/node-${nodeVersions[0].version}.tar.gz`, function (status) {

            assert.equal(status, 200);
            done();
        });

    });


    it('https://nodejs.org/dist/latest/latest-v0.10.x/ should contain the latest v0.10 release', function (done) {

        let latestVersion = test.getLatestRelease(nodeVersions, '^0.10');

        test.url(`https://nodejs.org/dist/latest-v0.10.x/node-${latestVersion}.tar.gz`, function (status) {

            assert.equal(status, 200);
            done();
        });

    });


    it('https://nodejs.org/dist/latest/latest-v0.12.x/ should contain the latest v0.12 release', function (done) {

        let latestVersion = test.getLatestRelease(nodeVersions, '^0.12');

        test.url(`https://nodejs.org/dist/latest-v0.12.x/node-${latestVersion}.tar.gz`, function (status) {

            assert.equal(status, 200);
            done();
        });

    });
});
