--mysql supports JSON data type
--this allows us to store JSON documents directly in a column
--this is useful for semi-structured data or when the schema may change frequently

--in this example we update products table to include a JSON column
alter table products add column data JSON after price;

update products set data = '{"brand": "pear","hdsize": "40gb"}' where product_id = 10;

--what types of data we can store on a json column:
--{key, value}
--[value1, value2, value3]

--this set or array can contain:
--strings
--number
--floating(except if we need decimal prescition)
--null
--true, false

--update 
update products set data = JSON_REPLACE(data, '$.brand', 'apple') where product_id = 10;

--JSON operations
--JSON_EXTRACT: extract data from a JSON document
--JSON_SET: set a value in a JSON document
--JSON_ARRAY: create a JSON array
--JSON_OBJECT: create a JSON object
--JSON_MERGE: merge two JSON documents
--JSON_CONTAINS: check if a JSON document contains a value
--JSON_ARRAY_APPEND: append a value to a JSON array
--JSON_ARRAY_INSERT: insert a value into a JSON array at a specific position
--JSON_UNQUOTE: remove quotes from a JSON string
--JSON_KEYS: get the keys of a JSON object
--JSON_LENGTH: get the length of a JSON array or object 
--JSON_SEARCH: search for a value in a JSON document
--JSON_PRETTY: format a JSON document for readability
--JSON_REMOVE: remove a key or value from a JSON document
--JSON_TABLE: create a table from a JSON document
--JSON_CONTAINS_PATH: check if a JSON document contains a specific path
--JSON_TYPE: get the type of a value in a JSON document
--...etc.


--before search and manipulate json data we´ll generate data on products table
update products set data = '{"brand": "apple","hdsize": "40gb", "warranty": false}' where random() < 0.4;

--find all touples with brand pear
select * from products 
where JSON_EXTRACT(data, '$.brand') = 'pear'
limit 10;

--whe can get data from a JSON column extracting the value a s mysql string pr my sql number
--usefull if we need operate with the data
-- select data ->>'$.brand', .....rest of the query
--or data->>'$.brand.founder' or data->>'$.brand'->>'$.founder'(for older versions)  if the values has another json object inside
update products set data = '{"brand": {"founder": "S.P William", "year": 1950},"hdsize": "40gb", "warranty": false}' where product_id = 10;

select data->>'$.brand.founder' as founder, JSON_EXTRACT(data, '$.hdsize') from products 
where product_id = 12
limit 10;

--we can index a JSON column to speed up queries
--but we can create a virtual column that extracts a value from the JSON document and index that column
alter table products add column json_brand varchar(30) as (data->>'$.brand');

--in many scenarios we can´t have a table with null values
--an aproach is to use a default value for the virtual column taht we use to index the json data
alter table products add column json_brand varchar(30) as (ifnull(data->>'$.brand', 'empty'));
--now we can index the virtual column
create index idx_json_brand on products (json_brand);

delete from products where product_id = 12;