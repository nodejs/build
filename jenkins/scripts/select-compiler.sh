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
    *armv7l* ) SELECT_ARCH=ARMV7L ;;
    *ibmi74* ) SELECT_ARCH=IBMI74 ;;
  esac
fi

# get node version
if [ -z ${NODEJS_MAJOR_VERSION+x} ]; then
  NODE_VERSION="$(python tools/getnodeversion.py)"
  NODEJS_MAJOR_VERSION="$(echo "$NODE_VERSION" | cut -d . -f 1)"
fi

# Gradual transition to Clang from Node.js 25 (https://github.com/nodejs/build/issues/4091).
if [ "$NODEJS_MAJOR_VERSION" -ge "25" ]; then
  case $NODE_NAME in
    *fedora*)
      echo "Using Clang for Node.js $NODEJS_MAJOR_VERSION"
      export CC="ccache clang"
      export CXX="ccache clang++"
      echo "Compiler set to Clang" `${CXX} -dumpversion`
      return
      ;;
    *debian12*)
      echo "Using Clang for Node.js $NODEJS_MAJOR_VERSION"
      export CC="ccache clang-19"
      export CXX="ccache clang++-19"
      echo "Compiler set to Clang" `${CXX} -dumpversion`
      return
      ;;
    *rhel*|*ubi*)
      echo "Using Clang for Node.js $NODEJS_MAJOR_VERSION"
      export CC="ccache clang"
      export CXX="ccache clang++"
      echo "Compiler set to Clang" `${CXX} -dumpversion`
      return
      ;;
    *alpine*)
      echo "Using Clang for Node.js $NODEJS_MAJOR_VERSION"
      export CC="ccache clang"
      export CXX="ccache clang++"
      echo "Compiler set to Clang" `${CXX} -dumpversion`
      return
      ;;
  esac
fi

# Linux distros should be arch agnostic
case $NODE_NAME in
  *rhel9*|*ubi9*)
    echo "Setting compiler for Node.js $NODEJS_MAJOR_VERSION on" `cat /etc/redhat-release`
    if [ "$NODEJS_MAJOR_VERSION" -gt "22" ]; then
      . /opt/rh/gcc-toolset-12/enable
    elif [ "$NODEJS_MAJOR_VERSION" -gt "21" ]; then
      # s390x, use later toolset to avoid https://gcc.gnu.org/bugzilla/show_bug.cgi?id=106355
      if [ "$SELECT_ARCH" = "S390X" ]; then
        . /opt/rh/gcc-toolset-12/enable
      fi
    fi
    export CC="ccache gcc"
    export CXX="ccache g++"
    echo "Selected compiler:" `${CXX} -dumpversion`
    return
    ;;
  *rhel8*|*ubi8*)
    case "$CONFIG_FLAGS" in
      *--enable-lto*)
        echo "Setting compiler for Node.js $NODEJS_MAJOR_VERSION (LTO) on" `cat /etc/redhat-release`
        if [ "$NODEJS_MAJOR_VERSION" -gt "22" ]; then
          . /opt/rh/gcc-toolset-12/enable
        else
          . /opt/rh/devtoolset-11/enable
        fi
        export CC="ccache gcc"
        export CXX="ccache g++"
        echo "Selected compiler:" `${CXX} -dumpversion`  
        return
        ;;
      *)
        echo "Setting compiler for Node.js $NODEJS_MAJOR_VERSION on" `cat /etc/redhat-release`
        if [ "$NODEJS_MAJOR_VERSION" -gt "22" ]; then
          . /opt/rh/gcc-toolset-12/enable
          export CC="ccache gcc"
          export CXX="ccache g++"
          echo "Selected compiler:" `${CXX} -dumpversion`
          return
        fi
        if [ "$NODEJS_MAJOR_VERSION" -gt "21" ]; then
          # s390x, use later toolset to avoid https://gcc.gnu.org/bugzilla/show_bug.cgi?id=106355
          if [ "$SELECT_ARCH" = "S390X" ]; then
            . /opt/rh/gcc-toolset-12/enable
            export CC="ccache gcc"
            export CXX="ccache g++"
            echo "Selected compiler:" `${CXX} -dumpversion`
            return
          fi
        fi
        if [ "$NODEJS_MAJOR_VERSION" -gt "19" ]; then
          . /opt/rh/gcc-toolset-10/enable
          export CC="ccache gcc"
          export CXX="ccache g++"
          echo "Selected compiler:" `${CXX} -dumpversion`
          return
        fi
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
    ;;
  *ubuntu2204*)
    if [ "$NODEJS_MAJOR_VERSION" -gt "22" ]; then
      export CC="ccache gcc-12"
      export CXX="ccache g++-12"
      echo ""
    else
      # Default gcc on Ubuntu 22.04 is gcc 11.
      export CC="ccache gcc"
      export CXX="ccache g++"
    fi
    echo "Compiler set to GCC" `$CXX -dumpversion`
    return
    ;;
