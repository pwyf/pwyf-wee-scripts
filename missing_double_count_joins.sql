attach database "crs_candid_cgap.db" as tmp;

.mode csv
.headers on

select *
    from double_counts
    left join (select distinct `Provider Organisation`, `Unique ID` from combined_tmp) combined_tmp_distincts
    on
        trim(lower(double_counts.`Provider Org. `))=trim(lower(combined_tmp_distincts.`Provider Organisation`)) and
        trim(lower(double_counts.`Unique ID`))=trim(lower(combined_tmp_distincts.`Unique ID`))
    where combined_tmp_distincts.`Provider Organisation` is NULL;
