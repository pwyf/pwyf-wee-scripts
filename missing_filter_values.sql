.mode csv
.import 'Finance types - Finance type filter.csv' finance_type_filter
.import 'Finance types - Transaction type filter.csv' transaction_type_filter
.import 'Finance types - Flow name filter.csv' flow_name_filter
attach database "combined.db" as combined;

select combined."Data Source", trim(substr("Finance Type", 0, instr("Finance Type" || '-', '-'))) AS "Finance Type Code", "Finance Type", "Finance types" from combined left join finance_type_filter on "Finance Type Code"="Finance types" where "Finance types" is NULL group by combined."Data Source", "Finance Type";
select "-----------------------------";
select combined."Data Source", "Transaction Type", '', "Transaction types" from combined left join transaction_type_filter on "Transaction Type"="Transaction types" where "Transaction types" is NULL group by combined."Data Source", "Transaction Type";
select "-----------------------------";
select combined."Data Source", trim(substr("Flow Type", 0, instr("Flow Type" || '-', '-'))) AS "Flow Type Code", "Flow Type", "Flow name" from combined left join flow_name_filter on "Flow Type Code"="Flow name" where "Flow name" is NULL group by combined."Data Source", "Flow Type Code";
select "-----------------------------";


