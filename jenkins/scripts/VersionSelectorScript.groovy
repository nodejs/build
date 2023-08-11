// https://wiki.jenkins.io/display/JENKINS/matrix+groovy+execution+strategy+plugin
// https://docs.oracle.com/javase/7/docs/api/java/util/regex/Pattern.html

// Helper closures to make our buildExclusions DSL terse and readable
def lt = { v -> { nodeVersion -> nodeVersion < v } }
def gte = { v -> { nodeVersion -> nodeVersion >= v } }
def gteLt = { vGte, vLt -> { nodeVersion -> gte(vGte)(nodeVersion) && lt(vLt)(nodeVersion) } }
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
  [ /^centos7-(arm)?(64|32)-gcc48/,   anyType,     gte(16) ],
  [ /^centos7-(arm)?(64|32)-gcc6/,    anyType,     gte(16) ],    // 14.x: gcc6 builds stop
  [ /^centos7-(arm)?(64)-gcc8/,       anyType,     gte(18) ], // 18.x: centos7 builds stop
  [ /^centos7-64/,                    anyType,     gte(18) ],
  [ /debian8-x86/,                    anyType,     gte(16) ], // 32-bit linux for <10 only
  [ /debian8/,                        anyType,     gte(16) ],
  [ /debian9/,                        anyType,     gte(16) ],
  [ /rhel7/,                          anyType,     gte(18) ],
  [ /rhel8/,                          releaseType, lt(18)  ],
  [ /^ubuntu1604-32/,                 anyType,     gte(16) ], // 32-bit linux for <10 only
  [ /^ubuntu1604-64/,                 anyType,     gte(16) ],

  // Linux PPC LE ------------------------------------------
  [ /^centos7-ppcle/,                 anyType,     gte(18) ],

  // ARM  --------------------------------------------------
  [ /^debian8-docker-armv7$/,                        anyType, gte(16) ],
  [ /^debian10-armv7l$/,                             anyType, gte(20) ], // gcc 10 requires newer libstdc++
  [ /^cross-compiler-ubuntu1604-armv[67]-gcc-4.9/,   anyType, gte(16) ],
  [ /^cross-compiler-ubuntu1604-armv[67]-gcc-6/,     anyType, gte(16) ],
  [ /^cross-compiler-ubuntu1804-armv7-gcc-6/,        anyType, gte(16) ],
  [ /^cross-compiler-ubuntu1804-armv7-gcc-8/,        anyType, gte(18) ],
  [ /^cross-compiler-rhel8-armv7-gcc-8-glibc-2.28/,  anyType, lt(18)  ],
  [ /^cross-compiler-rhel8-armv7-gcc-8-glibc-2.28/,  anyType, gte(20) ],
  [ /^cross-compiler-rhel8-armv7-gcc-10-glibc-2.28/, anyType, lt(20)  ],
  [ /^ubuntu1604-arm64/,                             anyType, gte(16) ],

  // Windows -----------------------------------------------
  // https://github.com/nodejs/build/blob/main/doc/windows-visualstudio-supported-versions.md
  // Release Builders - should only match one VS version per Node.js version
  [ /vs2013/,                         releaseType, gte(16)       ],
  [ /vs2015/,                         releaseType, gte(16)       ],
  [ /vs2017/,                         releaseType, gte(16)       ],
  [ /vs2019-arm64/,                   releaseType, lt(20)        ],
  // VS versions supported to compile Node.js - also matches labels used by test runners
  [ /vs2013(-\w+)?$/,                 testType,    gte(16)       ],
  [ /vs2015(-\w+)?$/,                 testType,    gte(16)       ],
  [ /vcbt2015(-\w+)?$/,               testType,    gte(16)       ],
  [ /vs2017(-\w+)?$/,                 testType,    gte(16)       ],
  [ /vs2022(-\w+)?$/,                 testType,    lt(20)        ], // Temporarily compile Node v20+ on both VS2019 and VS2022
  [ /vs2015-x86$/,                    testType,    gte(16)       ], // compile arm64/x86 only once
  [ /vs2017-x86$/,                    testType,    gte(16)       ],
  [ /vs2022-x86$/,                    testType,    lt(20)        ], // Temporarily compile Node v20+ arm64 and x86 on both VS2019 and VS2022
  [ /vs2022-arm64$/,                  testType,    lt(20)        ],
  [ /COMPILED_BY-\w+-arm64$/,         testType,    lt(20)        ], // run tests on arm64 for >=19
  // VS versions supported to build add-ons
  [ /vs2013-COMPILED_BY/,             testType,    gte(16)       ],
  [ /vs2015-COMPILED_BY/,             testType,    gte(20)       ],
  [ /vcbt2015-COMPILED_BY/,           testType,    gte(20)       ],
  // Exclude some redundant configurations
  // https://github.com/nodejs/build/blob/main/doc/node-test-commit-matrix.md
  [ /win10.*COMPILED_BY-vs2017/,      testType,    gte(16)       ], // vs2019 runs on win10 for >=13

  // SmartOS -----------------------------------------------
  [ /^smartos18/,                     releaseType, gte(16) ],
  [ /^smartos18/,                     anyType,     gte(16) ],

  // AIX PPC64 ---------------------------------------------
  [ /aix71/,                          anyType,     gte(16) ],

  // Shared libs docker containers -------------------------
  [ /sharedlibs_debug_x64/,           anyType,     gte(18) ],
  [ /sharedlibs_openssl110/,          anyType,     gte(16) ],
  [ /sharedlibs_openssl102/,          anyType,     gte(16) ],
  [ /sharedlibs_fips20/,              anyType,     gte(16) ],

  // OSX ---------------------------------------------------
  [ /osx11-x64-release-tar/,          releaseType, lt(20)  ],
  [ /osx1015-release-pkg/,            releaseType, gte(16) ],
  [ /osx1015-release-tar/,            releaseType, gte(20) ],

  // FreeBSD -----------------------------------------------
  [ /^freebsd10/,                     anyType,     gte(16) ],

  // Source / headers / docs -------------------------------
  [ /^centos7-release-sources$/,      releaseType, gte(18) ],
  [ /^rhel8-release-sources$/,        releaseType, lt(18)  ],

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
  if (parameters['NODEJS_MAJOR_VERSION'] instanceof Integer) {
    nodeMajorVersion = parameters['NODEJS_MAJOR_VERSION']
  } else {
    nodeMajorVersion = (new String(parameters['NODEJS_MAJOR_VERSION'])).toInteger()
  }
println "Node.js major version: $nodeMajorVersion"
if (parameters['NODEJS_VERSION'])
  println "Node.js version: ${new String(parameters['NODEJS_VERSION'])}"

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
  result['nodes'].add(it)
}
