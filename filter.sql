ATTACH DATABASE "combined.db" AS combined;
ATTACH DATABASE "combined_filtered.db" AS combined_filtered;
CREATE TABLE combined_filtered.iati_data AS
    SELECT * FROM combined.iati_data WHERE fiscal_year >= 2015
