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
// describe('dist.nodejs.org');
