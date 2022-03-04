attach database "crs_candid_cgap.db" as tmp;

select *
    from double_counts
    left join (select distinct `Provider Organisation`, `Unique ID` from combined_tmp) combined_tmp_distincts
    on
        trim(double_counts.`Provider Org. `)=trim(combined_tmp_distincts.`Provider Organisation`) and
        trim(double_counts.`Unique ID`)=trim(combined_tmp_distincts.`Unique ID`)
    where combined_tmp_distincts.`Provider Organisation` is NULL;
