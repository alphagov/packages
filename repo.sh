#!/bin/bash
set -e
DISTRIBUTIONS="current"
COMPONENTS="main"
ARCHITECTURES="all amd64 i386"

for dist in $DISTRIBUTIONS; do
  for comp in $COMPONENTS; do
    for arch in $ARCHITECTURES; do
      path=repo/dists/$dist/$comp/binary-$arch
      mkdir -p $path
      cat >$path/Release <<END
Archive: gds
Component: $comp
Origin: Government Digital Service, UK
Label: GDS Deployment Repository
Architecture: $arch
END
      cp debs/*_$arch.deb $path/ # TODO: Be cleverer about distributions
      dpkg-scanpackages $path /dev/null | gzip -9c > $path/Packages.gz
    done
  done
done
