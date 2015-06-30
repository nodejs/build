const assert = require('assert')
    , dirre  = /^(v\d+\.\d+\.\d+(?:-rc\.\d+)?)(?:-(?:next-)?nightly\d{8}(\w+))?$/ // get version or commit from dir name


function decodeRef (dir) {
  var m = dir.match(dirre)
  return m && (m[2] || m[1])
}


module.exports = decodeRef


if (module === require.main) {
  var tests = [
      { dir: 'v1.0.0'                                , ref: 'v1.0.0'          }
    , { dir: 'v10.11.12'                             , ref: 'v10.11.12'       }
    , { dir: 'v2.3.2-nightly20150625dcbb9e1da6'      , ref: 'dcbb9e1da6'      }
    , { dir: 'v2.3.1-next-nightly201506308f6f4280c6' , ref: '8f6f4280c6'      }
    , { dir: 'v3.0.0-rc.1'                           , ref: 'v3.0.0-rc.1'     }
    , { dir: 'v33.22.1-rc.111'                       , ref: 'v33.22.1-rc.111' }
  ]

  tests.forEach(function (test) {
    console.log(`testing ${test.dir} -> ${test.ref}`)
    assert.equal(decodeRef(test.dir), test.ref)
  })
}
