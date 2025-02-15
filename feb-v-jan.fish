#SELECT datname, pg_size_pretty(pg_database_size(datname))
# FROM pg_database
# ORDER BY pg_database_size(datname) DESC;
#
#+-----------+----------------+
#| datname   | pg_size_pretty |
#|-----------+----------------|
#| full-feb  | 1429 GB        |
#| full      | 1404 GB        |
# *** clearly the sizes are very close => 25GB growth (0.018% growth)
# *** whereas the compressed sizes are 41GB different (28% increase):
# -rw-r--r-- 1 wes  wes  146G Feb  8 15:38 usaspending-db_20250106.zip
# -rw-r--r-- 1 wes  wes  187G Feb 11 17:26 usaspending-db_20250206.zip
# 
# two ideas come to mind:
# 1. compression algorithm/settings changed
# 2. substantial amount of existing data was changed (not just the new date added)
#    - perhaps maybe just some changed enough to pooch the compression
#    - or the mix of new and old data didn't play well for compression?
# 3. both


echo "select
    schemaname || '.' || relname as fq_table_name,
    pg_size_pretty(pg_total_relation_size(relid)) as total_size
from pg_stat_user_tables
order by pg_total_relation_size(relid) desc;" | psql -d full > table_sizes.jan.log
# | psql -d full-feb > table_sizes.feb.log

echo "select
    schemaname || '.' || relname as fq_table_name,
    pg_size_pretty(pg_total_relation_size(relid)) as total_size
from pg_stat_user_tables
order by fq_table_name desc;" | psql -d full > table_sizes.sorted-name.jan.log
# | psql -d full-feb > table_sizes.sorted-name.feb.log

# don't show context, best way to see differences
icdiff table_sizes.sorted-name.jan.log table_sizes.sorted-name.feb.log --numlines 0

# sorted by name is best for comparing... 
#   public.c_to_d_linkage_updates  # went from 0bytes to 192KB... interesting?
#   MOST tables have totall reasonable growth (i.e. < 1% of past month size)



