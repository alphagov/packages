#!/bin/bash
set -e
VERSION="1.4"
FILENAME="tika-app-${VERSION}.jar"
URL="http://mirror.ox.ac.uk/sites/rsync.apache.org/tika/$FILENAME"
SHA1SUM="e91c758149ce9ce799fff184e9bf3aabda394abc"

# Make dir structure
mkdir -p build/tika/installdir/usr/bin
mkdir -p build/tika/installdir/usr/share/tika
cd build/tika
rm -f *.deb
pushd installdir/usr/share/tika

# Fetch package
if [ ! -f $FILENAME ]; then
  curl -o $FILENAME $URL
fi

# Validate checksum
echo "${SHA1SUM}  ${FILENAME}" | sha1sum -c -

popd

# Write shell script
cat >installdir/usr/bin/tika <<TIKA_SH
#!/bin/sh
java -jar /usr/share/tika/${FILENAME} \$*
TIKA_SH
chmod +x installdir/usr/bin/tika

# Build package
fpm -s dir -t deb -n tika -v $VERSION -C installdir \
  -a all \
  -p tika-VERSION_ARCH.deb \
  --url http://tika.apache.org/ \
  --description "The Apache Tika toolkit detects and extracts metadata and structured text content from various documents using existing parser libraries." \
  --license "Apache License Version 2.0" \
  usr/bin \
  usr/share

mkdir -p ../../debs
mv *.deb ../../debs/
