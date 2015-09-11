'use strict';

const url = require('url');
const http = require('http');
const https = require('https');
const assert = require('assert');
const merge = require('lodash.merge');
const semver = require('semver');


const testUrl = module.exports.url = function (requestUrl, callback) {
    requestUrl = url.parse(requestUrl);

    const options = merge({}, requestUrl, { method: 'HEAD' });
    const protocol = requestUrl.protocol === 'http:' ? http : https;
    const req = protocol.request(options, function (res) {

        if (typeof callback !== 'function') { return; }
        callback(res.statusCode, res.headers);
    });

    req.on('error', function (err) {

        throw err;
    });

    req.end();
};


module.exports.redirect = function (expectedStatus) {
    return function (redirect) {

        it(`should redirect ${redirect.src} to ${redirect.dest} via HTTP ${expectedStatus}`, function (done) {

            testUrl(redirect.src, function (status, headers) {

                assert.equal(status, expectedStatus);
                assert.equal(headers.location, redirect.dest);
                done();
            });

        });
    };
};


module.exports.download = function (url, cb) {

    let data = '';
    https
        .get(url, function (res) {

            res.on('data', function (chunk) { data += chunk; });
            res.on('end', function () {

                try {
                    cb(null, JSON.parse(data));
                } catch (e) {
                    return cb(e);
                }
            });
        })
        .on('error', function (e) { cb(e); });
};


module.exports.getLatestRelease = function (releases, range) {

    const versions = releases.map(function (release) {

        return release.version;
    });

    return semver.maxSatisfying(versions, range);
};
