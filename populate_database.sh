#!/bin/bash

DDIR_ABS="$HOME/projects/data/sourced/geonames"
PSQL="psql -X --username=db_maker --dbname=geonames -t --no-align -c"

$PSQL "TRUNCATE TABLE geonames, feature_classes, feature_codes, country_info, admin1_codes, admin2_codes"

$PSQL "\copy feature_classes FROM $DDIR_ABS/feature_classes.txt DELIMITER E'\t' CSV"

sed -E 's/^([A-Z])\./\1\t/' featureCodes_en.txt | sed -E 's/^null/N\t&/' | $PSQL "\copy feature_codes FROM STDIN DELIMITER E'\t' CSV"

sed -E '/^#/d' countryInfo.txt | $PSQL "\copy country_info FROM STDIN DELIMITER E'\t' CSV"

sed -E 's/^([A-Z]{2})\./\1\t/' admin1CodesASCII.txt | $PSQL "\copy admin1_codes FROM STDIN DELIMITER E'\t' CSV"

$PSQL "\copy timezones FROM $DDIR_ABS/timeZones.txt DELIMITER E'\t' CSV HEADER"

awk -F $'\t' '{ print $1 "\t" $2 "\t" $3 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 "\t" $12 "\t" $13 "\t" $14 "\t" $15 "\t" $16 "\t" $17 "\t" $18 "\t" $19 }' cities500_test.txt \
| $PSQL "\copy geonames FROM STDIN DELIMITER E'\t' CSV"

sed -E 's/^([A-Z]{2})\.([A-Z0-9]+)\./\1\t\2\t/' admin2Codes.txt | $PSQL "\copy admin2_codes FROM STDIN DELIMITER E'\t' CSV QUOTE E'\b'"