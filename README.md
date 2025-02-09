## USASPENDING.gov

Get your hands on the entire database!

## Instructions

```sh
# You'll need Docker Desktop for Mac/Win/Linux installed... or Docker running somewhere.

# *** Download the databases, I'd recommend using a client that can resume on failure... or just wget it
#   start w/ subset only (4.6GB) instead of the full db (146GB)
cd download
wget "https://files.usaspending.gov/database_download/usaspending-db-subset_20250106.zip"
wget "https://files.usaspending.gov/database_download/usaspending-db_20250106.zip"

# *** Extract zips
# the zip files exist as a container (the files are gzip compressed inside)
unzip -j -d subset usaspending-db-subset_20250106.zip
#   -j means strip all nested paths and put all files in one dir (-d subset)
#      note this only works if you don't need any nested dir structures
# sizes:
#   zip archive: 4.6GB zip, 
#   decompressed zip: 4.7GB (mostly *.dat.gz) 
#   gunzip'd *.gz: 26GB  
#     ls *.gz | parallel gunzip # decompress gzip files too... cannot trust gunzip -l b/c of int32 size issue
#     # FYI this is not the final db restore size (i.e. indexes/etc will take up space)
#     ls *.dat | xargs -I_ du -h _ | sort -h > ../subset-file-sizes.txt
#   pg_restore'd in docker volume: 42GB
#      42GB docker volume one crestored and IIAC materialized views are rebuilt/ing
#
unzip -d full usaspending-db_20250106.zip 
# sizes:
#  zip archive: 146 GB
#  decompressed zip: ?
#  gunzip'd *.gz: 1,228 GB (1.2TB)
#    FYI I also captured file sizes using:
#    ls *.dat | xargs -I_ du -h _ | sort -h > ../full-file-sizes.txt
#  pg_restore'd in docker volume: ___
#    TODO capture this once I get a successful restore

# *** start database container(s)
docker compose up --build
# only need --build if you change the Dockerfile (i.e. install additional packages)
# use Ctrl+C to stop it

# *** shell access
docker compose exec --env "PGUSER=postgres" db fish
# PGUSER=postgres means no `-U postgres` on every command
psql
# \l # list databases
# \? # help
# \c subset # switch dbs
# \d # list tables, views, etc
# \dt # list tables (shorthand)
# select name, website from toptier_agency
echo "\l" | psql

# *** restore 
# change database name
set dbname subset 
# 
dropdb $dbname --if-exists && createdb $dbname
# config optimizations:
echo "ALTER SYSTEM SET autovacuum = 'off';" | psql
echo "ALTER SYSTEM SET wal_level = minimal; ALTER SYSTEM SET max_wal_senders = 0; " | psql 

exit # the container
docker compose restart # applies new config
docker compose exec --env PGUSER=postgres db fish

# verify settings
echo "SHOW autovacuum" | psql
echo "SHOW wal_level; SHOW max_wal_senders;" | psql

set dbname subset 
pg_restore --verbose --dbname $dbname --no-owner /downloads/$dbname -j 8 
# monitor progress:
du -hd1 /var/lib/postgresql/data/

# undo config changes:
echo "ALTER SYSTEM SET autovacuum = 'on';" | psql
echo "ALTER SYSTEM SET wal_level = replica; ALTER SYSTEM SET max_wal_senders = 10; " | psql 
# BTW if you bork postgres config and db container fails on restart, then on container host edit the config:
nvim /var/lib/docker/volumes/usaspending_database/_data/postgresql.auto.conf
#    cat /var/lib/postgresql/data/postgresql.auto.conf # in the container
echo "SHOW config_file" | psql # find config file location
# remove any config in this file and then restart, you'll go back to defaults


# *** restore full
# MAKE SURE YOU HAVE 2+ TB of free space
set dbname full # set this above
```

## Investigating Config Optimizations for Restore

```sql
-- *** confirmed useful:
ALTER SYSTEM SET autovacuum = 'off'; -- on default, avoid errors during restore
-- avoid wal warnings:
ALTER SYSTEM SET wal_level = minimal; -- replica default
ALTER SYSTEM SET max_wal_senders = 0; -- 10 default

-- *** WIP:
--   FYI only going to try these if I run into issues with full restore
ALTER SYSTEM SET maintenance_work_mem = '12GB'; -- 64MB default
ALTER SYSTEM SET shared_buffers = '16GB'; -- 128GB default
-- FYI I ran into shared memory corrupted after 610GB... when I tried these memory mods the first time on the full db
ALTER SYSTEM SET max_parallel_maintenance_workers = 8; -- 2 default
ALTER SYSTEM SET synchronous_commit = 'off'; -- on default
ALTER SYSTEM SET work_mem = '512MB'; -- 4MB default
ALTER SYSTEM SET fsync = 'off'; -- on default
ALTER SYSTEM SET full_page_writes = 'off'; -- on default
-- ALTER SYSTEM SET checkpoint_completion_target = 0.9; -- 0.9 default (so don't need to change this unless using a diff value)
CHECKPOINT; -- TODO WHEN?
```

## Cleanup

```sh
# nuke everything:
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

## Misc Notes

- FYI you can pipe commands to psql:
    - `echo "\l \c test \dn \dt " | psql` 
- `pg_restore` args:
    - `--no-owner` b/c everything was marked owned by etl_user, else get errors:
        - pg_restore: error: could not execute query: ERROR:  role "etl_user" does not exist
    - `--verbose` for progress updates 
        - compare to `pg_restore --list` (below) to see overall position in restore
        - `SELECT * FROM pg_stat_progress_copy;`
    - `pg_restore --list /downloads/subset` 
        - to verify the backup files
    - `--clean` throws errors if objects don't exist
        - Can use `--clean --if-exists`
        - But, I still ran into issues with order of removing dependent objects
        - Just use drop/createdb
- docs for [postgres image on Docker Hub](https://hub.docker.com/_/postgres) 
- put initialization scripts in ./initdb/
    - runs executable *.sh 
    - runs *.sql
    - sources non-exeuctable *.sh
    - these are run during container creation (first time only)
- PRN review database config example:
    - /usr/share/postgresql/postgresql.conf.sample
- nvim found the database dump files and is suggesting completions for tables !!! 

