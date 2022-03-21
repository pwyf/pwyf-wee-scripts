ATTACH DATABASE 'combined.db' AS combined;

create table combined.combined as
    select
        *,
        `Gender Keyword Match` OR `Gender Marker v2` AS `Gender Marker or Keyword`,
        `COVID Keyword Match` OR `Covid Marker` AS `COVID Marker or Keyword`
    from (select
        *,

        check_keywords_gender(`Title`) or check_keywords_gender(`Description`) AS `Gender Keyword Match`,
        check_keywords_covid(`Title`) or check_keywords_covid(`Description`) AS `COVID Keyword Match`,
        check_keywords_wfi(`Title`) or check_keywords_wfi(`Description`) AS `WFI Keyword Match`,
        check_keywords_wec(`Title`) or check_keywords_wec(`Description`) AS `WEC Keyword Match`,
        check_keywords_groups_of_women(`Title`) or check_keywords_groups_of_women(`Description`) AS `Groups of women Keyword Match`,

        check_keywords_unpaid_care_Breastfeeding_at_work(`Title`) or check_keywords_unpaid_care_Breastfeeding_at_work(`Description`) AS `Unpaid care: Breastfeeding at work Keyword Match`,
        check_keywords_unpaid_care_Caresensitive_Public_Works(`Title`) or check_keywords_unpaid_care_Caresensitive_Public_Works(`Description`) AS `Unpaid care: Care-sensitive Public Works Keyword Match`,
        check_keywords_unpaid_care_Care_Services_for_Older_People(`Title`) or check_keywords_unpaid_care_Care_Services_for_Older_People(`Description`) AS `Unpaid care: Care Services for Older People Keyword Match`,
        check_keywords_unpaid_care_Care_Services_for_those_with_Additional_Needs(`Title`) or check_keywords_unpaid_care_Care_Services_for_those_with_Additional_Needs(`Description`) AS `Unpaid care: Care Services for those with Additional Needs Keyword Match`,
        check_keywords_unpaid_care_Cash_Transfers_Related_to_Care(`Title`) or check_keywords_unpaid_care_Cash_Transfers_Related_to_Care(`Description`) AS `Unpaid care: Cash Transfers Related to Care Keyword Match`,
        check_keywords_unpaid_care_Early_Childhood_Education_ECE(`Title`) or check_keywords_unpaid_care_Early_Childhood_Education_ECE(`Description`) AS `Unpaid care: Early Childhood Education (ECE) Keyword Match`,
        check_keywords_unpaid_care_Equal_Paid_Parental_Leave(`Title`) or check_keywords_unpaid_care_Equal_Paid_Parental_Leave(`Description`) AS `Unpaid care: Equal Paid Parental Leave Keyword Match`,
        check_keywords_unpaid_care_Flexible_Working(`Title`) or check_keywords_unpaid_care_Flexible_Working(`Description`) AS `Unpaid care: Flexible Working Keyword Match`,
        check_keywords_unpaid_care_General_Unspecified(`Title`) or check_keywords_unpaid_care_General_Unspecified(`Description`) AS `Unpaid care: General Unspecified Keyword Match`,
        check_keywords_unpaid_care_Household_Electricity(`Title`) or check_keywords_unpaid_care_Household_Electricity(`Description`) AS `Unpaid care: Household Electricity Keyword Match`,
        check_keywords_unpaid_care_Measurement_frameworks(`Title`) or check_keywords_unpaid_care_Measurement_frameworks(`Description`) AS `Unpaid care: Measurement frameworks Keyword Match`,
        check_keywords_unpaid_care_Onsite_Childcare(`Title`) or check_keywords_unpaid_care_Onsite_Childcare(`Description`) AS `Unpaid care: Onsite Childcare Keyword Match`,
        check_keywords_unpaid_care_Paid_Sick_Leave(`Title`) or check_keywords_unpaid_care_Paid_Sick_Leave(`Description`) AS `Unpaid care: Paid Sick Leave Keyword Match`,
        check_keywords_unpaid_care_Piped_Water_Communal_Water(`Title`) or check_keywords_unpaid_care_Piped_Water_Communal_Water(`Description`) AS `Unpaid care: Piped Water Communal Water Keyword Match`,
        check_keywords_unpaid_care_Public_healthcare_services(`Title`) or check_keywords_unpaid_care_Public_healthcare_services(`Description`) AS `Unpaid care: Public healthcare services Keyword Match`,
        check_keywords_unpaid_care_Public_Pensions(`Title`) or check_keywords_unpaid_care_Public_Pensions(`Description`) AS `Unpaid care: Public Pensions Keyword Match`,
        check_keywords_unpaid_care_Public_Transport_Ridesharing(`Title`) or check_keywords_unpaid_care_Public_Transport_Ridesharing(`Description`) AS `Unpaid care: Public Transport Ridesharing Keyword Match`,
        check_keywords_unpaid_care_Sanitation_Services(`Title`) or check_keywords_unpaid_care_Sanitation_Services(`Description`) AS `Unpaid care: Sanitation Services Keyword Match`,
        check_keywords_unpaid_care_School_Meals_or_Vouchers(`Title`) or check_keywords_unpaid_care_School_Meals_or_Vouchers(`Description`) AS `Unpaid care: School Meals or Vouchers Keyword Match`,
        check_keywords_unpaid_care_Standards_prohibiting_gender_stereotypes_in_advertising_and_media_representations(`Title`) or check_keywords_unpaid_care_Standards_prohibiting_gender_stereotypes_in_advertising_and_media_representations(`Description`) AS `Unpaid care: Standards prohibiting gender stereotypes in advertising and media representations Keyword Match`,
        check_keywords_unpaid_care_Time_and_energysaving_equipment_and_technologies_TESET(`Title`) or check_keywords_unpaid_care_Time_and_energysaving_equipment_and_technologies_TESET(`Description`) AS `Unpaid care: Time- and energy-saving equipment and technologies (TESET) Keyword Match`,
        check_keywords_unpaid_care_Timeuse_data_collection(`Title`) or check_keywords_unpaid_care_Timeuse_data_collection(`Description`) AS `Unpaid care: Time-use data collection Keyword Match`

    from combined_tmp_filters) combined_tmp_filters_keywords;
