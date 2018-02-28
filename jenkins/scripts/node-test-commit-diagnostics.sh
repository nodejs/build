#!/bin/bash -ex

# Diagnostics

# $1: Set to before to print "Before building", otherwise prints "After building"

set +x
DIAGFILE=${HOME}/jenkins_diagnostics.txt
echo >> ${DIAGFILE}
echo >> ${DIAGFILE}
echo >> ${DIAGFILE}
TS="`date`"
echo $TS
echo $TS >> ${DIAGFILE}

[ "$1" = before ] && whenFlag=Before || whenFlag=After
echo "$whenFlag building" >> ${DIAGFILE}

echo $BUILD_TAG >> ${DIAGFILE}
echo $BUILD_URL >> ${DIAGFILE}
echo $NODE_NAME >> ${DIAGFILE}
echo >> ${DIAGFILE}

case "$(uname)" in
  Darwin|FreeBSD) flag=p ;;
  *)              flag=  ;;
esac
echo "netstat -an$flag" >> ${DIAGFILE}
netstat -an$flag >> ${DIAGFILE} 2>&1 || true
unset flag

echo >> ${DIAGFILE}
echo "netstat -gn" >> ${DIAGFILE}
netstat -gn >> ${DIAGFILE} 2>&1 || true
echo >> ${DIAGFILE}
echo "ps auxww" >> ${DIAGFILE}
ps auxww >> ${DIAGFILE} 2>&1 || true
mv ${DIAGFILE} ${DIAGFILE}-OLD || true
tail -c 20000000 ${DIAGFILE}-OLD > ${DIAGFILE} || true
rm ${DIAGFILE}-OLD || true
set -x
pgrep node || true
