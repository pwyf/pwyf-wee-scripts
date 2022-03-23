ATTACH DATABASE 'iati_data_filtered.db' AS iati_data_filtered;
.mode csv
.import './CRS 2015-2020/Uganda_CRS.csv' crs_uganda
.import './CRS 2015-2020/CRS_Pakistan.csv' crs_pakistan
.import './CRS 2015-2020/CRS_Ethiopia.csv' crs_ethiopia
.import './Zip-CGAP+CANDID/PublishWhatYouFund_202111- phase 2 countries CANDID_Uganda.csv' candid_uganda
.import './Zip-CGAP+CANDID/PublishWhatYouFund_202111- phase 2 countries CANDID_Pakistan.csv' candid_pakistan
.import './Zip-CGAP+CANDID/PublishWhatYouFund_202111- phase 2 countries CANDID_Ethiopia.csv' candid_ethiopia
.import './Zip-CGAP+CANDID/CGAP-Phase2-de-duplicated.csv' cgap

.import './Sector.csv' iati_sector
.import './SectorCategory.csv' iati_sector_category
.import 'Phase 2 sectors+purpose codes tidied-V2_CANDID.csv' sector_names_candid
.import 'Phase 2 sectors+purpose codes tidied-V2_CGAP.csv' sector_names_cgap

-- Note: This relies on the columns being the same across all 3
CREATE TABLE crs AS
    SELECT * FROM crs_uganda UNION ALL
    SELECT * FROM crs_pakistan UNION ALL
    SELECT * FROM crs_ethiopia
;
CREATE TABLE candid AS
    SELECT * FROM candid_uganda UNION ALL
    SELECT * FROM candid_pakistan UNION ALL
    SELECT * FROM candid_ethiopia
;

CREATE TABLE combined_tmp  AS SELECT
    'IATI' AS [Data Source],

    `reporting_org#en` AS `Reporting Organisation`,
    `provider_org#en` AS `Provider Organisation`,
    `title#en` AS `Title`,
    `reporting_org_type` AS `Reporting Organisation Type`,
    `aid_type` AS `Aid Type`,
    `finance_type` AS `Finance Type`,
    `receiver_org#en` AS `Receiver Organisation`,
    `receiver_org_type` AS `Receiver Organisation Type`,
    `transaction_type` AS `Transaction Type`,
    trim(substr(`country_code`, instr(`country_code` || '-', '-') + 2)) AS `Recipient Country`,
    `sector_category` AS `Sector code (3-digit)`,
    COALESCE(iati_sector_category.name, `sector_category_name`) AS `Sector name (3-digit)`,
    `sector_code` AS `Purpose code (5-digit)`,
    COALESCE(iati_sector.name, `sector_code_name`) AS `Purpose name (5-digit)`,
    `fiscal_year` AS `Year`,
    `description#en` AS `Description`,
    `target_groups#en` AS `Target Groups`,
    NULL AS `USD_Disbursement`,
    NULL AS `RegionName`,
    NULL AS `USD_Commitment`,
    `iati_identifier` AS `Unique ID`,
    `gender_marker_significance` AS `Gender Marker`,
    CAST(`gender_marker_significance` AS INTEGER) >= 1 AS `Gender Marker v2`,
    `value_usd` AS `Value (USD)`,
    `flow_type` AS `Flow Type`,

    `provider_org_type` AS `Provider Organisation Type`,
    `multi_country` AS `Multi Country`,
    `humanitarian` AS `Humanitarian`,
    `fiscal_quarter` AS `Calendar Quarter`,
    `fiscal_year_quarter` AS `Calendar Year and Quarter`,
    `url` AS `URL`,
    `activity_start_date` AS `Activity Start Date`,
    `value_eur` AS `Value (EUR)`,
    `value_local` AS `Value (Local currrency)`,
    `covid_flag` AS `Covid Marker`,
    `covid_flag_strict` AS `Covid Marker Strict`
FROM iati_data_filtered.iati_data
LEFT JOIN iati_sector ON iati_sector.code = sector_code
LEFT JOIN iati_sector_category ON iati_sector_category.code = sector_category
UNION ALL
SELECT
    'CGAP' AS `Data Source`,

    `Funder Name ` AS `Reporting Organisation`,
    `Managing Department` AS `Provider Organisation`,
    `Name of the Recipient / Project` AS `Title`,
    `Funder Subtype` AS `Reporting Organisation Type`,
    NULL AS `Aid Type`,
    `Finance type` AS `Finance Type`,
    -- TODO ALso ultimate recipient for next 2
    `Primary recipient` AS `Receiver Organisation`,
    `Ultimate Recipient Type` AS `Receiver Organisation Type`,
    '' AS `Transaction Type`,
    `Country` AS `Recipient Country`,
    -- TODO is this 3 or 5, is this Candid grant_strategy_tran
    `Final Theme` AS `Sector code (3-digit)`,
    `Tidied 3-digit sector name` AS `Sector name (3-digit)`,
    NULL AS `Purpose code (5-digit)`,
    `Tidied 5-digit purpose name` AS `Purpose name (5-digit)`,
    `Survey Year` AS `Year`,
    `Comment` AS `Description`,
    NULL AS `Target Groups`,
    ` Commitments already disbursed` AS `USD_Disbursement`,
    -- WB Region ?
    NULL AS `RegionName`,
    ` Commitments USD` AS `USD_Commitment`,
    `Unique ID` AS `Unique ID`,
    `Women` AS `Gender Marker`,
    CAST (`Women` AS INTEGER) AS `Gender Marker v2`,
    NULL AS `Value (USD)`,
    '' AS `Flow Type`,

    NULL AS `Provider Organisation Type`,
    NULL AS `Multi Country`,
    NULL AS `Humanitarian`,
    NULL AS `Calendar Quarter`,
    NULL AS `Calendar Year and Quarter`,
    NULL AS `URL`,
    NULL AS `Activity Start Date`,
    NULL AS `Value (EUR)`,
    NULL AS `Value (Local currrency)`,
    NULL AS `Covid Marker`,
    NULL AS `Covid Marker Strict`
