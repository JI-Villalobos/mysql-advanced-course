--create an example table with a generated column

create table example(
  example_id integer unsigned primary key auto_increment,
  quantity integer not null default 1,
  price float not null,
  total float as (quantity * price)
);

--result
+------------+--------------+------+-----+---------+-------------------+
| Field      | Type         | Null | Key | Default | Extra             |
+------------+--------------+------+-----+---------+-------------------+
| example_id | int unsigned | NO   | PRI | NULL    | auto_increment    |
| quantity   | int          | NO   |     | 1       |                   |
| price      | float        | NO   |     | NULL    |                   |
| total      | float        | YES  |     | NULL    | VIRTUAL GENERATED |
+------------+--------------+------+-----+---------+-------------------+
| 4 rows in set (0.00 sec)

--virtual generated columns are not stored in the table, 
--but calculated on the fly
--if you want to store the value, you can use a stored generated column
--to do this, you can use the keyword STORED instead of VIRTUAL

insert into example(quantity, price)
values (10, 5.99), (2, 3.49), (1, 19.99);

select * from example;
--result
+------------+----------+-------+-------+
| example_id | quantity | price | total |
+------------+----------+-------+-------+
|          1 |       10 |  5.99 |  59.9 |
|          2 |        2 |  3.49 |  6.98 |
|          3 |        1 | 19.99 | 19.99 |
+------------+----------+-------+-------+
3 rows in set (0.00 sec)

--now an example of a stored generated column
alter table example
  add column total_stored float as (quantity * price) stored;

--result
+--------------+--------------+------+-----+---------+-------------------+
| Field        | Type         | Null | Key | Default | Extra             |
+--------------+--------------+------+-----+---------+-------------------+
| example_id   | int unsigned | NO   | PRI | NULL    | auto_increment    |
| quantity     | int          | NO   |     | 1       |                   |
| price        | float        | NO   |     | NULL    |                   |
| total        | float        | YES  |     | NULL    | VIRTUAL GENERATED |
| total_stored | float        | YES  |     | NULL    | STORED GENERATED  |
+--------------+--------------+------+-----+---------+-------------------+

--obviously, the total_stored column will take more space
--but it will be faster to access, since it is stored in the table



--as an example we'll use the description column on the products table,
--adding a new column with the length of the description field
alter table products
  add column description_length integer as (length(description));

select product_id, description_length, substr(description, 1, 15)
  from products limit 8;

--notice i use substr to show only the first 15 characters
--result
+------------+--------------------+----------------------------+
| product_id | description_length | substr(description, 1, 15) |
+------------+--------------------+----------------------------+
|          1 |                145 | Recusandae quo             |
|          2 |                143 | Tempore libero             |
|          3 |                 76 | Possimus atque             |
|          4 |                113 | Ut iusto unde d            |
|          5 |                 81 | Voluptate qui l            |
|          6 |                112 | Vel maiores fac            |
|          7 |                157 | Consequatur num            |
|          8 |                155 | Iste vel et vol            |
+------------+--------------------+----------------------------+
8 rows in set (0.00 sec)


