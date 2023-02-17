#!/bin/sh
#
# Node.js www server space pruning script.
# Runs against a subdirectory of /home/dist/nodejs and removes old builds:
# - For anything over 2 calendar years ago, retain only the build dated first of the month
# - For anything in last 2 calendar years but not the last two months, retain date numbers ending in 1
# - Keep everything from the last two months.
#

[ $# -lt 2 ] && echo Usage: $0 '[nightly|v8-canary]' '[show|delete]' && exit 1
PRODUCT=$1
[ "$1" != "nightly" -a "$1" != "v8-canary" ] && echo Parameter mist be one of: nightly v8-canary && exit 1
if [ "$2" = "show" ]; then
  RMCOMMAND="echo rm -rv"
elif [ "$2" = "delete" ]; then
  RMCOMMAND="rm -rv"
else
  echo Second parameter must be \"show\" or \"delete\"
  exit 1
fi
# Location to start the search for candidates for removal
cd "/home/dist/nodejs/$PRODUCT" || exit 1

THISYEAR=`date +%Y`
LASTYEAR=`date --date="1 year ago" +%Y`
THISMONTH=`date +%Y%m`
LASTMONTH=`date --date="1 month ago" +%Y%m`
case $PRODUCT in
	v8-canary) STARTVERSION=9;;
	nightly) STARTVERSION=5;;
esac
for VERSION in `seq $STARTVERSION 20`; do

   # Determine the latest nightly for this version so it is never removed
   LATEST=`ls -1d v${VERSION}.* | tail -1`
   [ -z "$LATEST" -o ! -d "$LATEST" ] && echo Could not validate latest version "$LATEST" for Node v${VERSION} && exit 1

   # Versions that aren't from the last two calendar years - keep 1st of the month
   SELECTED=`ls -1d v${VERSION}.* | egrep -v "${PRODUCT}$THISYEAR|${PRODUCT}$LASTYEAR" | grep -v ${PRODUCT}20....01 | grep -v "${LATEST}"`
   SELECTEDCOUNT=`echo $SELECTED | wc -w`
   echo V$VERSION: Selected $SELECTEDCOUNT of `ls -1d v${VERSION}.* | wc -l` from two calendar years ago
   if [ $SELECTEDCOUNT -ne 0 ]; then
     ${RMCOMMAND} $SELECTED
   fi

   # Versions from the last two calendar years except last two months
   # Keep every date number ending in 1 (So 01 11 21 31)
   SELECTED=`ls -1d v${VERSION}.* | egrep    "${PRODUCT}$THISYEAR|${PRODUCT}$LASTYEAR" | egrep -v "${PRODUCT}${THISMONTH}|${PRODUCT}${LASTMONTH}" | grep -v ${PRODUCT}20.....1 | grep -v "${LATEST}"`
   SELECTEDCOUNT=`echo $SELECTED | wc -w`
   echo V$VERSION: Selected $SELECTEDCOUNT of `ls -1d v${VERSION}.* | wc -l` from the last two calendar years
   if [ $SELECTEDCOUNT -ne 0 ]; then
     ${RMCOMMAND} ${SELECTED}
   fi
done

