## USASPENDING.gov

Get your hands on the entire database!

## Instructions

```sh
# You'll need Docker Desktop for Mac/Win/Linux installed... or Docker running somewhere you can access.

# Download the databases, I'd recommend using a client that can resume on failures... or just wget it:
# it would be wise to start with the subset only (4.6GB) instead of the full db (146GB)
cd downloads
wget "https://files.usaspending.gov/database_download/usaspending-db-subset_20250106.zip"
wget "https://files.usaspending.gov/database_download/usaspending-db_20250106.zip"
# the zip files exist as a container (the files are gzip compressed inside)
# Unzip:
unzip -d subset usaspending-db-subset_20250106.zip
# 146 GB zip, ___ uncompressed (mostly *.dat.gz)
#   __ volume once restored (in docker container)
unzip -d full usaspending-db_20250106.zip 
# 4.6GB zip, 4.7GB uncompressed (mostly *.dat.gz) 
#   42GB volume one crestored and IIAC materialized views are rebuilt/ing

# TODO put any initialization into ./initdb/
# - runs executable *.sh 
# - runs *.sql
# - sources non-exeuctable *.sh

# TODO review database config example:
# /usr/share/postgresql/postgresql.conf.sample

# start the database container
docker compose up
# use Ctrl+C to stop it

# shell access:
docker compose exec db fish
# connect to psql:
psql -U postgres
\l # list databases
\? # help
\c subset # switch dbs
\d # list tables, views, etc
\dt # list tables (shorthand)
select name, website from toptier_agency
# nvim found the database dump files and is suggesting completions for tables !!! 

# restore subset
pg_restore --list /downloads/pruned_data_store_api_dump/subset
createdb subset -U postgres
pg_restore --clean --verbose -U postgres --dbname=subset /downloads/pruned_data_store_api_dump/subset  --no-owner -j 8
# --no-owner b/c everything was marked owned by etl_user, else get error:
#     pg_restore: error: could not execute query: ERROR:  role "etl_user" does not exist
# --verbose gives updates => compare to pg_restore --list above to see overall position in restore
#     SELECT * FROM pg_stat_progress_copy;
#     # track bites read:
#     pv backup.dump | pg_restore -d mydb --verbose
# ~20 minutes for subset w/o -j 
# 00:53 => 01:09   -j 8 (10 cores allocated to my docker VM) => 16 mins 
# TODO address import errors or is that expected w/ subset? 


```

Refer to the docs for the [postgres image on Docker Hub](https://hub.docker.com/_/postgres) 

## Cleanup

```sh

# do not do this until you're ready to lose it all!
docker compose down --remove-orphans --volumes --rmi all

```

## The Money Shot

- [Full database - Jan 6, 2025](https://files.usaspending.gov/database_download/usaspending-db_20250106.zip)
- [Subset database - Jan 6, 2025](https://files.usaspending.gov/database_download/usaspending-db-subset_20250106.zip)

## Resources

- [Database setup guide](https://files.usaspending.gov/database_download/usaspending-db-setup.pdf)
- [Download page with latest files](https://onevoicecrm.my.site.com/usaspending/s/database-download)
  - Sign up for an account if you want to discuss the datasets with other users
- [Discussions](https://onevoicecrm.my.site.com/usaspending/s/)
