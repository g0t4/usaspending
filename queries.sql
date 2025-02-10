
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
SELECT indexname, indexdef, tablename FROM pg_indexes
ORDER BY tablename, indexname
SELECT 
    indexname, 
    pg_size_pretty(pg_relation_size(indexrelid)) AS size
FROM pg_stat_user_indexes 
WHERE schemaname = 'rpt' AND tablename = 'award_search';

-- why is there an index on recipient_hash but qualified as action_date >= 2007-10-01?!
--  152,935,236 (91+% indexed)
--   14,342,863 (10% action_date < 2007-10-01)



-- improve perf
-- 96GB RAM on system, nearly all unused (arch linux)
-- https://www.postgresql.org/docs/current/runtime-config-resource.html
ALTER SYSTEM SET shared_buffers = '24GB'; -- 128MB default, suggested 25% RAM, up to max 40%
-- TODO -- ALTER SYSTEM SET maintenance_work_mem = '12GB'; -- 64MB default
-- lets analyze a query first:
EXPLAIN (ANALYZE, BUFFERS) select * from rpt.award_search where recipient_hash = '13b50da5-5b3e-eb77-a123-7daff7c433be'::UUID;


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

















