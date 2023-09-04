#!/bin/bash

PSQL="psql -X --username=geonames --dbname=geonames -t --no-align -c"

if [[ $1 == '--full-repop' ]]
then
    $PSQL "TRUNCATE TABLE geonames, feature_classes, feature_codes, country_info, admin1_codes, admin2_codes, timezones, alt_names, iso_language_codes, hierarchy, user_tags"
    
    $PSQL "ALTER TABLE geonames ADD COLUMN IF NOT EXISTS alt_name varchar(20000)"
    $PSQL "\copy geonames (geoname_id,geoname,asciiname,alt_name,latitude,longitude,feature_class,feature_code,country_code,alt_country_code,admin1_code,admin2_code,admin3_code,admin4_code,population,elevation,dem,timezone,gn_modification_date) FROM allCountries.txt DELIMITER E'\t' CSV QUOTE E'\b'"
    $PSQL "ALTER TABLE geonames DROP COLUMN alt_name"
    
    $PSQL "\copy alt_names FROM alternateNamesV2.txt DELIMITER E'\t' CSV"
else
    $PSQL "TRUNCATE TABLE feature_classes, feature_codes, country_info, admin1_codes, admin2_codes, timezones, iso_language_codes, hierarchy, user_tags"
fi

$PSQL "\copy feature_classes FROM feature_classes.txt DELIMITER E'\t' CSV"

sed -E 's/^([A-Z])\./\1\t/' featureCodes_en.txt | sed -E 's/^null/N\t&/' | $PSQL "\copy feature_codes FROM STDIN DELIMITER E'\t' CSV"

sed -E '/^#/d' countryInfo.txt | $PSQL "\copy country_info FROM STDIN DELIMITER E'\t' CSV"

sed -E 's/^([A-Z]{2})\./\1\t/' admin1CodesASCII.txt | $PSQL "\copy admin1_codes FROM STDIN DELIMITER E'\t' CSV"

$PSQL "\copy timezones FROM timeZones.txt DELIMITER E'\t' CSV HEADER"

sed -E 's/^([A-Z]{2})\.([A-Z0-9]+)\./\1\t\2\t/' admin2Codes.txt | $PSQL "\copy admin2_codes FROM STDIN DELIMITER E'\t' CSV QUOTE E'\b'"

$PSQL "\copy iso_language_codes FROM iso-languagecodes.txt DELIMITER E'\t' CSV HEADER"

sort -u -k1,2 hierarchy.txt \
| $PSQL "\copy hierarchy FROM STDIN DELIMITER E'\t' CSV"

$PSQL "\copy user_tags FROM userTags.txt DELIMITER E'\t' CSV QUOTE E'\b'"