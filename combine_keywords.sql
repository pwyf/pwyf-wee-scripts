ATTACH DATABASE 'combined.db' AS combined;

create table combined.combined as
    select
        *,
        check_keywords_gender(`Title`) or check_keywords_gender(`Description`) AS `Gender Keyword Match`
    from combined_tmp_filters;
