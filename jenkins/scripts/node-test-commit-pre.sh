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

# Run the local copy, if we have one, or fetch the latest from GitHub.
LOCAL_SCRIPT="${WORKSPACE}/build/jenkins/scripts/node-test-commit-diagnostics.sh"
if [ -e "${LOCAL_SCRIPT}" ]; then
  bash -ex "${LOCAL_SCRIPT}" before
else
  curl https://raw.githubusercontent.com/nodejs/build/master/jenkins/scripts/node-test-commit-diagnostics.sh | bash -ex -s before
fi
