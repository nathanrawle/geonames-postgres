#!/bin/bash

PSQL="psql -X --username=db_maker --dbname=geonames -t --no-align -c"

$PSQL "TRUNCATE TABLE geonames"

sed -E 's/\t{2}/\tNULL\t/g' ./cities500.txt \
| sed -E 's/\t{2}/\tNULL\t/g' \
| sed -E 's/\x27/\x27\x27/g' \
| while IFS=$'\t' read GID NAME ASCII ALT LAT LON FEAT_CLASS FEAT_CODE COUNTRY_CODE ALT_CC ADMIN1 ADMIN2 ADMIN3 ADMIN4 POP ELEVATION DEM TIMEZONE MOD_DATE
do
  INSERT_RESULT=$($PSQL "INSERT INTO geonames (
    geoname_id, 
    geoname,
    asciiname,
    latitude,
    longitude,
    feature_class,
    feature_code,
    country_code,
    alt_country_code,
    admin1_code,
    admin2_code,
    admin3_code,
    admin4_code,
    population,
    elevation,
    dem,
    timezone,
    gn_modification_date
  )
  VALUES (
    $GID,
    NULLIF('$NAME','NULL'),
    NULLIF('$ASCII','NULL'),
    $LAT,
    $LON,
    NULLIF('$FEAT_CLASS','NULL'),
    NULLIF('$FEAT_CODE','NULL'),
    NULLIF('$COUNTRY_CODE','NULL'),
    NULLIF('$ALT_CC','NULL'),
    NULLIF('$ADMIN1','NULL'),
    NULLIF('$ADMIN2','NULL'),
    NULLIF('$ADMIN3','NULL'),
    NULLIF('$ADMIN4','NULL'),
    $POP,
    $ELEVATION,
    $DEM,
    NULLIF('$TIMEZONE','NULL'),
    NULLIF('$MOD_DATE','NULL')::date
  )")
  if [[ $INSERT_RESULT != 'INSERT 0 1' ]]
  then
    echo "INSERT failed for $GID $NAME"
  fi
done