FROM cgap
LEFT JOIN sector_names_cgap ON `Final Theme` = `CGAP final theme`
UNION ALL
SELECT
    'CRS' AS `Data Source`,

    `DonorName` AS `Reporting Organisation`,
    `AgencyName` AS `Provider Organisation`,
    `ProjectTitle` AS `Title`,
    NULL AS `Reporting Organisation Type`,
    `Aid_t` AS `Aid Type`,
    `Finance_t` AS `Finance Type`,
    `ChannelReportedName` AS `Receiver Organisation`,
    `ChannelName` AS `Receiver Organisation Type`,
    '' AS `Transaction Type`,
    `RecipientName` AS `Recipient Country`,
    `SectorCode` AS `Sector code (3-digit)`,
    COALESCE(iati_sector_category.name, `SectorName`) AS `Sector name (3-digit)`,
    `PurposeCode` AS `Purpose code (5-digit)`,
    COALESCE(iati_sector.name, `PurposeName`) AS `Purpose name (5-digit)`,
    `Year` AS `Year`,
    ShortDescription || CASE WHEN substr(ShortDescription, -1, 1) = '.' THEN '. ' ELSE ' ' END || LongDescription AS Description,
    NULL AS `Target Groups`,
    `USD_Commitment*1M` AS `USD_Disbursement`,
    `RegionName` AS `RegionName`,
    `USD_Commitment*1M` AS `USD_Commitment`,
    `CrsID` AS `Unique ID`,
    `Gender` AS `Gender Marker`,
    CAST(`Gender` AS INTEGER) >= 1 AS `Gender Marker v2`,
    NULL AS `Value (USD)`,
    `FlowCode` || ' - ' || `FlowName` AS `Flow Type`,

    NULL AS `Provider Organisation Type`,
    NULL AS `Multi Country`,
    NULL AS `Humanitarian`,
    NULL AS `Calendar Quarter`,
    NULL AS `Calendar Year and Quarter`,
    NULL AS `URL`,
    NULL AS `Activity Start Date`,
    NULL AS `Value (EUR)`,
    NULL AS `Value (Local currrency)`,
    NULL AS `Covid Marker`,
    NULL AS `Covid Marker Strict`
FROM crs
LEFT JOIN iati_sector ON iati_sector.code = `PurposeCode`
LEFT JOIN iati_sector_category ON iati_sector_category.code = `SectorCode`
UNION ALL
SELECT
    'CANDID' AS `Data Source`,

    `Reporting Organisation`,
    NULL AS `Provider Organisation`,
    `Title`,
    `Reporting Organisation Type`,
    `Aid Type`,
    `Finance Type`,
    `Receiver Organisation`,
    `Receiver Organisation Type`,
    `Transaction Type`,
    `Recipient Country`,
    NULL AS `Sector code (3-digit)`,
    COALESCE(`Tidied 3-digit sector name`, `Sector name (3-digit)`) AS `Sector name (3-digit)`,
    `Purpose code (5-digit)`,
    COALESCE(`Tidied 5-digit purpose name`, `Purpose name (5-digit)`) AS `Purpose name (5-digit)`,
    `Year`,
    `Description`,
    NULL AS `Target Groups`,
    NULL AS `USD_Disbursement`,
    NULL AS `RegionName`,
    NULL AS `USD_Commitment`,
    `Unique ID`,
    `Gender marker` AS `Gender Marker`,
    (`Gender marker` LIKE '%women%' OR `Gender marker` LIKE '%girls%') AS `Gender Marker v2`,
    `Value (USD)`,
    '' AS `Flow Type`,

    NULL AS `Provider Organisation Type`,
    NULL AS `Multi Country`,
    NULL AS `Humanitarian`,
    NULL AS `Calendar Quarter`,
    NULL AS `Calendar Year and Quarter`,
    NULL AS `URL`,
    NULL AS `Activity Start Date`,
    NULL AS `Value (EUR)`,
    NULL AS `Value (Local currrency)`,
    NULL AS `Covid Marker`,
    NULL AS `Covid Marker Strict`
