#!/bin/bash
set -e
VERSION="0.97.5"
CLAMDIR=clamav-${VERSION}
INSTALLDIR=/opt/clamav

mkdir -p build
mkdir -p build/${CLAMDIR}
cp clamav/* build/${CLAMDIR}
cd build

if [ ! -d $CLAMDIR ]; then
  echo "Downloading clamav"
  curl --location-trusted  "http://downloads.sourceforge.net/project/clamav/clamav/0.97.5/clamav-0.97.5.tar.gz" -o clam-av.tar.gz
  tar zxvf clam-av.tar.gz
fi

getent passwd clamav || sudo useradd -U clamav -s /bin/false -d /dev/null
cd $CLAMDIR
time (./configure --prefix=${INSTALLDIR} && make -j2 && sudo make install)

sudo rm ${INSTALLDIR}/etc/clamd.conf
sudo -s 'cat > /opt/clamav/etc/clamd.conf << END
LogFile /var/log/clamd/clamd.log
LogFileMaxSize 2M
LogTime yes
LogSyslog no
LogVerbose yes
ExtendedDetectionInfo yes
TCPSocket 3310
TCPAddr 127.0.0.1
MaxConnectionQueueLength 50
StreamMaxLength 50M
MaxThreads 20
ReadTimeout 120
DetectPUA yes
AlgorithmicDetection yes
ScanPE yes
ScanELF yes
ScanOLE2 yes
OLE2BlockMacros no
ScanPDF yes
ScanMail yes
MaxScanSize 100M
MaxFileSize 30M
END'

sudo rm ${INSTALLDIR}/etc/freshclam.conf
sudo -s 'cat > /opt/clamav/etc/freshclam.conf << END
UpdateLogFile /var/log/clamd/freshclam.log
LogFileMaxSize 2M
LogTime yes
LogVerbose yes
LogSyslog no
DatabaseMirror database.clamav.net
END'

fpm -s dir \
	-t deb \
	-n clamav \
	-v $VERSION \
	-C $INSTALLDIR \
  --after-install clamav-postinstall \
  --after-remove clamav-postremove \
  -p clamav-VERSION_ARCH.deb \
  -d "debconf (>= 0.5) | debconf-2.0" \
  -d "libc6 (>= 2.11.1)" \
  -d "logrotate" \
  -d "lsb-base (>= 3.2-13)" \
  -d "ucf" \
  -d "zlib1g (>= 1:1.1.4)" \
  /opt/clamav/bin /opt/clamav/etc /opt/clamav/include /opt/clamav/lib /opt/clamav/sbin /opt/clamav/share

mkdir -p ../../debs
mv *.deb ../../debs/

