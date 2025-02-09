
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

-- estimated rows (descending, formatted with commas)
SELECT relname AS table_name, 
        to_char(reltuples, 'FM999,999,999,999') AS estimated_rows
FROM pg_class
WHERE relkind = 'r'
ORDER BY reltuples DESC;

-- FYI <Ctrl+R> search through previous commands
