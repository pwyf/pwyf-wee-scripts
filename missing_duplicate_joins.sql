attach database "crs_candid_cgap.db" as tmp;

select *
    from duplicates
    left join (select distinct `Reporting Organisation`, `Provider Organisation`, `Recipient Country` from combined_tmp) combined_tmp_distincts
    on
        trim(duplicates.`Reporting organisation`)=trim(combined_tmp_distincts.`Reporting Organisation`) and
        trim(duplicates.`Provider Organisation`)=trim(combined_tmp_distincts.`Provider Organisation`) and
        trim(duplicates.`Recipient Country`)=trim(combined_tmp_distincts.`Recipient Country`)
    where combined_tmp_distincts.`Reporting Organisation` is NULL;
