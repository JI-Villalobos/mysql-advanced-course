--bill_products table needs a new column  to calculate the total of the products
alter table bill_products add column total float as (
  price * quantity * (1 - discount/100)
) after discount;

select product_id, quantity, price, discount, total from bill_products limit 10;
--result
+------------+----------+---------+----------+---------+
| product_id | quantity | price   | discount | total   |
+------------+----------+---------+----------+---------+
|       1599 |        7 | 2825.28 |       10 | 17799.3 |
|        233 |       19 | 3597.27 |        0 | 68348.1 |
|       1516 |        9 | 3305.04 |       15 | 25283.6 |
|         27 |        4 |  369.38 |       20 | 1182.02 |
|       1831 |       10 | 3901.88 |       10 | 35116.9 |
|       1724 |       15 | 2381.34 |        5 | 33934.1 |
|        457 |        7 |  767.42 |       15 | 4566.15 |
|        268 |       20 | 2368.45 |       20 | 37895.2 |
|        815 |        7 | 3741.49 |       20 | 20952.3 |
|        586 |       10 |  1945.7 |       10 | 17511.3 |
+------------+----------+---------+----------+---------+


--what if i want to know the sales by day?
select date(date_added) as `date`, 
  count(bill_product_id), 
  sum(quantity),
  avg(discount),
  max(discount),
  max(total), 
  sum(total)
from bill_products
group by 1
order by 1 asc;
 

--now we can save this query as a view
 create view daily_sales as (
  select date(date_added) as `date`, 
    count(bill_product_id) `count`, 
    sum(quantity) as sum_quantity,
    avg(discount) as avg_discount,
    max(discount) as max_discount,
    max(total) max_total, 
    sum(total) sum_total
  from bill_products
  group by 1
  order by 1 asc
);

--using the view
select * from daily_sales limit 10;
--result
+------------+-------+--------------+--------------+--------------+-----------+--------------------+
| date       | count | sum_quantity | avg_discount | max_discount | max_total | sum_total          |
+------------+-------+--------------+--------------+--------------+-----------+--------------------+
| 2024-03-13 |     2 |           25 |       5.0000 |           10 |   33449.5 |  39551.39208984375 |
| 2024-03-14 |     2 |           23 |      32.5000 |           50 |     12802 |  18100.52490234375 |
| 2024-03-15 |     1 |            2 |      50.0000 |           50 |   2382.74 |  2382.739990234375 |
| 2024-03-16 |     3 |           23 |       6.6667 |           20 |   49349.9 |   69577.6201171875 |
| 2024-03-17 |     2 |           16 |      17.5000 |           20 |   14966.4 |      20808.9765625 |
| 2024-03-18 |     5 |           64 |      18.0000 |           50 |   47640.6 | 113662.54956054688 |
| 2024-03-19 |     3 |           28 |      30.0000 |           50 |     39860 | 46642.067626953125 |
| 2024-03-20 |     4 |           14 |       8.7500 |           15 |   22644.6 |  30162.21844482422 |
| 2024-03-21 |     1 |            6 |      15.0000 |           15 |   20869.4 |    20869.353515625 |
| 2024-03-22 |     4 |           33 |      22.5000 |           50 |   20567.4 |  40067.98205566406 |
+------------+-------+--------------+--------------+--------------+-----------+--------------------+

