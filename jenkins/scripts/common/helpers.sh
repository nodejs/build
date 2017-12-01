# Helper functions and variables. Script should be sourced.

# No POSIX way to get dir of sourced script.
[ "$BASH_VERSION" ] && thisDir="$(dirname ${BASH_SOURCE[0]})"
[ "$ZSH_VERSION" ] && thisDir="$(dirname $0)"
[ -z "$thisDir" ] && { echo "Must be run through bash or ZSH to get sourced dir"; exit 1; }

# Set BUILD_TOOLS to path to BUILD_TOOLS dir, change if you move this file.
export BUILD_TOOLS="$(cd $thisDir/../../; pwd)"

# Get colour aliases.
. "$BUILD_TOOLS"/jenkinsnode/common/colours.sh

error() { echo -e "${BRED}ERROR:${NC} $1"; exit 1; }
warn() { echo -e "${YELLOW}Warning:${NC} $1"; }

# Separator to use in help text.
sep="${MAGENTA}:${NC}"


# Set OS and ARCH variables if unset.
if [ -z "$OS" -a -z "$ARCH" ]; then
  OS="$(uname | tr '[:upper:]' '[:lower:]')"
  ARCH=$(uname -m)

  case $OS in
    *nt*|*NT*) OS=win ;;
    aix) ARCH=ppc64 ;;
  esac

  case $ARCH in
    x86_64) ARCH=x64 ;;
    i686) ARCH=x86 ;;
  esac
  export OS ARCH
fi
