-- found using keyword search out on usaspending.gov...
--    "fact check" in keyword box
--   TODO what fields are searched when I submit a keyword? is that mapped to a view or full text search or?


-- found this:
-- https://www.usaspending.gov/recipient/e4c25323-decd-e763-4b50-7aad372da7cd-C/latest
-- Q5XXTGK3A6C5 (UEI )
-- 021690285 (Legacy DUNS )
select * from rpt.recipient_profile where recipient_name ilike '%MEEDAN%'

-- also found smth in DUNS? what is this?
select * from int.duns where legal_business_name ilike '%meedan%'


-- FYI ... dont need ::UUID :) on end 
-- hrm... multiple entries with same hash in rpt.recipient_profile...
select * from rpt.recipient_profile where recipient_hash = 'e4c25323-decd-e763-4b50-7aad372da7cd'
-- one is marked P and other C (parent/child?)
--    FYI look above at the URL you can see -C after the hash 
--       and -P works too:   https://www.usaspending.gov/recipient/e4c25323-decd-e763-4b50-7aad372da7cd-P/latest
-- TODO 021690285 recipeient_unique_id  -- is this used for matching recipients?
--   also ['Q5XXTGK3A6C5'] recipient_affiliations? matches to uei?
-- *** recipient_affiliations / uei
select * from rpt.recipient_profile where 'Q5XXTGK3A6C5' = ANY(recipient_affiliations)
select * from rpt.recipient_profile where uei = 'Q5XXTGK3A6C5'



-- https://github.com/meedan/check-api/blob/cdb68cd74b3938d053daee9ade4ea3ba72095ab5/data/research/CT2022-Task2A-EN-Train_QRELs.tsv#L799


