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
  [ /debian11/,                       anyType,     gte(24) ],
  [ /rhel8-ppc64le/,                  anyType,     gte(26) ], // Power 8 was dropped in v26
  [ /rhel8-power9le/,                 releaseType, lt(26)  ], // Power 8 was dropped in v26

  // ARM  --------------------------------------------------
  [ /^cross-compiler-rhel8-armv7-gcc-8-glibc-2.28/,  anyType, gte(22) ],
  [ /^cross-compiler-rhel8-armv7-gcc-10-glibc-2.28/, anyType, gte(24) ],
  [ /^cross-compiler-rhel9-armv7-gcc-12-glibc-2.28/, anyType, lt(24)  ],
  [ /armv7/,                                         anyType, gte(24) ],

  // Windows -----------------------------------------------
  // https://github.com/nodejs/build/blob/main/doc/windows-visualstudio-supported-versions.md
  // Release Builders - should only match one VS version per Node.js version
  [ /vs2017/,                         releaseType, gte(22)       ],
  [ /vs2019/,                         releaseType, gte(22)       ],
  [ /vs2022-x86/,                     releaseType, gte(24)       ],
  [ /vs2022(?!_clang)(-\w+)?$/,       releaseType, gte(24)       ],
  [ /vs2022_clang/,                   releaseType, lt(24)        ],
  // VS versions supported to compile Node.js - also matches labels used by test runners
  [ /vs2017(-\w+)?$/,                 testType,    gte(22)       ],
  [ /vs2019(-\w+)?$/,                 testType,    gte(22)       ],
  [ /vs2022-x86$/,                    testType,    gte(24)       ], // x86 was dropped on Windows in v23
  [ /vs2022(?!_clang)(-\w+)?$/,       testType,    gte(24)       ], // MSVC was dropped on Windows in v24
  [ /vs2022_clang(-\w+)?$/,           testType,    lt(24)        ], // ClangCL support was added in v23
  // VS versions supported to build add-ons
  [ /vs2017-COMPILED_BY/,             testType,    gte(22)       ],

  // AIX ---------------------------------------------------
  [ /^aix72-ppc64/,                     anyType,     gte(26) ], // Power 8 was dropped in v26
  [ /^aix72-power9/,                    releaseType, lt(26)  ], // Build releases on Power 9 for >=26

  // SmartOS -----------------------------------------------
  [ /^smartos22/,                     anyType,     gte(26) ],

  // FreeBSD -----------------------------------------------
  [ /^freebsd13/,                     anyType,     gte(22) ], // https://github.com/nodejs/node/issues/54576

  // Shared libs docker containers -------------------------
  [ /sharedlibs_debug_x64/,           anyType,     gte(22) ],
  [ /sharedlibs_openssl110/,          anyType,     gte(22) ],
  [ /sharedlibs_openssl102/,          anyType,     gte(22) ],
  [ /sharedlibs_openssl35/,           anyType,     lt(24)  ], // Temporary until test fixes are backported
  [ /sharedlibs_fips20/,              anyType,     gte(22) ],

  // macOS -------------------------------------------------
  [ /^osx13/,                         anyType,     gte(25) ],
  [ /^macos15/,                       anyType,     lt(25)  ],

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

// NOTE: this assumes that the default "Agents"->"Name" in the Configuration
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
