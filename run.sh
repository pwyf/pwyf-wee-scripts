#!/bin/bash
set -eux
cat combine.sql | sqlite3
cat covid.sql | sqlite3 covid.db
cat filter.sql | sqlite3
./datasette.sh
