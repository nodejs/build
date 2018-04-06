#!/bin/bash

if [ "$DONTSELECT_COMPILER" != "DONT" ]; then
  case $NODE_NAME in
    *ppc64_le* ) SELECT_ARCH=PPC64LE ;;
    *s390x* ) SELECT_ARCH=S390X ;;
  esac
fi

if [ "$SELECT_ARCH" = "PPC64LE" ]; then
  # Set default
  export COMPILER_LEVEL="4.8"

  # Get node version
  NODE_VERSION="$(python tools/getnodeversion.py)"
  NODE_MAJOR_VERSION="$(echo "$NODE_VERSION" | cut -d . -f 1)"
  echo "Setting compiler for Node version $NODE_MAJOR_VERSION on ppc64le"

  if [ "$NODE_MAJOR_VERSION" -gt "9" ]; then
    export COMPILER_LEVEL="4.9"
  fi

  # Select the appropriate compiler
  export CC="gcc-${COMPILER_LEVEL}"
  export CXX="g++-${COMPILER_LEVEL}"
  export LINK="g++-${COMPILER_LEVEL}"
  export LDFLAGS="-Wl,-rpath,$(dirname $($CC --print-file-name libgcc_s.so))"

  echo "Compiler set to $COMPILER_LEVEL"

elif [ "$SELECT_ARCH" = "S390X" ]; then

  # Set default
  # Default is 4.8 but it does not have the prefixes
  export COMPILER_LEVEL=""

  # get node version
  NODE_VERSION="$(python tools/getnodeversion.py)"
  NODE_MAJOR_VERSION="$(echo "$NODE_VERSION" | cut -d . -f 1)"
  echo "Setting compiler for Node version $NODE_MAJOR_VERSION on s390x"

  if [ "$NODE_MAJOR_VERSION" -gt "9" ]; then
    export PATH="$PATH:/data/gcc-4.9/bin"
    export COMPILER_LEVEL="-4.9"
  fi

  # Select the appropriate compiler
  export CC="ccache gcc${COMPILER_LEVEL}"
  export CXX="ccache g++${COMPILER_LEVEL}"
  export LINK="g++${COMPILER_LEVEL}"
  export LDFLAGS="-Wl,-rpath,$(dirname $($CC --print-file-name libgcc_s.so))"

  echo "Compiler set to $COMPILER_LEVEL"
fi
