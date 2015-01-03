## gcc 4.9 package creation for Debian wheezy

On any Docker-capable Linux system, run:

```text
docker build -t debian-wheezy-gcc-49 .
mkdir /tmp/debs
docker run -v /tmp/debs:/opt/debs debian-wheezy-gcc-49
```

And .deb files will be magically placed into */tmp/debs*. Note that this depends specifically on the ***gcc-4.9-4.9.2*** package currently shipped with jessie, if this version changes then the deb-control.patch file will probably need to be adjusted.

Note that the tests are still on for the builds and it will take a long time to complete, so don't expect this to happen quickly.