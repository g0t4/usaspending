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
# Unzip:
unzip usaspending-db-subset_20250106.zip
unzip usaspending-db_20250106.zip

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
docker compose exec db bash
# connect to psql:
psql -U postgres
\l # list databases
\? # help
\d # list tables, views, etc
\dt # list tables (shorthand)

# TODO postgres-contrib*
apt update
apt search postgresql-contrib

# restore
# /downloads/pruned_data_store_api_dump/toc.dat
docker compose exec db bash
pg_restore --list /downloads/pruned_data_store_api_dump
createdb subset -U postgres
pg_restore -U postgres --dbname=subset /downloads/pruned_data_store_api_dump
#   -j 4   # parallel?
# pg_restore: error: could not execute query: ERROR:  role "etl_user" does not exist






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
