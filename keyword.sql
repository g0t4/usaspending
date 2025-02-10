-- TODO hunt what is used for keyword search on usaspending.gov

select * from pg_class where relname ilike '%keyword%'
-- ?? ss_idx_gin_keyword_ts_vector
select * from pg_indexes where indexname ilike '%keyword%'
select * from information_schema.columns where column_name ilike '%keyword%'

-- ts_vector
SELECT to_tsvector('english', 'PostgreSQL full-text search is awesome!');
-- interesting!!!
select keyword_ts_vector from rpt.subaward_search where keyword_ts_vector @@ to_tsquery('english','fact')



