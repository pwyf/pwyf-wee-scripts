attach database "crs_candid_cgap.db" as tmp;

.mode csv
.headers on

select *
    from duplicates
    left join (select distinct `Reporting Organisation`, `Provider Organisation`, `Recipient Country` from combined_tmp) combined_tmp_distincts
    on
        trim(lower(duplicates.`Reporting organisation`))=trim(lower(combined_tmp_distincts.`Reporting Organisation`)) and
        trim(lower(duplicates.`Provider Organisation`))=trim(lower(combined_tmp_distincts.`Provider Organisation`)) and
        trim(lower(duplicates.`Recipient Country`))=trim(lower(combined_tmp_distincts.`Recipient Country`))
    where combined_tmp_distincts.`Reporting Organisation` is NULL;
