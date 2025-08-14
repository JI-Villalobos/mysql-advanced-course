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