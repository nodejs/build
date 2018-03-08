#!/bin/bash


case $NODE_NAME in
  *ppc64_le* ) SELECT_ARCH=PPC64LE ;;
esac

if [ "$SELECT_ARCH" = "PPC64LE" ]; then
  # set default
  export COMPILER_LEVEL="4.8"

  # get node version
  NODE_VERSION=$(python tools/getnodeversion.py)
  NODE_MAJOR_VERSION="$(echo "$NODE_VERSION" | cut -d . -f 1)"
  echo "Setting compiler for Node version $NODE_MAJOR_VERSION on ppc64le"

  if [ "$NODE_MAJOR_VERSION" -gt "7" ]; then
    export COMPILER_LEVEL="4.9"
  fi

  # select the appropriate compiler
  export CC=gcc-${COMPILER_LEVEL}
  export CXX=g++-${COMPILER_LEVEL}
  export LINK=g++-${COMPILER_LEVEL}
  export LDFLAGS="-Wl,-rpath,$(dirname $($CC --print-file-name libgcc_s.so))"

  echo "Set compiler to $COMPILER_LEVEL"
fi
