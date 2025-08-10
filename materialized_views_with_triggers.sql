--this trigger updates the materialized view daily_sales_m after an delete operation on bill_products table
--it updates the count and total fields in the materialized view for the date corresponding to the
--notice the use of old keyword to refer to the deleted row's data
delimiter //
create trigger mat_view_delete after delete on bill_products
for each row
begin
  update daily_sales_m set
    count = (select count(*) from bill_products where date(date_added) = date(old.date_added)),
    total = (select sum(total) from bill_products where date(date_added) = date(old.date_added))
  where date = date(old.date_added);
end
//
delimiter ;

--now what if the user updates the date on bill_products?
--we need to update the materialized view accordingly
--this trigger updates the materialized view daily_sales_m after an update operation on bill_products table

delimiter //
create trigger mat_view_update after update on bill_products
for each row
begin
  --when the date is changed, we need to update the old date's count and total
  if date(old.date_added) <> date(new.date_added) then
    update daily_sales_m set
      count = (select count(*) from bill_products where date(date_added) = date(old.date_added)),
      total = (select sum(total) from bill_products where date(date_added) = date(old.date_added))
    where date = date(old.date_added);
    
    --and also update the new date's count and total
    update daily_sales_m set
      count = (select count(*) from bill_products where date(date_added) = date(new.date_added)),
      total = (select sum(total) from bill_products where date(date_added) = date(new.date_added))
    where date = date(new.date_added);
  else
    --if the date hasn't changed, we just need to update the totals for the same date
    update daily_sales_m set
      count = (select count(*) from bill_products where date(date_added) = date(new.date_added)),
      total = (select sum(total) from bill_products where date(date_added) = date(new.date_added))
    where date = date(new.date_added);
  end if;
end
//
delimiter ;
