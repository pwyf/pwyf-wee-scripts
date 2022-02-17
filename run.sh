#!/bin/bash
set -eux
cp ET.db iati_data.db
cat covid.sql | sqlite3 iati_data.db
cat remove_old_tables.sql | sqlite3 iati_data.db
./datasette.sh
