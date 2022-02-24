ATTACH DATABASE "iati_data_filtered.db" AS iati_data_filtered;
ATTACH DATABASE "combined.db" AS combined;
.mode csv
.import "./CRS 2015-2020/Uganda_CRS.csv" crs
.import "./CRS 2015-2020/CRS_Pakistan.csv" crs
.import "./CRS 2015-2020/CRS_Ethiopia.csv" crs
.import "./Zip-CGAP+CANDID/PublishWhatYouFund_202111- phase 2 countries CANDID_Uganda.csv" candid
.import "./Zip-CGAP+CANDID/PublishWhatYouFund_202111- phase 2 countries CANDID_Pakistan.csv" candid
.import "./Zip-CGAP+CANDID/PublishWhatYouFund_202111- phase 2 countries CANDID_Ethiopia.csv" candid
.import "./Zip-CGAP+CANDID/CGAP-Phase2-de-duplicated.csv" cgap

CREATE TABLE combined_tmp  AS SELECT
    'IATI' AS "Data Source",

    "reporting_org#en" AS "Reporting Organisation",
    "provider_org#en" AS "Provider Organisation",
    "title#en" AS "Title",
    "reporting_org_type" AS "Reporting Organisation Type",
    "aid_type" AS "Aid Type",
    "finance_type" AS "Finance Type",
    "receiver_org#en" AS "Receiver Organisation",
    "receiver_org_type" AS "Receiver Organisation Type",
    "transaction_type" AS "Transaction Type",
    "country_code" AS "Recipient Country",
    "sector_category" AS "Sector code (3-digit)",
    "sector_category_name" AS "Sector name (3-digit)",
    "sector_code" AS "Purpose code (5-digit)",
    "sector_code_name" AS "Purpose name (5-digit)",
    "fiscal_year" AS "Year",
    "description#en" AS "Description",
    NULL AS "USD_Disbursement",
    NULL AS "RegionName",
    NULL AS "USD_Commitment",
    "iati_identifier" AS "Unique ID",
    "gender_marker_significance" AS "Gender Marker Significance",
    "value_usd" AS "Value (USD)",
    "flow_type" AS "Flow Type",

    "provider_org_type" AS "Provider Organisation Type",
    "multi_country" AS "Multi Country",
    "humanitarian" AS "Humanitarian",
    "fiscal_quarter" AS "Calendar Quarter",
    "fiscal_year_quarter" AS "Calendar Year and Quarter",
    "url" AS "URL",
    "activity_start_date" AS "Activity Start Date",
    "value_eur" AS "Value (EUR)",
    "value_local" AS "Value (Local currrency)",
    "covid_flag" AS "Covid Marker",
    "covid_flag_strict" AS "Covid Marker Strict"
FROM iati_data_filtered.iati_data
UNION ALL
SELECT
    'CGAP' AS "Data Source",

    "Funder Name " AS "Reporting Organisation",
    "Managing Department" AS "Provider Organisation",
    "Name of the Recipient / Project" AS "Title",
    "Funder Subtype" AS "Reporting Organisation Type",
    NULL AS "Aid Type",
    "Finance type" AS "Finance Type",
    -- TODO ALso ultimate recipient for next 2
    "Primary recipient" AS "Receiver Organisation",
    "Ultimate Recipient Type" AS "Receiver Organisation Type",
    NULL AS "Transaction Type",
    "Country" AS "Recipient Country",
    "Final Theme" AS "Sector code (3-digit)",
    NULL AS "Sector name (3-digit)",
    NULL AS "Purpose code (5-digit)",
    NULL AS "Purpose name (5-digit)",
    "Survey Years" AS "Year",
    "Comment" AS "Description",
    " Commitments already disbursed" AS "USD_Disbursement",
    -- WB Region ?
    NULL AS "RegionName",
    " Commitments USD" AS "USD_Commitment",
    "Unique ID" AS "Unique ID",
    "Women" AS "Gender Marker Significance",
    NULL AS "Value (USD)",
    NULL AS "Flow Type",

    NULL AS "Provider Organisation Type",
    NULL AS "Multi Country",
    NULL AS "Humanitarian",
    NULL AS "Calendar Quarter",
    NULL AS "Calendar Year and Quarter",
    NULL AS "URL",
    NULL AS "Activity Start Date",
    NULL AS "Value (EUR)",
    NULL AS "Value (Local currrency)",
    NULL AS "Covid Marker",
    NULL AS "Covid Marker Strict"
