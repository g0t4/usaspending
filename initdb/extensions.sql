
-- list extensions needed:
-- pg_restore --list /downloads/pruned_data_store_api_dump/ | grep EXTENSION
-- list "installed" extensions: 
--   SELECT * FROM pg_extensions;
-- list available:
--   SELECT name FROM pg_available_extensions;
-- to install more (note this list is from pg_restore --list above):
CREATE EXTENSION IF NOT EXISTS hstore;
CREATE EXTENSION IF NOT EXISTS dblink;
CREATE EXTENSION IF NOT EXISTS intarray;
CREATE EXTENSION IF NOT EXISTS pg_prewarm;
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS postgres_fdw;
-- so far all needed extension are available OOB in postgres v17.2
-- otherwise may need to find a package:
--  guidance: https://github.com/postgis/docker-postgis/blob/81a0b55/14-3.2/Dockerfile
--   apt update
--   apt search postgresql-contrib
-- TODO on full db, make sure to review extensions for any additional extensions needed

