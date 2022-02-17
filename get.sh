#!/bin/bash
set -eux
curl 'https://ocha-dap.github.io/hdx-scraper-iati-viz/transactions.csv' | tail -n +2 > covid-transactions.csv
