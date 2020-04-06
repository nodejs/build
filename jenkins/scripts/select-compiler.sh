# Usage:
#   .../node % . ./build/jenkins/scripts/select-compiler.sh
#
# This file is sourced from the CWD of node by CI build scripts to select the
# compiler to be used based on the version of node in the CWD.
#
# It must be /bin/sh syntax (no bashims).

# Notes and warnings:
# - ccache and CC: v8 builds (at least) depend on the ability to be able to do
# `ln -s $CC some/place` (but only on some plaforms), so the
# `export CC="ccache /a/gcc-version/cc"` idiom breaks those builds. The best
# way to do ccache is to push `/path/to/gcc-version` on to the front of PATH,
# then push a `/path/to/ccache/wrappers` in front of the compiler path.

if [ "$DONTSELECT_COMPILER" != "DONT" ]; then
  NODE_NAME=${NODE_NAME:-$HOSTNAME}
  echo "Selecting compiler based on $NODE_NAME"
  case $NODE_NAME in
    *ppc64*le* ) SELECT_ARCH=PPC64LE ;;
    *s390x* ) SELECT_ARCH=S390X ;;
    *aix* ) SELECT_ARCH=AIXPPC ;;
    *x64* ) SELECT_ARCH=X64 ;;
    *arm64* ) SELECT_ARCH=ARM64 ;;
  esac
fi

# get node version
if [ -z ${NODEJS_MAJOR_VERSION+x} ]; then
  NODE_VERSION="$(python tools/getnodeversion.py)"
  NODEJS_MAJOR_VERSION="$(echo "$NODE_VERSION" | cut -d . -f 1)"
fi

if [ "$SELECT_ARCH" = "PPC64LE" ]; then
  # Set default
  export COMPILER_LEVEL="4.8"

  echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on ppc64le"

  case $NODE_NAME in
    *centos7* )
      if [ "$NODEJS_MAJOR_VERSION" -gt "13" ]; then
        # Setup devtoolset-8, sets LD_LIBRARY_PATH, PATH, etc.
        . /opt/rh/devtoolset-8/enable
        export CC="ccache ppc64le-redhat-linux-gcc"
        export CXX="ccache ppc64le-redhat-linux-g++"
        export LINK="ppc64le-redhat-linux-g++"
        echo "Compiler set to devtoolset-8"
        return
      fi
      ;;
    *centos7* )
      if [ "$NODEJS_MAJOR_VERSION" -gt "9" ]; then
        # Setup devtoolset-6, sets LD_LIBRARY_PATH, PATH, etc.
        . /opt/rh/devtoolset-6/enable
        export CC="ccache ppc64le-redhat-linux-gcc"
        export CXX="ccache ppc64le-redhat-linux-g++"
        export LINK="ppc64le-redhat-linux-g++"
        echo "Compiler set to devtoolset-6"
        return
      fi
      ;;
   esac

  if [ "$NODEJS_MAJOR_VERSION" -gt "11" ]; then
    # See: https://github.com/nodejs/build/pull/1723#discussion_r265740122
    export PATH=/usr/lib/binutils-2.26/bin/:$PATH
    export COMPILER_LEVEL="6"
  elif [ "$NODEJS_MAJOR_VERSION" -gt "9" ]; then
    export PATH=/usr/lib/binutils-2.26/bin/:$PATH
    export COMPILER_LEVEL="4.9"
  fi

  # Select the appropriate compiler
  export CC="gcc-${COMPILER_LEVEL}"
  export CXX="g++-${COMPILER_LEVEL}"
  export LINK="g++-${COMPILER_LEVEL}"

  echo "Compiler set to $COMPILER_LEVEL"

