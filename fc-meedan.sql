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



