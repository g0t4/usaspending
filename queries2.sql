-- next set of querying... had issues with coc-sqlfluff on my ppp.sql file which is likely due to pasting in output of sql queries... which is invalid...
--  anyways start a new file for now... think of this as my sql notes 

-- lookup view definition:
SELECT definition FROM pg_views WHERE viewname = 'vw_awards';

-- OR:
select * from information_schema.views where table_schema = 'pg_catalog'


-- constraints between tables:
-- first find a table's OID
select * from pg_class where relname = 'award_search' -- => 17602

-- BTW lookup class name with:
select 17602::regclass -- => rpt.award_search
