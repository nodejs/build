"use strict"

const test         = require('tape')
    , latestCommit = require('./latest-commit')
    , latestBuild  = require('./latest-build')


test('latest-build', function (t) {
  t.plan(14)
  var other = null

  function verify (type) {
    return function (err, data) {
      t.error(err, 'no error')
      t.ok(data, 'got data')
      let m = data.version && data.version.match(/v\d+\.\d+\.\d+-((?:next-)?nightly)20\d{6}\w{10,}/)
      t.ok(m, `version (${data.version}) looks correct`)
      t.equal(m && m[1], type, 'correct type')
      t.ok(data.date < new Date(), `date (${data.date.toISOString()}) looks correct`)
      t.ok(data.commit && data.commit.length >= 10, `commit (${data.commit}) looks right`)
      t.notEqual(data.commit, other, 'commit not the same as other type of commit')
      other = data.commit // who's gonna be first??      
    }
  }

  latestBuild('nightly', verify('nightly'))
  latestBuild('next-nightly', verify('next-nightly'))
})


test('latest-commit', function (t) {
  t.plan(8)
  var other = null

  function verify (type) {
    return function (err, sha) {
      t.error(err, 'no error')
      t.equal(typeof sha, 'string', 'got sha')
      t.equal(sha.length, 40, `sha looks good (${sha})`)
      t.notEqual(sha, other, 'sha not the same as other type of sha')
      other = sha // who's gonna be first??
    }
  }

  latestCommit('nightly', 'heads/v5.x', verify('nightly'))
  latestCommit('next-nightly', 'heads/master', verify('next-nightly'))
})
