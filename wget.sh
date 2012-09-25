#!/bin/bash
set -e

mkdir -p build
cd build

VERSION="1.14"

rm "wget-${VERSION}.tar.gz"
wget "http://ftp.gnu.org/gnu/wget/wget-${VERSION}.tar.gz"
tar zxf "wget-${VERSION}.tar.gz"

cd "wget-${VERSION}"

time (
  ./configure --prefix=/usr --sysconfdir=/etc --with-ssl=openssl
  make
  make install DESTDIR="$(pwd)/installdir"
)

fpm -s dir -t deb -n wget -v "$VERSION" -C installdir \
  -p wget-VERSION_ARCH.deb \
  -d "debhelper (>> 5.0.0)" \
  -d gettext \
  -d texinfo \
  -d "libssl-dev (>= 0.9.8k-7ubuntu4)" \
  -d autotools-dev \
  -d libidn11-dev \
  usr etc

mkdir -p ../../debs
mv *.deb ../../debs/
