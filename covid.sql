ATTACH DATABASE "combined.db" AS combined;
.mode csv
.import covid-transactions.csv covid_flag_source
CREATE TABLE covid_flag_mapping AS SELECT "#activity+code" AS iati_identifier, 1 AS covid_flag, MAX("#indicator+bool+strict") AS covid_flag_strict FROM covid_flag_source GROUP BY "#activity+code";
CREATE TABLE iati_data_with_covid_flag AS SELECT iati_data.*, COALESCE(covid_flag_mapping.covid_flag, 0) AS covid_flag, COALESCE(covid_flag_mapping.covid_flag_strict, 0) AS covid_flag_strict FROM iati_data LEFT JOIN covid_flag_mapping ON iati_data.iati_identifier=covid_flag_mapping.iati_identifier;
DROP TABLE combined.iati_data;
CREATE TABLE combined.iati_data AS SELECT * FROM iati_data_with_covid_flag;
