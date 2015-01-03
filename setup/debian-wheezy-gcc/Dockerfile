FROM debian:wheezy

MAINTAINER Rod Vagg <rvagg@nodesource.com>

RUN echo 'deb-src http://http.debian.net/debian/ jessie main non-free contrib' >> /etc/apt/sources.list

RUN apt-get update

RUN apt-get install -y fakeroot build-essential devscripts g++-multilib libc6-dbg m4 libtool autoconf2.64 autogen gawk zlib1g-dev systemtap-sdt-dev flex gdb locales sharutils procps libantlr-java libffi-dev fastjar libmagic-dev zip libasound2-dev libxtst-dev libxt-dev libart-2.0-dev libcairo2-dev dejagnu chrpath quilt doxygen ghostscript texlive-latex-base xsltproc libxml2-utils docbook-xsl-ns binutils-multiarch gperf bison texinfo libecj-java libgtk2.0-dev libcloog-isl-dev libmpc-dev libmpfr-dev libgmp-dev realpath graphviz libcloog-isl-dev libmpc-dev

RUN cd /usr/src/ && apt-get source gcc-4.9/jessie

ADD deb-control.patch /usr/src/

RUN cd /usr/src/gcc-4.9-4.9.2/debian && patch -p0 < /usr/src/deb-control.patch

VOLUME [ "/opt/debs" ]

CMD cd /usr/src/gcc-4.9-4.9.2/debian && debuild -uc -us && cp /usr/src/*.deb /opt/debs
