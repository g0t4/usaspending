

-- *** key tables
-- list tables
-- \dt
-- \dt *.*
-- \dt rpt.*
SELECT tablename FROM pg_tables WHERE schemaname = 'public';


-- find columns
 SELECT column_name, data_type, is_nullable, column_default, table_name
FROM information_schema.columns WHERE column_name LIKE '%recipient%name%';


