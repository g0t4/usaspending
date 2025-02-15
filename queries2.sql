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

-- and the reverse:
select 'rpt.award_search'::regclass -- => rpt.award_search 

-- find oid/relid for tables with 'award' in name
select oid,relname from pg_class where relkind = 'r' and relname ilike '%award%'
-- | 17602 | award_search                 |
-- | 17461 | award_category               |
-- | 17816 | subaward_search              |
-- | 17797 | parent_award                 |
-- | 17555 | financial_accounts_by_awards |

-- full constraint query:
select conrelid::regclass as table_from, 
    confrelid::regclass as table_to, 
    conname, contype,
    pg_get_constraintdef(oid)
from pg_constraint
where conrelid in (select oid from pg_class where relkind = 'r' and relname ilike '%award%')

-- ALL FOREIGN KEYS only:
SELECT conrelid::regclass as table_from,
    confrelid::regclass as table_to,
    conname,
    pg_get_constraintdef(oid) 
FROM pg_constraint
WHERE contype = 'f';


-- WHERE CLAUSE REVERSE conrelid => string::regclass
select conrelid::regclass as table_from, 
     confrelid::regclass as table_to, 
     conname, contype,
     pg_get_constraintdef(oid)
 from pg_constraint
 where conrelid = 'rpt.subaward_search'::regclass
-- FYI conrelid = 'rpt.subaward_search'::regclass ***  

-- FYI find all objects with word in name
select * from pg_class where relname ilike '%broker%'
select * from pg_class where relname ilike '%award%'



