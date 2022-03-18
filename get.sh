#!/bin/bash
set -eux
curl 'https://ocha-dap.github.io/hdx-scraper-iati-viz/transactions.csv' | tail -n +2 > covid-transactions.csv
wget 'https://codelists.codeforiati.org/api/csv/en/Sector.csv'
wget 'https://codelists.codeforiati.org/api/csv/en/SectorCategory.csv'
