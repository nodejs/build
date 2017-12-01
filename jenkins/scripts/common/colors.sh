# Helper vars for printing in color. Use with:
# echo -e "${RED}foo${NC}" # Echo foo in red, then reset color.
# printf "${BBLUE}foo${NC}" # Echo foo in bright blue, then reset color.

# Include (source) with this line:
# . $(dirname $0)/helpers/colors.sh # Load helper script from gcfg/helpers.

# Color escape codes, use with . Don't change \033 to \e, that doesn't work on
# macOS (\x1B instead).

# I've kept the standard names, even though e.g. WHITE isn't white (use BWHITE).
# There are also a bajillion more combos (e.g. BGREDFGBLUE) with different
# FG/BG color combos, but I haven't needed these yet.

case $- in *x*) xSet=true ;; esac # Note whether -x was set before.
set +x

# Reset color:
NC='\033[0m' # No Color.

# Basic colors:
BLACK='\033[0;30m'      # Black.
RED='\033[0;31m'        # Red.
GREEN='\033[0;32m'      # Green.
YELLOW='\033[0;33m'     # Yellow.
BLUE='\033[0;34m'       # Blue.
MAGENTA='\033[0;35m'    # Magenta (purple).
CYAN='\033[0;36m'       # Light blue.
WHITE='\033[0;37m'      # Light grey.

# Bright colors:
BBLACK='\033[1;30m'     # Bright black (dark grey).
BRED='\033[1;31m'       # Bright Red.
BGREEN='\033[1;32m'     # Bright Green.
BYELLOW='\033[1;33m'    # Bright Yellow.
BBLUE='\033[1;34m'      # Bright Blue.
BMAGENTA='\033[1;35m'   # Bright Magenta (pink).
BCYAN='\033[1;36m'      # Bright Light blue.
BWHITE='\033[1;37m'     # Bright white (white).

# Background colors:
BGBLACK='\033[0;40m'    # Background Black.
BGRED='\033[0;41m'      # Background Red.
BGGREEN='\033[0;42m'    # Background Green.
BGYELLOW='\033[0;43m'   # Background Yellow.
BGBLUE='\033[0;44m'     # Background Blue.
BGMAGENTA='\033[0;45m'  # Background Magenta (purple).
BGCYAN='\033[0;46m'     # Background Light blue.
BGWHITE='\033[0;47m'    # Background Light grey.

# Bright background colors:
BGBBLACK='\033[1;40m'   # Background Bright Black (dark grey).
BGBRED='\033[1;41m'     # Background Bright Red.
BGBGREEN='\033[1;42m'   # Background Bright Green.
BGBYELLOW='\033[1;43m'  # Background Bright Yellow.
BGBBLUE='\033[1;44m'    # Background Bright Blue.
BGBMAGENTA='\033[1;45m' # Background Bright Magenta (pink).
BGBCYAN='\033[1;46m'    # Background Bright Light blue.
BGBWHITE='\033[1;47m'   # Background Bright white.

[ "$xSet" ] && set -x # If -x was set before, restore it.
