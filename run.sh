#!/bin/bash
set -eux
cat combine.sql | sqlite3
cat covid.sql | sqlite3 combined.db
cat remove_old_tables.sql | sqlite3 combined.db
./datasette.sh