elif [ "$SELECT_ARCH" = "S390X" ]; then

  # Set default
  # Default is 4.8 but it does not have the prefixes
  export COMPILER_LEVEL=""

  echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on s390x"

  if [ "$NODEJS_MAJOR_VERSION" -gt "9" ]; then
    # Setup devtoolset-6, sets LD_LIBRARY_PATH, PATH, etc.
    . /opt/rh/devtoolset-6/enable
    export CC="ccache s390x-redhat-linux-gcc"
    export CXX="ccache s390x-redhat-linux-g++"
    export LINK="s390x-redhat-linux-g++"
    echo "Compiler set to devtoolset-6"
  else
    # Select the appropriate compiler
    export CC="ccache gcc${COMPILER_LEVEL}"
    export CXX="ccache g++${COMPILER_LEVEL}"
    export LINK="g++${COMPILER_LEVEL}"
    echo "Compiler set to $COMPILER_LEVEL"
  fi

elif [ "$SELECT_ARCH" = "AIXPPC" ]; then
  case $NODE_NAME in
    *aix72* )
      echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on AIX7.2"

      if [ "$NODEJS_MAJOR_VERSION" -gt "9" ]; then
        export LIBPATH=/opt/gcc-6.3/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/pthread/ppc64:/opt/gcc-6.3/lib
        export PATH="/opt/ccache-3.7.4/libexec:/opt/gcc-6.3/bin:/opt/freeware/bin:$PATH"
        export CC="gcc" CXX="g++" CXX_host="g++"
        echo "Compiler set to 6.3"
        return
      else
        echo "Compiler left as system default:" `g++ -dumpversion`
        return
      fi
      ;;
    
    *aix71* )
      echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on AIX7.1"

      if [ "$NODEJS_MAJOR_VERSION" -gt "9" ]; then
        export PATH="/opt/ccache-3.7.4/libexec:/opt/freeware/gcc6/bin:/opt/freeware/bin:$PATH"
        export CC="gcc" CXX="g++" CXX_host="g++"
        echo "Compiler set to 6.3"
        return
      else
        echo "Compiler left as system default:" `g++ -dumpversion`
        return
      fi
      ;;
  esac

  
  echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on AIX61"

  if [ "$NODEJS_MAJOR_VERSION" -gt "9" ]; then
    export LIBPATH=/home/iojs/gmake/opt/freeware/lib:/home/iojs/gcc-6.3.0-1/opt/freeware/lib/gcc/powerpc-ibm-aix6.1.0.0/6.3.0/pthread/ppc64:/home/iojs/gcc-6.3.0-1/opt/freeware/lib
    export PATH="/home/iojs/gcc-6.3.0-1/opt/freeware/bin:$PATH"
    export CC="ccache `which gcc`" CXX="ccache `which g++`" CXX_host="ccache `which g++`"
    # TODO(sam-github): configure ccache by pushing /opt/freeware/bin/ccache on
    # front of PATH
    echo "Compiler set to 6.3"
  else
    export CC="ccache `which gcc`" CXX="ccache `which g++`" CXX_host="ccache `which g++`"
    # TODO(sam-github): configure ccache by pushing /opt/freeware/bin/ccache on
    # front of PATH
    echo "Compiler set to default at 4.8.5"
  fi

elif [ "$SELECT_ARCH" = "X64" ]; then
  echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on x64"

  case $nodes in
    centos6-64-gcc48 )
      . /opt/rh/devtoolset-2/enable
      echo "Compiler set to devtoolset-2"
      ;;
    centos[67]-64-gcc6 )
      . /opt/rh/devtoolset-6/enable
      echo "Compiler set to devtoolset-6"
      ;;
    *ubuntu1604-*64|benchmark )
      if [ "$NODEJS_MAJOR_VERSION" -gt "12" ]; then
        export CC="gcc-6"
        export CXX="g++-6"
        export LINK="g++-6"
        echo "Compiler set to GCC 6 for $NODEJS_MAJOR_VERSION"
      fi
      ;;
  esac

elif [ "$SELECT_ARCH" = "ARM64" ]; then
  echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on arm64"


  case $nodes in
    centos[67]-arm64-gcc6 )
      . /opt/rh/devtoolset-6/enable
      echo "Compiler set to devtoolset-6"
      ;;
  esac

fi
