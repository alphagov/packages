#!/bin/bash
set -e

VERSION="1.9.3-p0"

mkdir -p build
cd build

# requires build-essential libssl-dev libreadline6-dev zlib1g-dev
if [ ! -d ruby-${VERSION} ]; then
  wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-${VERSION}.tar.gz
  tar -zxvf ruby-${VERSION}.tar.gz
fi

cd ruby-${VERSION}

./configure \
  --prefix=/usr \
  --with-openssl-dir=/usr \
  --with-readline-dir=/usr \
  --with-zlib-dir=/usr
make
make install DESTDIR=installdir

fpm -s dir -t deb -n ruby -v ${VERSION} -C installdir \
  -p ruby-VERSION_ARCH.deb -d "libstdc++6 (>= 4.4.3)" \
  -d "libc6 (>= 2.6)" -d "libffi5 (>= 3.0.4)" -d "libgdbm3 (>= 1.8.3)" \
  -d "libncurses5 (>= 5.7)" -d "libreadline6 (>= 6.1)" \
  -d "libssl0.9.8 (>= 0.9.8)" -d "zlib1g (>= 1:1.2.2)" \
  usr/bin usr/lib usr/share/man usr/include

mkdir -p ../../debs
mv *.deb ../../debs/
