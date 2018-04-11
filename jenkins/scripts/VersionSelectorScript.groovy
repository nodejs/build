def canBuild(nodeMajorVersion, builderLabel, buildType) {

  // Linux
  if (builderLabel.indexOf('centos5') == 0 && nodeMajorVersion >= 8)
    return false
  if (buildType == 'release' && builderLabel.indexOf('centos6') == 0 && nodeMajorVersion < 8)
    return false
  if (builderLabel =~ /centos[67]-(arm)?64-gcc48/ && nodeMajorVersion >= 10)
    return false
  if (builderLabel =~ /centos[67]-(arm)?64-gcc6/ && nodeMajorVersion < 10)
    return false

  // Windows
  if (builderLabel.indexOf('vs2013-') == 0 && nodeMajorVersion >= 6)
    return false
  if (builderLabel.indexOf('vs2015-') == 0 && (nodeMajorVersion < 6 || nodeMajorVersion >= 10))
    return false
  if (builderLabel.indexOf('vs2017-') == 0 && nodeMajorVersion < 10)
    return false

  // SmartOS
  if (builderLabel.indexOf('smartos13') == 0) // Node.js 0.x
    return false
  if (builderLabel.indexOf('smartos14') == 0 && nodeMajorVersion >= 8)
    return false
  if (builderLabel.indexOf('smartos15') == 0 && nodeMajorVersion < 8)
    return false

  if (builderLabel.equals('debian7-docker-armv7') && nodeMajorVersion >= 10)
    return false
  if (buildType == 'release' && builderLabel.equals('debian8-docker-armv7') && nodeMajorVersion < 10)
    return false
  if (builderLabel.equals('debian9-docker-armv7') && nodeMajorVersion < 10)
    return false

  // PPC BE
  if (builderLabel.indexOf('ppcbe-ubuntu') == 0 && nodeMajorVersion >= 8)
    return false

  // s390x
  if (builderLabel.indexOf('s390x') > -1 && nodeMajorVersion < 6)
    return false

  // AIX61
  if (builderLabel.indexOf('aix61') > -1 && nodeMajorVersion < 6)
    return false

  // sharedlibs containered
  if (builderLabel.indexOf('sharedlibs_openssl111') > -1 && nodeMajorVersion < 9)
    return false
  if (builderLabel.indexOf('sharedlibs_openssl110') > -1 && nodeMajorVersion < 9)
    return false
  if (builderLabel.indexOf('sharedlibs_openssl102') > -1 && nodeMajorVersion > 9)
    return false
  if (builderLabel.indexOf('sharedlibs_fips20') > -1 && nodeMajorVersion > 9)
    return false
  if (builderLabel.indexOf('sharedlibs_withoutintl') > -1 && nodeMajorVersion < 9)
    return false

  return true
}

// setup for execution of the above rules

int nodeMajorVersion = -1
if (parameters['NODEJS_MAJOR_VERSION'])
  nodeMajorVersion = parameters['NODEJS_MAJOR_VERSION'].toString().toInteger()
println 'Node.js major version: ' + nodeMajorVersion
println 'Node.js version: ' + parameters['NODEJS_VERSION']

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
      println 'Skipping ' + builderLabel + ' for Node.js ' + nodeMajorVersion
      return
    }
  }
  result['nodes'] << it
}

