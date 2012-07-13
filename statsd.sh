#!/bin/bash
set -e
VERSION="0.4.0"

mkdir -p build
cd build

mkdir -p opt
cd opt
if [ ! -d statsd ]; then
  git clone https://github.com/etsy/statsd.git
fi

cd statsd
git checkout v$VERSION
cd ../..

fpm -s dir -t deb -n statsd -v $VERSION \
  -p statsd-VERSION_ARCH.deb \
  -d "nodejs" \
  opt/statsd

mkdir -p ../debs
mv *.deb ../debs/
