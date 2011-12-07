GDS apt repository
==================

This collection of scripts will handle the building and uploading of packages
for the GDS apt repository, which is hosted on S3.

Extra files
-----------

You will need these files which, for obvious reasons, are not included in the
repository:

* `privkey.asc` – repository signing private key
* `gds.asc` – repository public key
* `s3cfg-gds` – configuration for `s3cmd`

Building a package
------------------

Run the appropriate script.

Fetching existing files
-----------------------

    ./fetch.sh

In order to build the repository, you need a local copy of all debs in `debs/`.
This script downloads existing debs from S3, without overwriting any files
already held locally.

Build the repository
--------------------

    ./repo.sh

Builds a new signed repository structure in `repo/`.

Upload changes
--------------

    ./sync.sh

Synchronises the repository up to the S3 bucket.
