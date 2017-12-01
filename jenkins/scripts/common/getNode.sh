#!/bin/bash -ex

# This script downloads the relevant Node binary for the arch from nodejs.org.
# Download the latest master/v6/v4 build from nodejs.org

. "$(dirname $0)"/colors.sh # Load colors.

# Help text to print on error.
sep="${MAGENTA}:${NC}" # Separator to use in help text.
helpText="Download the node binary for your machine from nodejs.org.
  ${CYAN}USAGE:${NC}
  $0 8.9.1

  8.9.0            $sep Node to download (8.9.0, master, 8, 8.9.0-nightly, latest, 6.2.)
                        Inexact values get most recent from range."

################################################################################
## Parse parameters

unset NODE_VERSION
while getopts ":h" option; do
  case "${option}" in
     h) echo -e "$helpText"; exit 0;;
    \?) echo "Invalid option -$OPTARG."; exit 1 ;;
     :) echo "Option -$OPTARG takes a parameter."; exit 1 ;;
     *) echo "Script doesn't catch the parameter at $OPTIND, $OPTARG."; exit 1 ;;
  esac
done
shift $((OPTIND-1))

error() { echo -e "${BRED}ERROR:${NC} $1"; exit 1; }

[ -z "$1" ] && error "Must provide a node version to download"
NODE_VERSION="${1#v}"; shift # If node version has a v, drop it.

################################################################################
## Work out version to download

rm -rf node-bin/

DOWNLOAD_DIR="https://nodejs.org/download/release/"
case $NODE_VERSION in
  *-nightly*) DOWNLOAD_DIR="https://nodejs.org/download/nightly/" ;;
esac

# Get available versions, grep for NODE_VERSION, and sort by biggest version number.
nodeGrep="$(echo "$NODE_VERSION" | sed 's/\./\\./g')" # Escape dots.
availableVersions=$(curl "$DOWNLOAD_DIR" | grep "^<a href="| cut -d \" -f 2 | tr -d /)

if $(echo "$availableVersions" | grep -q "^v\?$nodeGrep$"); then
  version="$NODE_VERSION"
else
  version=$(echo "$availableVersions" | grep "^v$nodeGrep" |
    sort -n -t . -k 1.2 -k 2 -k 3 | tail -1)
fi

# Calculate os and arch.
os="$(uname | tr '[:upper:]' '[:lower:]')"
arch=$(uname -m)

case $os in
  *nt*|*NT*) os=win ext=zip;;
  aix) arch=ppc64 ;;
esac
[ "$os" != win ] && ext=tar.gz

# TODO(gib): Handle x86 SmartOS (currently uses x64).
# TODO(gib): Handle arm64 machines.
case $arch in
  x86_64|i86pc) arch=x64 ;; # i86pc is SmartOS.
  i686) arch=x86 ;;
esac

################################################################################
## Download and extract Node

curl "$DOWNLOAD_DIR$version/node-$version-$os-$arch.$ext" |
  gzip -cd | tar xf - # Non-GNU tar can't handle gzips.
mv node-$version-$os-$arch node-bin/
