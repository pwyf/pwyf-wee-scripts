# Based on https://unix.stackexchange.com/a/635201
# How to use:
# awk -f csv_to_column_txts.awk Keysearch\ terms_translated_Unpaid_care_ODS.csv
BEGIN { FS="," }
NR==1 {
    for (i=1; i<=NF; i++) {
        out[i] = "terms/unpaid_care/" $i ".txt"
    }
    next
}
{
    for (i=1; i<=NF; i++) {
        print $i > out[i]
    }
}

