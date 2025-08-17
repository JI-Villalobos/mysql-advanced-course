--most of the time we use left joins to get all records from the left table
--left is the value by default


select b.bill_id, c.name, c.email, b.status
from bills as b
left join clients as c
  on c.client_id = b.client_id;

select c.name, count(b.bill_id) as total_bills
from clients as c
left join bills as b 
  on b.client_id = c.client_id
where b.client_id is not null
group by c.name
limit 10;

select p.name, count(bp.product_id) as total_products 
from products as p
left join bill_products as bp
  on bp.product_id = p.product_id
where bp.product_id is not null
group by p.name
order by total_products desc;

--using bill as main table
select b.bill_id, c.name, count(p.product_id), sum(bp.quantity), sum(bp.total) from bills as b
left join clients as c 
  on c.client_id = b.client_id
left join bill_products as bp 
  on bp.bill_id = b.bill_id
left join products as p
  on p.product_id = bp.product_id
group by 1, 2

--using clients as main table
select b.bill_id, c.name, count(p.product_id), sum(bp.quantity), sum(bp.total)
from clients as c
left join bills as b
  on c.client_id = b.client_id
left join bill_products as bp 
  on bp.bill_id = b.bill_id
left join products as p
  on p.product_id = bp.product_id
where b.bill_id is not null
group by 1, 2


--who is the best client?
select c.name, count(b.bill_id) as total_bills, sum(bp.total) as total_spent
from clients as c
left join bills as b
  on c.client_id = b.client_id
left join bill_products as bp
  on bp.bill_id = b.bill_id
where b.bill_id is not null
group by c.name
order by total_spent desc;

--which is the most selled product
select p.name, sum(bp.quantity) as total_quantity
from products as p
left join bill_products as bp
  on bp.product_id = p.product_id
left join bills as b
  on b.bill_id = bp.bill_id
where bp.bill_product_id is not null
group by p.name
order by total_quantity desc
limit 10;


--which product made us earn more money
select p.name, sum(bp.quantity) as total_quantity, sum(bp.total) as total_earned
from products as p
left join bill_products as bp
  on bp.product_id = p.product_id
left join bills as b
  on b.bill_id = bp.bill_id
where bp.bill_product_id is not null
group by p.name
order by total_earned desc
limit 10;