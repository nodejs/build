// https://wiki.jenkins.io/display/JENKINS/matrix+groovy+execution+strategy+plugin
// https://docs.oracle.com/javase/7/docs/api/java/util/regex/Pattern.html

// Helper closures to make our buildExclusions DSL terse and readable
def lt = { v -> { nodeVersion -> nodeVersion < v } }
def gte = { v -> { nodeVersion -> nodeVersion >= v } }
def ltGte = { vLt, vGte -> { nodeVersion -> lt(vLt)(nodeVersion) || gte(vGte)(nodeVersion) } }
def allVer = { nodeVersion -> true }
def noVer = { nodeVersion -> false }
def releaseType = { buildType -> buildType == 'release' }
def testType = { buildType -> buildType == 'test' }
def anyType = { buildType -> true }

def buildExclusions = [
  // Given a machine label, build type (release or !release) and a Node.js
  // major version number, determine which ones to _exclude_ from a build

  // -------------------------------------------------------
  // Machine Label,                   Build Type,  Node Version

  // Linux -------------------------------------------------
  [ /^centos6/,                       releaseType, lt(8)   ],
  [ /^centos6/,                       anyType,     gte(12) ],
  [ /^centos[67]-(arm)?(64|32)-gcc48/,anyType,     gte(10) ],
  [ /^centos[67]-(arm)?(64|32)-gcc6/, anyType,     lt(10)  ],
  [ /^centos[67]-(arm)?(64|32)-gcc6/, anyType,     gte(14) ], // 14.x: gcc6 builds stop
  [ /^centos7-(arm)?(64)-gcc8/,       anyType,     lt(14)  ], // 14.x: gcc8 builds start
  [ /^centos6-32-gcc6/,               releaseType, gte(10) ], // 32-bit linux for <10 only
  [ /^centos7-64/,                    releaseType, lt(12)  ],
  [ /debian8-x86/,                    anyType,     gte(10) ], // 32-bit linux for <10 only
  [ /debian8/,                        anyType,     gte(13) ],
  [ /debian9/,                        anyType,     gte(16) ],
  [ /^ubuntu1804/,                    anyType,     lt(10)  ], // probably temporary
  [ /^ubuntu1404-32/,                 anyType,     gte(10) ], // 32-bit linux for <10 only
  [ /^ubuntu1404-64/,                 anyType,     gte(12) ],
  [ /^ubuntu1604-32/,                 anyType,     gte(10) ], // 32-bit linux for <10 only
  [ /^ubuntu1604-64/,                 anyType,     gte(16) ],
  [ /^ubuntu2004/,                    anyType,     lt(13)  ], // Ubuntu 20 doesn't have Python 2
  [ /^alpine-latest-x64$/,            anyType,     lt(13)  ], // Alpine 3.12 doesn't have Python 2

  // Linux PPC LE ------------------------------------------
  [ /^centos7-ppcle/,                 anyType,     lt(10)  ],

  // Linux S390X --------------------------------------------
  [ /s390x/,                          anyType,     lt(6)   ],
  [ /lto-s390x/,                      anyType,     lt(16)  ],

  // ARM  --------------------------------------------------
  [ /^debian8-docker-armv7$/,         releaseType, lt(10)  ],
  [ /^debian8-docker-armv7$/,         anyType,     gte(12) ],
  [ /^debian9-docker-armv7$/,         anyType,     lt(10)  ],
  [ /^pi1-docker$/,                   releaseType, gte(10) ],
  [ /^cross-compiler-ubuntu1604-armv[67]-gcc-4.9/, anyType, gte(12) ],
  [ /^cross-compiler-ubuntu1604-armv[67]-gcc-6/,   anyType, lt(12)  ],
  [ /^cross-compiler-ubuntu1604-armv[67]-gcc-6/,   anyType, gte(14) ],
  [ /^cross-compiler-ubuntu1804-armv7-gcc-6/,      anyType, lt(14)  ],
  [ /^cross-compiler-ubuntu1804-armv7-gcc-6/,      anyType, gte(16) ],
  [ /^cross-compiler-ubuntu1804-armv7-gcc-8/,      anyType, lt(16)  ],
  [ /^ubuntu1604-arm64/,              anyType,     gte(14) ],

  // Windows -----------------------------------------------
  // https://github.com/nodejs/build/blob/master/doc/windows-visualstudio-supported-versions.md
  // Release Builders - should only match one VS version per Node.js version
  [ /vs2013/,                         releaseType, gte(6)        ],
  [ /vs2015/,                         releaseType, ltGte(6, 10)  ],
  [ /vs2017/,                         releaseType, ltGte(10, 14) ],
  [ /vs2019/,                         releaseType, lt(14)        ],
  // VS versions supported to compile Node.js - also matches labels used by test runners
  [ /vs2013(-\w+)?$/,                 testType,    gte(6)        ],
  [ /vs2015(-\w+)?$/,                 testType,    gte(10)       ],
  [ /vcbt2015(-\w+)?$/,               testType,    gte(10)       ],
  [ /vs2017(-\w+)?$/,                 testType,    ltGte(8, 15)  ],
  [ /vs2019(-\w+)?$/,                 testType,    lt(13)        ],
  [ /vs2015-x86$/,                    testType,    gte(10)       ], // compile arm64/x86 only once
  [ /vs2017-x86$/,                    testType,    ltGte(10, 14) ],
  [ /vs2019-x86$/,                    testType,    lt(14)        ],
  [ /vs2019-arm64$/,                  testType,    lt(14)        ],
  // VS versions supported to build add-ons
  [ /vs2013-COMPILED_BY/,             testType,    gte(9)        ],
  [ /vs2015-COMPILED_BY/,             testType,    noVer         ],
  [ /vcbt2015-COMPILED_BY/,           testType,    noVer         ],
  [ /vs2017-COMPILED_BY/,             testType,    lt(8)         ],
  [ /vs2019-COMPILED_BY/,             testType,    lt(12)        ],
  // Exclude some redundant configurations
  // https://github.com/nodejs/build/blob/master/doc/node-test-commit-matrix.md
  [ /win10.*COMPILED_BY-vs2017/,      testType,    lt(10)        ], // vcbt2015 runs on win10 for <10
  [ /win10.*COMPILED_BY-vs2017/,      testType,    gte(13)       ], // vs2019 runs on win10 for >=13

  // SmartOS -----------------------------------------------
  [ /^smartos17/,                     anyType,     lt(10)  ],
  [ /^smartos17/,                     anyType,     gte(12) ],
  [ /^smartos18/,                     anyType,     lt(12)  ],
  [ /^smartos18/,                     releaseType, gte(14) ],
  [ /^smartos18/,                     anyType,     gte(16)  ],

  // AIX PPC64 ---------------------------------------------
  [ /aix71/,                          anyType,     lt(10)  ],
  [ /aix71/,                          anyType,     gte(15) ],
  [ /aix72/,                          anyType,     lt(15)  ],

  // Shared libs docker containers -------------------------
  [ /ubi81_sharedlibs/,               anyType,     lt(13)  ],
  [ /sharedlibs_openssl300/,          anyType,     lt(15)  ],
  [ /sharedlibs_openssl111/,          anyType,     lt(11)  ],
  [ /sharedlibs_openssl110/,          anyType,     lt(9)   ],
  [ /sharedlibs_openssl110/,          anyType,     gte(12) ],
  [ /sharedlibs_openssl102/,          anyType,     gte(10) ],
  [ /sharedlibs_fips20/,              anyType,     gte(10) ],
  [ /sharedlibs_withoutintl/,         anyType,     lt(9)   ],
  [ /sharedlibs_withoutssl/,          anyType,     lt(10)  ],
  [ /sharedlibs_shared/,              anyType,     lt(9)   ],

  // OSX ---------------------------------------------------
  [ /osx11-release-pkg/,              releaseType, lt(16)  ],
  [ /osx11-release-tar/,              releaseType, lt(16)  ],
  [ /osx1015-release-pkg/,            releaseType, gte(16) ],
  [ /^osx11/,                         testType,    lt(15)  ],
  [ /osx1014/,                        anyType,     gt(16)  ],

  // osx1015 enabled for all up, and builds all releases to support notarization
  // osx11 only for 15+ and builds the fat binary
  // This will need splitting into arm + x64 when the release machines move up from 10.15

  // FreeBSD -----------------------------------------------
  [ /^freebsd10/,                     anyType,     gte(11) ],

  // Source / headers / docs -------------------------------
  [ /^centos7-release-sources$/,      releaseType, lt(10)  ],

  // -------------------------------------------------------
]

