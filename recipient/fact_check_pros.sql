select * from rpt.recipient_lookup where legal_business_name ilike '%fact%check%'

-- +-------------+--------------------------------------+---------------------+--------+---------------------+---------------------+----------------------+----------+------------------------+--------------+-------------+----------------------------+-------+--------+-------+-----------------+--------+------------------------+--------+------------+
-- | id          | recipient_hash                       | legal_business_name | duns   | address_line_1      | address_line_2      | business_types_codes | city     | congressional_district | country_code | parent_duns | parent_legal_business_name | state | zip4   | zip5  | alternate_names | source | update_date            | uei    | parent_uei |
-- |-------------+--------------------------------------+---------------------+--------+---------------------+---------------------+----------------------+----------+------------------------+--------------+-------------+----------------------------+-------+--------+-------+-----------------+--------+------------------------+--------+------------|
-- | 27012781934 | 088c8a68-1683-87e4-5963-35c9bac84aeb | FACT CHECK PROS     | <null> | 81 PEARL STREET, 3B | 81 PEARL STREET, 3B | <null>               | BROOKLYN | 07                     | USA          | <null>      | <null>                     | NY    | <null> | 11201 | []              | fabs   | 2020-07-14 00:00:00+00 | <null> | <null>     |
-- +-------------+--------------------------------------+---------------------+--------+---------------------+---------------------+----------------------+----------+------------------------+--------------+-------------+----------------------------+-------+--------+-------+-----------------+--------+------------------------+--------+------------+

select * from rpt.recipient_lookup where recipient_hash = '088c8a68-1683-87e4-5963-35c9bac84aeb'::UUID
select * from rpt.recipient_profile where recipient_hash = '088c8a68-1683-87e4-5963-35c9bac84aeb'::UUID


-- TODO find a way to create reusable sets of queries in pgcli itself or in postgres...
--   unfortunatley a stored procedure in postgres cannot just run queries like in MSSQL and dump results as if user had run them..
--   have all sorts of bullshit to do the same thing... what a joke

