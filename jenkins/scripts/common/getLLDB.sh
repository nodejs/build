#!/bin/bash -ex

DOWNLOAD_DIR="http://apt.llvm.org/xenial/pool/main/l/llvm-toolchain-$LLDB_VERSION/"

rm -rf lldb-bin/

# Calculate os and arch.
os="$(uname | tr '[:upper:]' '[:lower:]')"
arch=$(uname -m)

case $os in
  linux) echo "$os found. Assuming Ubuntu 16.04...";;
  darwin) exit 0;;
  *) echo "$os CI is not supported yet"; exit 1;;
esac

case $arch in
  x86_64) arch=amd64;;
esac

files=$(curl --compressed -L -s "$DOWNLOAD_DIR" | grep "^<a href=" | cut -d \" -f 2)
debFilename=$(echo "$files" | grep "^lldb-$LLDB_VERSION.*$arch.deb")
debFilename2=$(echo "$files" | grep "^libllvm$LLDB_VERSION.*$arch.deb")

mkdir lldb-bin

dpkg-deb -xv <(curl -L -s "${DOWNLOAD_DIR}${debFilename}") lldb-bin/
dpkg-deb -xv <(curl -L -s "${DOWNLOAD_DIR}lib${debFilename}") lldb-bin/
dpkg-deb -xv <(curl -L -s "${DOWNLOAD_DIR}${debFilename2}") lldb-bin/

ln -s $(pwd)/lldb-bin/usr/bin/lldb-${LLDB_VERSION} $(pwd)/lldb-bin/usr/bin/lldb
