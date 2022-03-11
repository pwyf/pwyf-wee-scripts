ATTACH DATABASE 'combined.db' AS combined;

create table combined.combined as
    select
        *,
        check_keywords_gender(`Title`) or check_keywords_gender(`Description`) AS `Gender Keyword Match`,
        check_keywords_covid(`Title`) or check_keywords_covid(`Description`) AS `COVID Keyword Match`,
        check_keywords_wfi(`Title`) or check_keywords_wfi(`Description`) AS `WFI Keyword Match`,
        check_keywords_wec(`Title`) or check_keywords_wec(`Description`) AS `WEC Keyword Match`,
        check_keywords_groups_of_women(`Title`) or check_keywords_groups_of_women(`Description`) AS `Groups of women Keyword Match`
    from combined_tmp_filters;
