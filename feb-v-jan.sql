-- Jan vs Feb 2025 usaspending database
-- Goal is to understand what changes month to month
-- and really curious if anything has changed about what is tracked
--   Jan was under Biden
--   Feb was under Trump

select pg_size_pretty(pg_total_relation_size('public.agency'));



-- select relid::regclass 
select
    schemaname || '.' || relname as table_name,
    pg_size_pretty(pg_total_relation_size(relid)) as total_size
from pg_stat_user_tables
order by pg_total_relation_size(relid) desc;
