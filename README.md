# PWYF WEE Scripts

Scripts for creating a database of development data, for Women's Economic Empowerment (WEE) research, peformed by Publish What You Fund (PWYF). The countries covered are Ethopia, Pakistan and Uganda, but it should be easy to adapt to other countries.

These rely on our [modified copy of iati-flattener](https://github.com/pwyf/iati-flattener/).

## Requirements

* bash (probably on Linux, or Windows Subsystem for Linux)
* sqlite3 commandline
* python3 with venv

e.g. on Ubuntu: `sudo apt install sqlite3 python3-venv`

## Usage

```bash
# Clone the code used to generate https://countrydata.iatistandard.org/#access-data-files
git clone --single-branch https://github.com/iati-data-access/data-en.git
# Clone our fork of iati-flattener
git clone https://github.com/pwyf/iati-flattener.git
cd data-en
# Set up a virtual env
python3 -m venv .ve
source .ve/bin/activate
pip install -r requirements.txt
# Install our copy of iati-flattener, instead of the one from requirements.txt
pip install -e ../iati-flattener
# Generate sqlite databases for each country (which correspond to the xlsx files in the original code).
mkdir -p output/sqlite/en
python generate.py
# Leave the virtual env
deactivate
cd ..
# Clone this repository
git clone https://github.com/pwyf/pwyf-wee-scripts.git
cd pwyf-wee-scripts
# Download the covid flags file
wget https://ocha-dap.github.io/hdx-scraper-iati-viz/transactions.csv -O covid-transactions.csv
# Copy the IATI country sqlite files we generated earlier into the iati_input folder
# There is a private copy of the exact files used in the research at https://drive.google.com/drive/folders/1vfGceSG-iuCrZAxzGxhqTb6QUqMW8w7D
mkdir iati_input
cp ../data-en/output/sqlite/en/{ET,PK,UG}.db iati_input
# Download crs_candid_cgap_public.zip from https://drive.google.com/u/0/uc?id=1rpByZM66oATFmaYDNDzgGchde4X-MtVB&export=download 
unzip crs_candid_cgap_public.zip
# (Alternatively, if you have access to crs_candid_cgap.zip from https://drive.google.com/file/d/1gRfXsT-aCULlc6dRPnZG_w25H7zNnDu-/view?usp=sharing, use that)
# Run the sql scripts in this repository
./run.sh
```

Then look at combined.db, e.g. with [sqlitebrowser](https://sqlitebrowser.org/) or the sqlite3 commandline tool:

```
sqlite3 combined.db
.tables
.mode line
SELECT * FROM combined LIMIT 1;
```

## Summary of each sql script

These are run in order:

### combine-iati.sql

Combines the 3 country databases into a single `iati_data.db`.

### covid.sql

Takes the covid flags from `covid-transactions.csv` and matches them by IATI Identifier with rows in `iati_data.db`.

### filter-iati.sql

Creates `iati_data_filtered.db` which is `iati_data.db` filtered to only fiscal years 2015 or later.

### combine.sql

Combines the IATI, CRS, CANDID and CGAP data to create the `combined_tmp` table in `crs_candid_cgap.db`.

Adds columns for Loans/Grants to keep based on various filters, duplicates and double counts, to create the `combined_tmp_filters` table in `crs_candid_cgap.db`.

### combined_keywords.py / combined_keywords.sql

This is the final step. We run a python script to define some custom functions, to then run `combined_keywords.sql` with. This checks for various sets of keywords, creating the final `combined.db`.
