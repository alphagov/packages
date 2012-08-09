#!/bin/sh
set -e
s3cmd -c s3cfg-gds sync s3://gds-packages/pool/ debs/
