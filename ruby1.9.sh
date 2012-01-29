#!/bin/bash
set -e

VERSION="1.9.3-p0"
USER_VERSION="-gds3"

mkdir -p build
cd build

# requires build-essential libssl-dev libreadline6-dev zlib1g-dev
if [ ! -d ruby-${VERSION} ]; then
  wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-${VERSION}.tar.gz
  tar -zxvf ruby-${VERSION}.tar.gz
fi

cd ruby-${VERSION}

if [ ! -f 47.diff ]; then
  wget https://github.com/ruby/ruby/pull/47.diff
fi
patch -p1 --forward < 47.diff || echo "Already applied"

if [ ! -f cumulative_performance.patch ]; then
  wget https://raw.github.com/gist/1658360/2eee5541435663deddd674617bf26ae645b015bd/cumulative_performance.patch
fi
patch -p1 --forward < cumulative_performance.patch || echo "Already applied"

./configure \
  --prefix=/usr \
  --with-openssl-dir=/usr \
  --with-readline-dir=/usr \
  --with-zlib-dir=/usr
make
make install DESTDIR=installdir

fpm -s dir -t deb -n ruby -v ${VERSION}${USER_VERSION} -C installdir \
  -p ruby-VERSION_ARCH.deb -d "libstdc++6 (>= 4.4.3)" \
  -d "libc6 (>= 2.6)" -d "libffi5 (>= 3.0.4)" -d "libgdbm3 (>= 1.8.3)" \
  -d "libncurses5 (>= 5.7)" -d "libreadline6 (>= 6.1)" \
  -d "libssl0.9.8 (>= 0.9.8)" -d "zlib1g (>= 1:1.2.2)" \
  usr/bin usr/lib usr/share/man usr/include

mkdir -p ../../debs
mv *.deb ../../debs/
