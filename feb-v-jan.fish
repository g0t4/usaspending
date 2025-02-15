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

