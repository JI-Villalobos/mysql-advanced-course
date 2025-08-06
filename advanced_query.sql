--ad gender to clients table
alter table clients 
  add column gender enum('m', 'f', 'ns') default 'ns' not null;

alter table clients 
  add column country varchar(2) default 'mx' not null;


select country, gender, count(*) as `total`
from clients
group by country, 2 --2 = gender
order by 3 desc; --3 = total

--result
+---------+--------+-------+
| country | gender | total |
+---------+--------+-------+
| mx      | m      | 25022 |
| mx      | f      | 23691 |
| co      | m      | 13152 |
| co      | f      | 12659 |
| us      | m      |  6429 |
| us      | f      |  6113 |
| ar      | m      |  5571 |
| ar      | f      |  5386 |
+---------+--------+-------+
8 rows in set (0.18 sec)


--we could show with a ore concice query 
select country, sum(
  if(gender = 'm', 1, 0)
) as m, 
sum(
  if (gender = 'f', 1, 0)
  ) as f,
count(*) as `total`
from clients
group by country
order by total desc;

--result
+---------+-------+-------+-------+
| country | m     | f     | total |
+---------+-------+-------+-------+
| mx      | 25022 | 23691 | 48713 |
| co      | 13152 | 12659 | 25811 |
| us      |  6429 |  6113 | 12542 |
| ar      |  5571 |  5386 | 10957 |
+---------+-------+-------+-------+
4 rows in set (0.25 sec)

--but if i ant to show te table as a pivot table
select gender, sum(if(country = 'mx', 1, 0)) as mx,
sum(if(country = 'co', 1, 0)) as co,
sum(if(country = 'us', 1, 0)) as us,
sum(if(country = 'ar', 1, 0)) as ar,
count(*) as `total`
from clients
group by 1; --1 == gender

--result
+--------+-------+-------+------+------+-------+
| gender | mx    | co    | us   | ar   | total |
+--------+-------+-------+------+------+-------+
| f      | 23691 | 12659 | 6113 | 5386 | 47849 |
| m      | 25022 | 13152 | 6429 | 5571 | 50174 |
+--------+-------+-------+------+------+-------+
2 rows in set (0.24 sec)

