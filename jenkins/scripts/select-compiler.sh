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
    *ibmi73* ) SELECT_ARCH=IBMI73 ;;
  esac
fi

# get node version
if [ -z ${NODEJS_MAJOR_VERSION+x} ]; then
  NODE_VERSION="$(python tools/getnodeversion.py)"
  NODEJS_MAJOR_VERSION="$(echo "$NODE_VERSION" | cut -d . -f 1)"
fi

# Linux distros should be arch agnostic
case $NODE_NAME in
  *rhel8*)
    case "$CONFIG_FLAGS" in
      *--enable-lto*)
        echo "Setting compiler for Node.js $NODEJS_MAJOR_VERSION (LTO) on" `cat /etc/redhat-release`
        . /opt/rh/gcc-toolset-11/enable
        export CC="ccache gcc"
        export CXX="ccache g++"
        echo "Selected compiler:" `${CXX} -dumpversion`  
        return
        ;;
      *)
        echo "Setting compiler for Node.js $NODEJS_MAJOR_VERSION on" `cat /etc/redhat-release`
        # Default gcc on RHEL 8 is gcc 8.
        if [ "$v8test" != "" ]; then
          # For V8 builds make `gcc` and `g++` point to non-ccache shims.
          export PATH=/usr/bin:$PATH
          export CC="ccache gcc"
          export CXX="ccache g++"
        else
          export CC="gcc"
          export CXX="g++"
        fi
        echo "Compiler left as system default:" `${CXX} -dumpversion`
        return
        ;;
    esac
    return
    ;;
esac

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
      elif [ "$NODEJS_MAJOR_VERSION" -gt "9" ]; then
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

elif [ "$SELECT_ARCH" = "S390X" ]; then

  # Set default
  # Default is 4.8 but it does not have the prefixes
  export COMPILER_LEVEL=""

  echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on s390x"

  # LTO builds need later compilers
  case $nodes in
    rhel7-lto-s390x)
      # Setup devtoolset-10, sets LD_LIBRARY_PATH, PATH, etc.
      . /opt/rh/devtoolset-10/enable
      export CC="ccache s390x-redhat-linux-gcc"
      export CXX="ccache s390x-redhat-linux-g++"
      export LINK="s390x-redhat-linux-g++"
      echo "Compiler set to devtoolset-10"
      return;
      ;;
  esac

  if [ "$NODEJS_MAJOR_VERSION" -gt "13" ]; then
    # Setup devtoolset-8, sets LD_LIBRARY_PATH, PATH, etc.
    . /opt/rh/devtoolset-8/enable
    export CC="ccache s390x-redhat-linux-gcc"
    export CXX="ccache s390x-redhat-linux-g++"
    export LINK="s390x-redhat-linux-g++"
    echo "Compiler set to devtoolset-8"
  elif [ "$NODEJS_MAJOR_VERSION" -gt "9" ]; then
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

elif [ "$SELECT_ARCH" = "IBMI73" ]; then
  export COMPILER_LEVEL="10"
  echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on IBMI73"
  export CC="ccache gcc-${COMPILER_LEVEL}"
  export CXX="ccache g++-${COMPILER_LEVEL}"
  export LINK="g++-${COMPILER_LEVEL}"
  echo "Compiler set to $COMPILER_LEVEL"

elif [ "$SELECT_ARCH" = "AIXPPC" ]; then
  case $NODE_NAME in
    *aix72* )
      echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on AIX7.2"
      if [ "$NODEJS_MAJOR_VERSION" -gt "15" ]; then
        export PATH="/opt/ccache-3.7.4/libexec:/opt/freeware/bin:$PATH"
        export CC="gcc" CXX="g++" CXX_host="g++"
        unset LIBPATH
        echo "Compiler set to 8.3"
        return
      elif [ "$NODEJS_MAJOR_VERSION" -gt "9" ]; then
        export PATH="/opt/ccache-3.7.4/libexec:/opt/gcc-6.3/bin:/opt/freeware/bin:$PATH"
        export CC="gcc" CXX="g++" CXX_host="g++"
        export LIBPATH=/opt/gcc-6.3/lib/gcc/powerpc-ibm-aix7.2.0.0/6.3.0/pthread/ppc64:/opt/gcc-6.3/lib
        echo "Compiler set to 6.3"
        return
      else
        echo "Compiler left as system default:" `g++ -dumpversion`
        return
      fi
      ;;
    
    *aix71* )
      echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on AIX7.1"
      if [ "$NODEJS_MAJOR_VERSION" -gt "15" ]; then
        export PATH="/opt/ccache-3.7.4/libexec:/opt/freeware/bin:$PATH"
        export CC="gcc" CXX="g++" CXX_host="g++"
        unset LIBPATH
        echo "Compiler set to 8.3"
        return
      elif [ "$NODEJS_MAJOR_VERSION" -gt "9" ]; then
        export PATH="/opt/ccache-3.7.4/libexec:/opt/freeware/gcc6/bin:/opt/freeware/bin:$PATH"
        export CC="gcc-6" CXX="g++-6" CXX_host="g++-6"
        unset LIBPATH
        echo "Compiler set to 6.3"
        return
      else
        echo "Compiler left as system default:" `g++ -dumpversion`
        return
      fi
      ;;
  esac

elif [ "$SELECT_ARCH" = "X64" ]; then
  echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on x64"

  case $nodes in
    centos7-64-gcc8 )
      . /opt/rh/devtoolset-8/enable
      echo "Compiler set to devtoolset-8"
      ;;
    centos6-64-gcc48 )
      . /opt/rh/devtoolset-2/enable
      echo "Compiler set to devtoolset-2"
      ;;
    centos[67]-64-gcc6 )
      . /opt/rh/devtoolset-6/enable
      echo "Compiler set to devtoolset-6"
      ;;
    centos7-release-sources )
      if [ "$NODEJS_MAJOR_VERSION" -gt "15" ]; then
        . /opt/rh/devtoolset-8/enable
      else
        . /opt/rh/devtoolset-6/enable
      fi
      export CC="ccache gcc"
      export CXX="ccache g++"
      echo "Compiler set to GCC" `$CXX -dumpversion`
      ;;
    *ubuntu1804*64|*ubuntu1604-*64|benchmark )
      if [ "$NODEJS_MAJOR_VERSION" -gt "15" ]; then
        export CC="ccache gcc-8"
        export CXX="ccache g++-8"
        export GCOV="gcov-8"
        export LINK="g++-8"
      else
        export CC="ccache gcc-6"
        export CXX="ccache g++-6"
        export GCOV="gcov-6"
        export LINK="g++-6"
      fi
      echo "Compiler set to GCC" `$CXX -dumpversion`
      ;;
  esac

elif [ "$SELECT_ARCH" = "ARM64" ]; then
  echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on arm64"


  case $nodes in
    centos7-arm64-gcc8 )
      . /opt/rh/devtoolset-8/enable
      echo "Compiler set to devtoolset-8"
      ;;
    centos[67]-arm64-gcc6 )
      . /opt/rh/devtoolset-6/enable
      echo "Compiler set to devtoolset-6"
      ;;
    *ubuntu1804* )
      if [ "$NODEJS_MAJOR_VERSION" -gt "15" ]; then
        export CC="ccache gcc-8"
        export CXX="ccache g++-8"
        export GCOV="gcov-8"
        export LINK="g++-8"
      else
        export CC="ccache gcc-6"
        export CXX="ccache g++-6"
        export GCOV="gcov-6"
        export LINK="g++-6"
      fi
      echo "Compiler set to GCC" `$CXX -dumpversion`
      ;;
  esac

fi
