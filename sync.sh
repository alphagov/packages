#!/bin/sh

s3cmd -c s3cfg-gds --acl-public --delete-removed sync repo/* s3://gds-packages/
