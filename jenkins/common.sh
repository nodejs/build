### Common Environment Variables ###
# NODE_VERSION: Exact or vague version, e.g. "v8", "v5.5.0", "master"
# DOWNLOAD_DIR: "release" or "nightly" (Default: "release")
# MACHINE: Jenkins worker label, Jenkins.getInstance().getLabels() in Script
#   Console, e.g. "ppcle-ubuntu1404", "smartos16-64".

curlNode() {

  # Download the latest master/v6/v4 build from nodejs.org.

  if [ -z "$NODE_VERSION" ]; then
    echo "NODE_VERSION is undefined! Please declare a NODE_VERSION"
    return 1
  fi

  DOWNLOAD_DIR=${DOWNLOAD_DIR:-release}

  local baseUrl="https://nodejs.org/download/$DOWNLOAD_DIR"

  # Sort numerically on "v8.0.0-nightly20161029ec7c27f4cb/", separator = "." skipping first char (v).
  local nodeUrl=$(curl $baseUrl | grep $NODE_VERSION | cut -d \" -f 2 | sort -nt . -k 1,2 | tail -1 | tr -d /)

  local os arch ext
  case $MACHINE in
    ubuntu*-64|debian*-64|fedora*|centos*) os=linux; arch=x64; ext=tar.gz;;
    osx*) os=darwin; arch=x64; ext=tar.gz;;
    ppcle-ubuntu*) os=linux; arch=ppc64le; ext=tar.gz;;
    *-s390x) os=linux; arch=s390x; ext=tar.gz;;
    aix*) os=aix; arch=ppc64; ext=tar.gz;;
    ppcbe-*) os=linux; arch=ppc64; ext=tar.gz;;
    win*) os=win; arch=x64; ext=zip;;
  esac

  curl -O "$baseUrl/$nodeUrl/node-$nodeUrl-$os-$arch.$ext"

  case $MACHINE in
    win*) unzip node-$nodeUrl-$os-$arch.$ext ;;
    *) gzip -cd node-$nodeUrl-$os-$arch.$ext | tar xf - ;;
  esac

}
