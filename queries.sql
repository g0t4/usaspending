
-- *** connect to a database
-- \c full
-- \c subset

-- list schemas:
-- \dn 

-- *** key tables
-- list tables
-- \dt
-- \dt *.*
-- \dt rpt.*
SELECT tablename FROM pg_tables WHERE schemaname = 'public';

-- [d]escribe table's schema:
-- \d rpt.award_search

-- find columns
SELECT column_name, data_type, is_nullable, column_default, table_name, table_schema
FROM information_schema.columns WHERE column_name LIKE '%recipient%name%';

-- row counts per table:
SELECT schemaname, relname AS table_name, 
    to_char(n_live_tup, 'FM999,999,999,999') AS exact_row_count
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;

-- FYI <Ctrl+R> search through previous commands

-- FYI pgcli has fuzzy like matching it seems:
--   rn<Tab> => recipient_name !!!

