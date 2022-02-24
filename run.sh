#!/bin/bash
set -eux
rm *.db
cp ../data-en/output/sqlite/en/*.db .
cat combine-iati.sql | sqlite3
cat covid.sql | sqlite3 covid.db
cat filter.sql | sqlite3
cat combine.sql | sqlite3 crs_candid_cgap.db
./datasette.sh
