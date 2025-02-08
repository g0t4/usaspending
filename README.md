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

# start the database container
docker compose up
# use Ctrl+C to stop it



```

## The Money Shot

- [Full database - Jan 6, 2025](https://files.usaspending.gov/database_download/usaspending-db_20250106.zip)
- [Subset database - Jan 6, 2025](https://files.usaspending.gov/database_download/usaspending-db-subset_20250106.zip)

## Resources

- [Database setup guide](https://files.usaspending.gov/database_download/usaspending-db-setup.pdf)
- [Download page with latest files](https://onevoicecrm.my.site.com/usaspending/s/database-download)
  - Sign up for an account if you want to discuss the datasets with other users
- [Discussions](https://onevoicecrm.my.site.com/usaspending/s/)
