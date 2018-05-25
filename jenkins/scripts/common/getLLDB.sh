#!/bin/bash -ex

DOWNLOAD_DIR="http://releases.llvm.org"

# Calculate os and arch.
os="$(uname | tr '[:upper:]' '[:lower:]')"
arch=$(uname -m)

case $os in
  linux) os="linux-gnu-ubuntu-16.04" ;;
  darwin) os="apple-darwin" ;;
  *) echo "$os CI is not supported yet"; exit 1;;
esac

curl "$DOWNLOAD_DIR/$LLDB_VERSION/clang+llvm-$LLDB_VERSION-$arch-$os.tar.xz" |
  tar xJf - # Ubuntu tar can handle zips.

mv clang+llvm-$LLDB_VERSION-$arch-$os llvm-bin/