def canBuild = { nodeVersion, builderLabel, buildType ->
  buildExclusions.findResult(true) { // this works like an array.contains(), returns true (default) or false
    def match = it[0]
    def type = it[1]
    def version = it[2]

    if (version(nodeVersion) && type(buildType) && builderLabel =~ match)
      return false
    return null
  }
}

// setup for execution of the above rules

int nodeMajorVersion = -1
if (parameters['NODEJS_MAJOR_VERSION'])
  nodeMajorVersion = parameters['NODEJS_MAJOR_VERSION'].toString().toInteger()
println "Node.js major version: $nodeMajorVersion"
println "Node.js version: ${parameters['NODEJS_VERSION']}"

// NOTE: this assumes that the default "Slaves"->"Name" in the Configuration
// Matrix is left as "nodes", if it's changed then `it.nodes` below won't work
// and returning a result with a "nodes" property won't work.
result['nodes'] = []

// Before running this script, `def buildType = 'release'` or some other value
// to be able to use the appropriate `buildType` in the exclusions
def _buildType
try {
  _buildType = buildType
} catch (groovy.lang.MissingPropertyException e) {
  _buildType = 'test'
}

combinations.each{
  def builderLabel = it.nodes
  // Default to running all builders if nodeMajorVersion is still -1
  // (i.e. the version check failed)
  if (nodeMajorVersion >= 4) {
    if (!canBuild(nodeMajorVersion, builderLabel, _buildType)) {
      println "Skipping $builderLabel for Node.js $nodeMajorVersion"
      return
    }
  }
  // Run tests on Windows ARM64 only if explicitly requested
  if (builderLabel =~ /^win.*COMPILED_BY.*-arm64$/) {
    if (!parameters['RUN_ARM64_TESTS'].toString().equalsIgnoreCase("true")){
      println "Skipping $builderLabel because RUN_ARM64_TESTS is not selected"
      return
    }
  }
  result['nodes'].add(it)
}
