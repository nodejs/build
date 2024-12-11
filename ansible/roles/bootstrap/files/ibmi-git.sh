#!/QOpenSys/usr/bin/ksh

# Create a git wrapper at /QOpenSys/pkgs/bin/git-jenkins and
# configure it as the "git tool" in Jenkins UI because JV1 Java
# which forces LIBPATH=/usr/lib prior to calling any program
# IBM i open source packages are intalled under /QOpenSys/...
unset LIBPATH
exec /QOpenSys/pkgs/bin/git "$@"
