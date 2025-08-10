--a key help us to grant integrity to the data
--a key is a column or a set of columns that uniquely identifies a row in a table


-- an index is a table that stored data in a way that allows for fast retrieval, is ordered by a key
--this results in faster searches, but occupies space  on disk

--how it work we nedd to index a column where we consider the more important queries

--this indexes the column name in the clients table
create index indx_clients_name on clients(name);

--consider this: all primary keys are indexes, but not all indexes are primary keys


--now supose we have a query that searches by name and email and this query is
--executed frequently, we can create a composite index on both columns
--important to note that the order of columns in a composite index matters
create index indx_clients_name_email on clients(name, email);

--notice the use of desc keyword to create a descending index
--this is useful for queries that order by this column in descending order
--useful in this case because we often query most recent clients
create index indx_clients_created on clients(created_at desc);
