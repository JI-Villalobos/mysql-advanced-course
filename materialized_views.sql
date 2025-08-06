--materialized views in MySQL are not supported directly, but we can create
--a structure that mimics their behavior using a combination of views and
--triggers to keep the data updated.

--lets create a table to store the daily sales data
create table daily_sales_m(
  `date` date not null,
  `count` integer unsigned not null,
  `total` float
)

--fill the table using select
insert into daily_sales_m(`date`, `count`, `total`)
select date(date_added) as `date`,
  count(bill_product_id) as `count`,
  sum(total) as `total`
from bill_products
group by 1;

--find bill_products bought by cliens from Argentina
select bp.bill_product_id, date(bp.date_added), bp.total
from bill_products as bp
left join bills as b 
  on bp.bill_id = b.bill_id
left join clients as c 
  on b.client_id = c.client_id
where c.country = 'ar';

--we can use the same query using nested selects
select bp.bill_product_id, date(bp.date_added), bp.total
from bill_products as bp
where bp.bill_id in (
  select b.bill_id
  from bills as b
  left join clients as c 
    on b.client_id = c.client_id
  where c.country = 'ar'
);

--create a new column in clients table to store the count onf bills
alter table clients add column bill_count integer unsigned;

--now update the clients table with the count of bills
update clients as c set bill_count = (
  select count(b.bill_id)
  from bills as b
  where b.client_id = c.client_id
);

select client_id, name, gender, country, bill_count from clients where bill_count > 0;

--result
+-----------+------------------------+--------+---------+------------+
| client_id | name                   | gender | country | bill_count |
+-----------+------------------------+--------+---------+------------+
|      6106 | Miss Cathy Brekke III  | m      | mx      |          1 |
|      8303 | Kathryne Conroy        | m      | co      |          1 |
|     11977 | Dr. Bettye Pacocha V   | f      | mx      |          1 |
|     12723 | Rocky Block            | m      | mx      |          1 |
|     23159 | Theo Koch              | m      | us      |          1 |
|     26073 | Carlo Bashirian        | m      | co      |          1 |
|     26902 | Dr. Andrew Harber      | m      | mx      |          1 |
|     28898 | Titus Herzog           | f      | ar      |          1 |
|     42466 | Heaven Lynch           | f      | mx      |          1 |
|     46843 | Josiah Kirlin DDS      | f      | co      |          1 |
|     50651 | Bridie Sporer III      | f      | mx      |          1 |
|     54165 | Ben Rosenbaum          | f      | mx      |          1 |
|     59194 | Andy Funk              | f      | ar      |          1 |
|     60939 | Dr. Addison Dare II    | f      | mx      |          1 |
|     67024 | Mr. Lenny Hartmann Sr. | f      | co      |          1 |
|     71005 | Elvie Vandervort       | f      | mx      |          1 |
|     73188 | Jillian Predovic       | m      | mx      |          1 |
|     83275 | Myles Little           | m      | mx      |          1 |
|     89743 | Thaddeus Wyman         | f      | co      |          1 |
|     91577 | Miss Mina Davis        | f      | co      |          1 |
+-----------+------------------------+--------+---------+------------+

-- we need to insert on daliy_sales_m table on a daily basis
-- we can use a trigger to do this, but since MySQL does not support materialized
-- views directly, we can use a stored procedure to update the table
inser into daily_sales_m(`date`, `count`, `total`)
select date(date_added), count(bill_product_id), sum(total)
from bill_products
group by 1
on duplicate key update
  `count` = (select count(bill_product_id from bill_products where date(date_added) = daily_sales_m.date),
  `total` = (select sum(total) from bill_products where date(date_added) = daily_sales_m.date);


--a trigger is a function that is executed automatically when a certain event occurs
--could be after or before an insert, update or delete
--now we can create a trigger to update the daily_sales_m table
delimiter //
create trigger update_daily_sales_m
after insert on bill_products
for each row
begin
  insert into daily_sales_m(`date`, `count`, `total`)
  values (
    date(new.date_added), 
    (select count(bill_product_id) from bill_products where date(date_added) = date(new.date_added)),
    (select sum(total) from bill_products where date(date_added) = date(new.date_added)))
  on duplicate key update
    `count` = values(`count`),
    `total` = values(`total`);
end;
    //