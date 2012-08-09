#!/bin/bash
set -e

fpm -s python -t deb pip

mkdir -p debs
mv *.deb debs/
