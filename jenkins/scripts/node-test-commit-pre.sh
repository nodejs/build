###
# node-test-commit-pre
# All actions run before pending post-build-status-update job is run
###

# Git
git --version

# Name and email in git config need to be the same across all jobs
# so that git rebase --committer-date-is-author-date will produce
# the same commit SHA1
git config --replace-all user.name Dummy
git config --replace-all user.email dummy@dummy.com
git config user.name
git config user.email
echo $GIT_COMMITTER_NAME
echo $GIT_AUTHOR_NAME

git rebase --abort || true
git checkout -f refs/remotes/origin/_jenkins_local_branch
git config user.name
git config user.email
echo $GIT_COMMITTER_NAME
echo $GIT_AUTHOR_NAME

git status
git rev-parse HEAD
git rev-parse $REBASE_ONTO

if [ -n "${REBASE_ONTO}" ]; then
  git rebase --committer-date-is-author-date $REBASE_ONTO
fi

if [ -n "${POST_REBASE_SHA1_CHECK}" ]; then
  check_sha1=${POST_REBASE_SHA1_CHECK}
  head_sha1=$(git rev-parse HEAD)
  if [ "$head_sha1" != "$check_sha1" ]; then
    exit 1
  fi
fi

# Diagnostics
set +x
DIAGFILE=${HOME}/jenkins_diagnostics.txt
echo >> ${DIAGFILE}
echo >> ${DIAGFILE}
echo >> ${DIAGFILE}
TS="`date`"
echo $TS
echo $TS >> ${DIAGFILE}
echo "Before building" >> ${DIAGFILE}
echo $BUILD_TAG >> ${DIAGFILE}
echo $BUILD_URL >> ${DIAGFILE}
echo $NODE_NAME >> ${DIAGFILE}
echo >> ${DIAGFILE}

case "$(uname)" in
  Darwin|FreeBSD) FLAG=p ;;
  *)              FLAG=  ;;
esac
echo "netstat -an$FLAG" >> ${DIAGFILE}
netstat -an$FLAG >> ${DIAGFILE} 2>&1 || true
unset FLAG

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
