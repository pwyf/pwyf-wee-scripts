ATTACH DATABASE "ET.db" AS et;
ATTACH DATABASE "PK.db" AS pk;
ATTACH DATABASE "UG.db" AS ug;
ATTACH DATABASE "iati_data.db" AS iati_data;
CREATE TABLE iati_data.iati_data AS
    SELECT * FROM et.iati_data UNION ALL
    SELECT * FROM pk.iati_data UNION ALL
    SELECT * FROM ug.iati_data
