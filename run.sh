#!/bin/bash
set -eux
rm *.db || true
cat combine-iati.sql | sqlite3
cat covid.sql | sqlite3 covid.db
cat filter-iati.sql | sqlite3
cat combine.sql | sqlite3 crs_candid_cgap.db
python3 combine_keywords.py
