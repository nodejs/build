def canBuild(nodeVersion, builderLabel, buildType) {
  def isRelease = buildType == 'release'
  def matches = { match -> builderLabel =~ match }

  // Linux
  if (matches(/^centos5/) && nodeVersion >= 8)
    return false
  if (isRelease && matches(/^centos6/) && nodeVersion < 8)
    return false
  if (matches(/centos[67]-(arm)?(64|32)-gcc48/) && nodeVersion >= 10)
    return false
  if (matches(/centos[67]-(arm)?(64|32)-gcc6/) && nodeVersion < 10)
    return false
  if (isRelease && matches(/centos6-32-gcc6/) && nodeVersion >= 10) // 32-bit linux for <10 only
    return false
  if (matches(/^ubuntu1804/) && nodeVersion < 10) // probably temporary
    return false
  if (matches(/^ubuntu1204/) && nodeVersion >= 10)
    return false

  // Windows
  if (matches(/^vs2013-/) && nodeVersion >= 6)
    return false
  if (matches(/^vs2015-/) && (nodeVersion < 6 || nodeVersion >= 10))
    return false
  if (matches(/^vs2017-/) && nodeVersion < 10)
    return false

  // SmartOS
  if (matches(/^smartos14/) && nodeVersion >= 8)
    return false
  if (matches(/^smartos15/) && nodeVersion < 8)
    return false
  if (isRelease && matches(/^smartos15/) && nodeVersion >= 10)
    return false
  if (matches(/^smartos16/) && nodeVersion < 8)
    return false
  if (matches(/^smartos17/) && nodeVersion < 10)
    return false

  if (matches(/^debian7-docker-armv7$/) && nodeVersion >= 10)
    return false
  if (isRelease && matches(/^debian8-docker-armv7$/) && nodeVersion < 10)
    return false
  if (matches(/^debian9-docker-armv7$/) && nodeVersion < 10)
    return false

  // PPC BE
  if (matches(/^ppcbe-ubuntu/) && nodeVersion >= 8)
    return false

  // s390x
  if (matches(/s390x/) && nodeVersion < 6)
    return false

  // AIX61
  if (matches(/aix61/) && nodeVersion < 6)
    return false

  // sharedlibs containered
  if (matches(/sharedlibs_openssl111/) && nodeVersion < 9)
    return false
  if (matches(/sharedlibs_openssl110/) && nodeVersion < 9)
    return false
  if (matches(/sharedlibs_openssl102/) && nodeVersion > 9)
    return false
  if (matches(/sharedlibs_fips20/) && nodeVersion > 9)
    return false
  if (matches(/sharedlibs_withoutintl/) && nodeVersion < 9)
    return false

  return true
}

// setup for execution of the above rules

int nodeMajorVersion = -1
if (parameters['NODEJS_MAJOR_VERSION'])
  nodeMajorVersion = parameters['NODEJS_MAJOR_VERSION'].toString().toInteger()
println "Node.js major version: $nodeMajorVersion"
println "Node.js version: ${parameters['NODEJS_VERSION']}"

result['nodes'] = []

def _buildType
try {
  _buildType = buildType
} catch (groovy.lang.MissingPropertyException e) {
  _buildType = 'test'
}

combinations.each{
  def builderLabel = it.nodes
  if (nodeMajorVersion >= 4) {
    if (!canBuild(nodeMajorVersion, builderLabel, _buildType)) {
      println "Skipping $builderLabel for Node.js $nodeMajorVersion"
      return
    }
  }
  result['nodes'].add(it)
}

