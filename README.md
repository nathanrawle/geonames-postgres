# geonames-postgres
Scripts to initialise schemas and load data from genomes.org gazetteer data into a postgres database
## Pre-requisites
- psql (only tested on version 14.9)
- geonames [gazetteer][gn_gazetteer_dump] files (see #Installation for details)

## Installation
1. Download the following gazetteer files from [geonames][gn_gazetteer_dump] to the same directory as `populate_database.sh`:
    - allCountries.zip
    - alternateNamesV2.txt
    - timeZones.txt
    - iso-languagecodes.txt
    - hierarchy.zip
    - userTags.txt
2. Extract all .zip files
3. Log in to psql and add the user "geonames" to your postgres cluster:
```sql
CREATE USER geonames;
```
4. Run the following commands:
```sh
# create database and define schemas
psql -f init.sql

# load gazetteer data into `geonames` schemas
./populate_database.sh
```

[gn_gazetteer_dump]: http://download.geonames.org/export/dump/ "latest dump of free gazetteer extracts"