FROM cgap
UNION ALL
SELECT
    'CRS' AS "Data Source",

    "DonorName " AS "Reporting Organisation",
    "AgencyName" AS "Provider Organisation",
    "ProjectTitle" AS "Title",
    NULL AS "Reporting Organisation Type",
    "Aid_t" AS "Aid Type",
    "Finance_t" AS "Finance Type",
    "ChannelReportedName" AS "Receiver Organisation",
    "ChannelName" AS "Receiver Organisation Type",
    NULL AS "Transaction Type",
    "RecipientName" AS "Recipient Country",
    "SectorCode" AS "Sector code (3-digit)",
    "SectorName" AS "Sector name (3-digit)",
    "PurposeCode" AS "Purpose code (5-digit)",
    "PurposeName" AS "Purpose name (5-digit)",
    "Year" AS "Year",
    "LongDescription" AS "Description",
    "USD_Commitment*1M" AS "USD_Disbursement",
    "RegionName" AS "RegionName",
    "USD_Commitment*1M" AS "USD_Commitment",
    "CrsID" AS "Unique ID",
    "Gender" AS "Gender Marker Significance",
    NULL AS "Value (USD)",
    "FlowCode" || ' - ' || "FlowName" AS "Flow Type",

    NULL AS "Provider Organisation Type",
    NULL AS "Multi Country",
    NULL AS "Humanitarian",
    NULL AS "Calendar Quarter",
    NULL AS "Calendar Year and Quarter",
    NULL AS "URL",
    NULL AS "Activity Start Date",
    NULL AS "Value (EUR)",
    NULL AS "Value (Local currrency)",
    NULL AS "Covid Marker",
    NULL AS "Covid Marker Strict"
FROM crs
UNION ALL
SELECT
    'CANDID' AS "Data Source",

    "Reporting Organisation",
    "Provider Organisation",
    "Title",
    "Reporting Organisation Type",
    "Aid Type",
    "Finance Type",
    "Receiver Organisation",
    "Receiver Organisation Type",
    "Transaction Type",
    "Recipient Country",
    NULL AS "Sector code (3-digit)",
    "Sector name (3-digit)",
    "Purpose code (5-digit)",
    "Purpose name (5-digit)",
    "Year",
    "Description",
    NULL AS "USD_Disbursement",
    NULL AS "RegionName",
    NULL AS "USD_Commitment",
    "Unique ID",
    "Gender marker" AS "Gender Marker Significance",
    "Value (USD)",
    NULL AS "Flow Type",

    NULL AS "Provider Organisation Type",
    NULL AS "Multi Country",
    NULL AS "Humanitarian",
    NULL AS "Calendar Quarter",
    NULL AS "Calendar Year and Quarter",
    NULL AS "URL",
    NULL AS "Activity Start Date",
    NULL AS "Value (EUR)",
    NULL AS "Value (Local currrency)",
    NULL AS "Covid Marker",
    NULL AS "Covid Marker Strict"
FROM candid
;



.import 'Finance types - Finance type filter.csv' finance_type_filter
.import 'Finance types - Transaction type filter.csv' transaction_type_filter
.import 'Finance types - Flow name filter.csv' flow_name_filter

create table combined.combined as
select
    combined_tmp.*,
    trim(substr("Finance Type", 0, instr("Finance Type" || '-', '-'))) AS "Finance Type Code",
    trim(substr("Flow Type", 0, instr("Flow Type" || '-', '-'))) AS "Flow Type Code",
    -- For CANDID all activities are grants so keep all blanks.
    -- https://publishwhatyoufund.sharepoint.com/:x:/g/ETwXwO_JNGdCkzgQ-LnaYdEBWlJPdkYjNeQY1hEdqQae1w?rtime=xkq1Q4f32Ug
    case combined_tmp."Data Source" when "CANDID" then "N" else finance_type_filter."Loan Y/N" end AS "Finance Type Filter Loan Y/N",
    case combined_tmp."Data Source" when "CANDID" then "Y" else finance_type_filter."Grant Y/N" end AS "Finance Type Filter Grant Y/N",
    transaction_type_filter."Loan Y/N" AS "Transaction Type Filter Loan Y/N",
    transaction_type_filter."Grant Y/N" AS "Transaction Type Filter Grant Y/N",
    flow_name_filter."Loan Y/N" AS "Flow Type Filter Loan Y/N",
    flow_name_filter."Grant Y/N" AS "Flow Type Filter Grant Y/N"
from
    combined_tmp
    left join finance_type_filter on "Finance Type Code"="Finance types"
    left join transaction_type_filter on "Transaction Type"="Transaction types"
    left join flow_name_filter on "Flow Type Code"="Flow name";
;
