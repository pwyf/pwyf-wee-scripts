ATTACH DATABASE "iati_data.db" AS iati_data;
ATTACH DATABASE "iati_data_filtered.db" AS iati_data_filtered;
CREATE TABLE iati_data_filtered.iati_data AS
    SELECT * FROM iati_data.iati_data WHERE fiscal_year >= 2015
