## USASPENDING.gov

Get your hands on the entire database!

## Instructions

```sh
# You'll need Docker Desktop for Mac/Win/Linux installed... or Docker running somewhere you can access.

# Download the datasets, I'd recommend using a client that can resume on failures... or just wget it:
wget "https://files.usaspending.gov/database_download/usaspending-db_20250106.zip"
wget "https://files.usaspending.gov/database_download/usaspending-db-subset_20250106.zip"
# Unzip:
unzip usaspending-db_20250106.zip
unzip usaspending-db-subset_20250106.zip

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
