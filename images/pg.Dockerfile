FROM postgres:latest 

# fish shell provides completions!
RUN apt update \
    && apt install -y fish unzip file


# https://github.com/postgis/docker-postgis/blob/81a0b55/14-3.2/Dockerfile
# apt search postgresql-$PG_MAJOR
# 
#  installed:
#  SELECT * FROM pg_extensions;
#  
#  available:
#  SELECT name FROM pg_available_extensions;
# # all of these are available OOB
# dblink 
# hstore 
# intarray 
# pg_prewarm 
# pg_stat_statements 
# pg_trgm 
# postgres_fdw