FROM candid
LEFT JOIN sector_names_candid ON `Purpose name (5-digit)` = `Candid grant_strategy_tran`
;


.import 'Finance types - Finance type filter.csv' finance_type_filter
.import 'Finance types - Transaction type filter.csv' transaction_type_filter
.import 'Finance types - Flow name filter.csv' flow_name_filter
.import 'duplicate quality decisions_phase2_v2_ET.csv' duplicates_et
.import 'duplicate quality decisions_phase2_v2_PK.csv' duplicates_pk
.import 'duplicate quality decisions_phase2_v2_UG.csv' duplicates_ug
.import 'Double counts to remove_updated_ET.csv' double_counts_et
.import 'Double counts to remove_updated_PK.csv' double_counts_pk
.import 'Double counts to remove_updated_UG.csv' double_counts_ug
.import 'double_counts_updated.csv' double_counts_updated

create table duplicates as
    select *, 'Ethiopia' AS `Recipient Country` from duplicates_et union all
    select *, 'Pakistan' AS `Recipient Country` from duplicates_pk union all
    select *, 'Uganda' AS `Recipient Country` from duplicates_ug;

create table double_counts as
    select *, 'Ethiopia' AS `Recipient Country` from double_counts_et union all
    select *, 'Pakistan' AS `Recipient Country` from double_counts_pk union all
    select *, 'Uganda' AS `Recipient Country` from double_counts_ug union all
    select * from double_counts_updated
;

create table combined_tmp_filters as
select
    combined_tmp.*,
    trim(substr(`Finance Type`, 0, instr(`Finance Type` || '-', '-'))) AS `Finance Type Code`,
    trim(substr(`Flow Type`, 0, instr(`Flow Type` || '-', '-'))) AS `Flow Type Code`,
    -- For CANDID all activities are grants so keep all blanks.
    -- https://publishwhatyoufund.sharepoint.com/:x:/g/ETwXwO_JNGdCkzgQ-LnaYdEBWlJPdkYjNeQY1hEdqQae1w?rtime=xkq1Q4f32Ug
    case combined_tmp.`Data Source` when 'CANDID' then 'N' else COALESCE(finance_type_filter.`Loan Y/N`, 'N') end AS `Finance Type Filter Loan Y/N`,
    case combined_tmp.`Data Source` when 'CANDID' then 'Y' else COALESCE(finance_type_filter.`Grant Y/N`, 'N') end AS `Finance Type Filter Grant Y/N`,
    transaction_type_filter.'Loan Y/N' AS `Transaction Type Filter Loan Y/N`,
    transaction_type_filter.'Grant Y/N' AS `Transaction Type Filter Grant Y/N`,
    COALESCE(flow_name_filter.`Loan Y/N`, 'B') AS `Flow Type Filter Loan Y/N`,
    COALESCE(flow_name_filter.`Grant Y/N`, 'B') AS `Flow Type Filter Grant Y/N`,
    (finance_type_filter.`Loan Y/N`='Y' AND transaction_type_filter.`Loan Y/N`='Y' AND flow_name_filter.`Loan Y/N`='Y')
        OR (finance_type_filter.`Loan Y/N`='B' AND transaction_type_filter.`Loan Y/N`='Y' AND flow_name_filter.`Loan Y/N`='Y')
        OR (finance_type_filter.`Loan Y/N`='Y' AND transaction_type_filter.`Loan Y/N`='Y' AND flow_name_filter.`Loan Y/N`='B')
        AS `Loans to keep`,
    (finance_type_filter.`Grant Y/N`='Y' AND transaction_type_filter.`Grant Y/N`='Y' AND flow_name_filter.`Grant Y/N`='Y')
        OR (finance_type_filter.`Grant Y/N`='B' AND transaction_type_filter.`Grant Y/N`='Y' AND flow_name_filter.`Grant Y/N`='Y')
        OR (finance_type_filter.`Grant Y/N`='Y' AND transaction_type_filter.`Grant Y/N`='Y' AND flow_name_filter.`Grant Y/N`='B')
        AS `Grants to keep`,
    duplicates."Loans" AS "Duplicate Loans Keep",
    duplicates."Grants" AS "Duplicate Grants Keep",
    double_counts."Unique ID" is NULL AS "Double Counts Keep"
from
    combined_tmp
    left join finance_type_filter on `Finance Type Code`=`Finance types`
    left join transaction_type_filter on `Transaction Type`=`Transaction types`
    left join flow_name_filter on `Flow Type Code`=`Flow name`
    left join duplicates
    on
        trim(lower(duplicates.`Reporting organisation`))=trim(lower(combined_tmp.`Reporting Organisation`)) and
        trim(lower(duplicates.`Provider Organisation`))=trim(lower(combined_tmp.`Provider Organisation`)) and
        trim(lower(duplicates.`Recipient Country`))=trim(lower(combined_tmp.`Recipient Country`))
    left join double_counts
    on
        trim(lower(double_counts.`Provider Org. `))=trim(lower(combined_tmp.`Provider Organisation`)) and
        trim(lower(double_counts.`Unique ID`))=trim(lower(combined_tmp.`Unique ID`))
;

