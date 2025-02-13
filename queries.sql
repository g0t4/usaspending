
-- *** connect to a database
-- \c full
-- \c subset

-- list schemas:
-- \dn 

-- *** key tables
-- list tables
-- \dt *.*
-- \dt rpt.*
SELECT tablename FROM pg_tables WHERE schemaname = 'public';

-- [d]escribe table's schema:
-- \d rpt.award_search

-- *** find columns
SELECT column_name, data_type, is_nullable, column_default, table_name, table_schema
FROM information_schema.columns WHERE column_name ILIKE '%recipient%name%';

-- row counts per table:
SELECT schemaname, relname AS table_name, 
    to_char(n_live_tup, 'FM999,999,999,999') AS exact_row_count
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;

-- FYI <Ctrl+R> search through previous commands

/*
pgcli pros:
- fuzzy like tab complete
      rn<Tab> => recipient_name !!!
- syntax coloring
- tab complete w/ popup menu!
- don't need the F*$# semicolon on end of lines!

*/



select * from rpt.recipient_lookup where legal_business_name ilike '%politico%';
select * from rpt.recipient_profile where recipient_hash = '13b50da5-5b3e-eb77-a123-7daff7c433be'::UUID
-- recipient_name is legal_business_name (no matches)
select P.id,  legal_business_name FROM rpt.recipient_lookup L LEFT JOIN rpt.recipient_profile P ON L.recipient_hash = P.recipient_hash 
WHERE L.legal_business_name <> P.recipient_name  LIMIT 10;

-- awards (POLITICO):
select * from rpt.award_search where recipient_hash = '13b50da5-5b3e-eb77-a123-7daff7c433be'::UUID
-- \x    -- toggle list mode (think pwsh Format-List)

-- index lookup
SELECT schemaname, tablename, indexname, tablespace, indexdef
FROM pg_indexes
ORDER BY tablename, indexname

-- index size
-- FYI pg_stat_user_indexes is subset of pg_stat_all_indexes https://www.postgresql.org/docs/current/monitoring-stats.html#MONITORING-PG-STAT-ALL-INDEXES-VIEW
SELECT indexrelname, 
    pg_size_pretty(pg_relation_size(indexrelid)) AS main_fork_size,
    pg_size_pretty(pg_total_relation_size(indexrelid)) As total_size
FROM pg_stat_user_indexes 
WHERE schemaname = 'rpt' AND tablename = 'award_search';
-- FYI pg_size_pretty(number|bigint): https://www.postgresql.org/docs/current/functions-admin.html
select pg_size_pretty(10000000000::bigint)

-- why is there an index on recipient_hash but qualified as action_date >= 2007-10-01?!
--  152,935,236 (91+% indexed)
--   14,342,863 (10% action_date < 2007-10-01)

-- lookup pg_index joined with pg_class (to get oid)
select I.*,C.oid 
from pg_indexes I 
    left join pg_class C on C.relname = I.indexname 
where schemaname = 'rpt' and tablename = 'award_search';

-- indexes by table and size
select I.schemaname, I.tablename, I.indexname, C.oid, pg_size_pretty(pg_total_relation_size(oid)) 
from pg_indexes I left join pg_class C on C.relname = I.indexname
where schemaname = 'rpt' and tablename = 'award_search';
-- OR:
SELECT schemaname, relname, indexrelname, pg_size_pretty(pg_total_relation_size(indexrelid)) As total_size 
FROM pg_stat_user_indexes WHERE schemaname = 'rpt' and relname = 'award_search' 
-- *** include indexdef (requires using pg_indexes instead of pg_stat_user_indexes)
select I.schemaname, I.tablename, I.indexname, C.oid, pg_size_pretty(pg_total_relation_size(oid)), I.indexdef 
from pg_indexes I left join pg_class C on C.relname = I.indexname
where schemaname = 'rpt' and tablename = 'award_search';

-- https://www.postgresql.org/docs/current/sql-createindex.html
-- create index on recipient_hash over all fields:
--    currently, the existing index:
--       CREATE INDEX as_idx_recipient_hash ON rpt.award_search USING btree (recipient_hash) WHERE (action_date >= '2007-10-01'::date)
-- 
-- so I remade it w/ all records  (1476MB => 1585MB... inconsequential change and HUGE deal for lookups)
CREATE INDEX wes_idx_rpt_award_search_recipient_hash ON rpt.award_search USING btree (recipient_hash);
--    took ~3minutes to create
--    FYI select * from rpt.award_search  where recipient_hash = '13b50da5-5b3e-eb77-a123-7daff7c433be'::UUID -- now was 2 min, now < 0.100 sec! 
-- monitor progress:
SELECT * FROM pg_stat_progress_create_index;
-- FYI psql supports this to comma delimt numbers... pgcli says not supported?!
-- \pset numericlocale on
--   apparently its buggy too.. oh well https://www.postgresql.org/message-id/20643.1447362580@sss.pgh.pa.us


-- improve perf
-- 96GB RAM on system, nearly all unused (arch linux)
-- https://www.postgresql.org/docs/current/runtime-config-resource.html
ALTER SYSTEM SET shared_buffers = '24GB'; -- 128MB default, suggested 25% RAM, up to max 40%
-- TODO -- ALTER SYSTEM SET maintenance_work_mem = '12GB'; -- 64MB default


-- FYI explain queries (investigate perf):
EXPLAIN (ANALYZE, BUFFERS) select * from rpt.award_search where recipient_hash = '13b50da5-5b3e-eb77-a123-7daff7c433be'::UUID;


-- TODO constraint lookup
select oid, conname, pg_get_constraintdef(oid) from pg_constraint limit 10;

-- FYI namespace == schema (ns is the structure to support schema IIUC)
select * from information_schema.schemata;
select * from pg_namespace;
-- ns provides ACL too

-- pg_catalog is a namespace (aka schema)
--   houses pg_* objects
select * from pg_namespace where OID = 11;
select * from pg_class where relnamespace = 11; -- find objects in pg_catalog 
select * from pg_class where relnamespace = 11 and relname ilike '%pg_index%' -- pg_index related catalogs
select * from pg_catalog.pg_class  -- same as `from pg_class`

-- lookup pg_indexes:
select oid,relname,relkind from pg_class where relnamespace = 11 and relname = 'pg_indexes'
-- rel kinds:
select distinct(relkind) from pg_class 
-- 'r' – Table (ordinary relation)
-- 'v' – View
-- 'm' – Materialized view
-- 'i' – Index
-- 'S' – Sequence
-- 't' – TOAST table
-- 'f' – Foreign table
-- 'p' – Partitioned table
-- 'I' - Partitioned index
-- 'c' - Composite type

-- TOAST - The Oversized-Attribute Storage Technique
--   lookups for records beyond the page size (tuple limit)
--   can impact performance
--   can only index first ~2KB of value


/*
operators:
  foo ILIKE '%bar%'  -- case insensitive
  foo LIKE '%bar%' -- case sensitive
  foo *= bar        -- regex? TODO
  foo <> bar        -- inequal

\do       -- list operators
  \do =   -- help for = operator (by column type too!)
  unfortunately doesn't work for \do LIKE
  
*/

-- casts
select '13b50da5-5b3e-eb77-a123-7daff7c433be'::UUID

