esac

if [ "$SELECT_ARCH" = "PPC64LE" ]; then
  # Set default
  export COMPILER_LEVEL="4.8"

  echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on ppc64le"

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

elif [ "$SELECT_ARCH" = "IBMI74" ]; then
  if [ "$NODEJS_MAJOR_VERSION" -gt "22" ]; then
    export COMPILER_LEVEL="12"
  else
    export COMPILER_LEVEL="10"
  fi
  echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on IBMI74"
  export CC="ccache gcc-${COMPILER_LEVEL}"
  export CXX="ccache g++-${COMPILER_LEVEL}"
  export LINK="g++-${COMPILER_LEVEL}"
  echo "Compiler set to $COMPILER_LEVEL"

elif [ "$SELECT_ARCH" = "AIXPPC" ]; then
  if [ "$NODEJS_MAJOR_VERSION" -gt "22" ]; then
    export COMPILER_LEVEL="12"
  elif [ "$NODEJS_MAJOR_VERSION" -gt "19" ]; then
    export COMPILER_LEVEL="10"
  elif [ "$NODEJS_MAJOR_VERSION" -gt "15" ]; then
    export COMPILER_LEVEL="8"
  elif [ "$NODEJS_MAJOR_VERSION" -gt "9" ]; then
    export COMPILER_LEVEL="6"
  fi

  export AIX_VERSION=`oslevel`
  echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on AIX $AIX_VERSION"
  export CC="gcc-${COMPILER_LEVEL}"
  export CXX="g++-${COMPILER_LEVEL}"
  export LINK="g++-${COMPILER_LEVEL}"
  if [ "$COMPILER_LEVEL" -ne "10" ]; then
    export LIBPATH=/opt/freeware/lib/gcc/powerpc-ibm-aix$AIX_VERSION/$COMPILER_LEVEL/pthread:/opt/freeware/lib:/usr/lib:/lib
  else
    unset LIBPATH
  fi
  export PATH="/opt/ccache-3.7.4/libexec:/opt/freeware/bin:$PATH"
  echo "Compiler set to GCC" `$CXX -dumpversion`

elif [ "$SELECT_ARCH" = "X64" ]; then
  echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on x64"

  case $nodes in
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
    *ubuntu2004* )
      if [ "$NODEJS_MAJOR_VERSION" -gt "19" ]; then
        export CC="ccache gcc-10"
        export CXX="ccache g++-10"
        export LINK="g++-10"
      else
        export CC="ccache gcc"
        export CXX="ccache g++"
        export LINK="g++"
      fi
      echo "Compiler set to GCC" `$CXX -dumpversion`
      ;;
  esac

elif [ "$SELECT_ARCH" = "ARMV7L" ]; then
  echo "Setting compiler for Node version $NODEJS_MAJOR_VERSION on armv7l"

  case $nodes in
    *ubuntu2004* )
      if [ "$NODEJS_MAJOR_VERSION" -gt "19" ]; then
        export CC="ccache gcc-10"
        export CXX="ccache g++-10"
        export LINK="g++-10"
      else
        export CC="ccache gcc"
        export CXX="ccache g++"
        export LINK="g++"
      fi
      echo "Compiler set to GCC" `$CXX -dumpversion`
      ;;
  esac

fi
