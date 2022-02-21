ATTACH DATABASE "ET.db" AS et;
ATTACH DATABASE "PK.db" AS pk;
ATTACH DATABASE "UG.db" AS ug;
ATTACH DATABASE "combined.db" AS combined;
CREATE TABLE combined.iati_data AS
    SELECT * FROM et.iati_data UNION
    SELECT * FROM pk.iati_data UNION
    SELECT * FROM ug.iati_data
