-- \c loc_services_development;

drop view countbankfiles;
drop view countfailedlines;
drop view countbanklines;

create or replace view fooview as select * from bank_files order by id desc;

select * from bank_failed_lines;
explain(select * from banks.transactions);

