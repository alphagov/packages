#!/bin/bash
set -e
VERSION="0.8.2"

mkdir -p build
cd build

if [ ! -d node ]; then
  git clone git://github.com/joyent/node.git
fi
cd node
git checkout v$VERSION

time (./configure --prefix=/usr && make && make install DESTDIR=installdir)

fpm -s dir -t deb -n nodejs -v $VERSION -C installdir \
  -p nodejs-VERSION_ARCH.deb \
  -d "libc-ares2 (>= 1.7.3)" \
  -d "libc6 (>= 2.6)" \
  -d "libev4 (>= 1:4.04)" \
  -d "libgcc1 (>= 1:4.1.1)" \
  -d "libssl1.0.0 (>= 1.0.1)" \
  -d "libstdc++6 (>= 4.1.1)" \
  -d "libv8-3.8.9.20" \
  -d "zlib1g (>= 1:1.1.4)" \
  usr/bin usr/lib usr/share/man usr/include

mkdir -p ../../debs
mv *.deb ../../debs/
