#!/bin/bash
set -e

VERSION="3.4.0"
MIRROR="http://apache.mirror.rbftpnetworks.com/lucene/solr"

mkdir -p build
cd build

tarball="apache-solr-$VERSION.tgz"
if [ ! -f $tarball ]; then
  curl -O "$MIRROR/$VERSION/$tarball"
fi
tar zxf $tarball
cd "apache-solr-$VERSION"

for d in solr webapps etc; do
  mkdir -p installdir/opt/solr-$VERSION/$d
done
for d in var/solr/data var/log/solr etc/solr etc/init; do
  mkdir -p installdir/$d
done

cat > installdir/etc/init/solr.conf <<END
start on runlevel [2345]
stop on runlevel [06]

script
  cd /opt/solr-$VERSION
  exec sudo -u solr java \\
    -Xms128M \\
    -Xmx512m \\
    -XX:+UseConcMarkSweepGC \\
    -XX:+UseParNewGC \\
    -Dsolr.solr.home=/opt/solr-$VERSION/solr \\
    -Djava.util.logging.config.file=/opt/solr-$VERSION/etc/logging.properties \\
    -jar /opt/solr-$VERSION/start.jar
end script
END

cat > installdir/opt/solr-$VERSION/solr/solr.xml <<END
<?xml version="1.0" encoding="UTF-8" ?>

<solr persistent="false">
 <cores adminPath="/admin/cores">
   <!--
     <core name="X" instanceDir="/etc/solr/X">
       <property name="instanceDir" value="/etc/solr/X" />
       <property name="dataDir" value="/var/solr/data/X" />
     </core>
   -->
 </cores>
</solr>
END

cat > installdir/opt/solr-$VERSION/etc/logging.properties <<END
.level = INFO
handlers = java.util.logging.FileHandler
java.util.logging.FileHandler.pattern = /var/log/solr/solr.log
java.util.logging.FileHandler.level = ALL
END

for f in lib etc webapps start.jar; do
  cp -R example/$f installdir/opt/solr-$VERSION/
done

fpm \
  -s dir \
  -t deb \
  -n gds-solr \
  -v $VERSION \
  -C installdir \
  -a all \
  -d java6-runtime-headless \
  opt/solr-$VERSION var/solr etc/solr etc/init

mkdir -p ../../debs
mv *.deb ../../debs/
