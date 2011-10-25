#!/bin/bash
set -e
VERSION="1.3.0"

mkdir -p build
cd build

if [ ! -d phantomjs ]; then
  git clone git://github.com/ariya/phantomjs.git
fi
cd phantomjs
git checkout $VERSION

time (qmake && make)

mkdir -p installdir/usr
mv bin installdir/usr/

fpm -s dir -t deb -n phantomjs -v $VERSION -C installdir \
  -p phantomjs-VERSION_ARCH.deb \
  -d "libstdc++6 (>= 4.4.3)" \
  -d "libc6 (>= 2.6)" \
  -d "libssl0.9.8 (>= 0.9.8)" \
  -d "zlib1g (>= 1:1.2.2)" \
  -d "libqt4-dev" \
  -d "libqt4-webkit" \
  -d "xvfb" \
  usr/bin

mkdir -p ../../debs
mv *.deb ../../debs/
