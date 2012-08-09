#!/bin/sh
set -e

#
# Although this seems ridiculous, it converts the archless deb provided by
# elasticsearch to an arch=all deb.
#

VERSION="0.19.8"
FILENAME="elasticsearch-${VERSION}.deb"

wget "https://github.com/downloads/elasticsearch/elasticsearch/${FILENAME}"

mkdir -p debs
mv "$FILENAME" "debs/${FILENAME%%.deb}_all.deb"
