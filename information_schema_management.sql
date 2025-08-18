--inforation_schema is a table that contains information about all other tables in the database.
use information_schema;
show tables;

--information_schema contains metadata about the database, such as table names, column names, data types, and more.
--it is not a regular table, so you cannot insert, update or delete data from it
--one table that brings a lot of useful information is the TABLES table
desc table;

--result
-----------------+--------------------------------------------------------------------+------+-----+---------+-------+
| Field           | Type                                                               | Null | Key | Default | Extra |
+-----------------+--------------------------------------------------------------------+------+-----+---------+-------+
| TABLE_CATALOG   | varchar(64)                                                        | NO   |     | NULL    |       |
| TABLE_SCHEMA    | varchar(64)                                                        | NO   |     | NULL    |       |
| TABLE_NAME      | varchar(64)                                                        | NO   |     | NULL    |       |
| TABLE_TYPE      | enum('BASE TABLE','VIEW','SYSTEM VIEW')                            | NO   |     | NULL    |       |
| ENGINE          | varchar(64)                                                        | YES  |     | NULL    |       |
| VERSION         | int                                                                | YES  |     | NULL    |       |
| ROW_FORMAT      | enum('Fixed','Dynamic','Compressed','Redundant','Compact','Paged') | YES  |     | NULL    |       |
| TABLE_ROWS      | bigint unsigned                                                    | YES  |     | NULL    |       |
| AVG_ROW_LENGTH  | bigint unsigned                                                    | YES  |     | NULL    |       |
| DATA_LENGTH     | bigint unsigned                                                    | YES  |     | NULL    |       |
| MAX_DATA_LENGTH | bigint unsigned                                                    | YES  |     | NULL    |       |
| INDEX_LENGTH    | bigint unsigned                                                    | YES  |     | NULL    |       |
| DATA_FREE       | bigint unsigned                                                    | YES  |     | NULL    |       |
| AUTO_INCREMENT  | bigint unsigned                                                    | YES  |     | NULL    |       |
| CREATE_TIME     | timestamp                                                          | NO   |     | NULL    |       |
| UPDATE_TIME     | datetime                                                           | YES  |     | NULL    |       |
| CHECK_TIME      | datetime                                                           | YES  |     | NULL    |       |
| TABLE_COLLATION | varchar(64)                                                        | YES  |     | NULL    |       |
| CHECKSUM        | bigint                                                             | YES  |     | NULL    |       |
| CREATE_OPTIONS  | varchar(256)                                                       | YES  |     | NULL    |       |
| TABLE_COMMENT   | text                                                               | YES  |     | NULL    |       |
+-----------------+--------------------------------------------------------------------+------+-----+---------+-------+
--you can use this table to get information about the tables in your database
--for example, to get the number of rows in a table, you can use the TABLE_ROWS column
--to get the size of a table, you can use the DATA_LENGTH and INDEX_LENGTH columns
--to get the creation time of a table, you can use the CREATE_TIME column etc..

--for our example what contains information_schema ?
select TABLE_NAME, TABLE_TYPE, ENGINE, ROW_FORMAT, TABLE_ROWS, AVG_ROW_LENGTH, DATA_LENGTH from information_schema.tables where TABLE_SCHEMA = 'sales_v2';


--DATA_LENGTH and AVG_ROW_LENGTH results are in bytes, so you can convert them to KB or MB if you want
select 
  TABLE_NAME, TABLE_TYPE, ENGINE, TABLE_ROWS, 
  AVG_ROW_LENGTH / 1024 as avg_row_length_kb, 
  DATA_LENGTH / pow(1024, 2) as data_length_mb,
  INDEX_LENGTH / pow(1024, 2) as index_length_mb
from information_schema.tables 
  where TABLE_SCHEMA = 'sales_v2';


--we can create a view to get the information we need
create view db_status as (
  select 
    TABLE_NAME, TABLE_TYPE, ENGINE, TABLE_ROWS, 
    AVG_ROW_LENGTH / 1024 as avg_row_length_kb, 
    DATA_LENGTH / pow(1024, 2) as data_length_mb,
    INDEX_LENGTH / pow(1024, 2) as index_length_mb
  from information_schema.tables 
    where TABLE_SCHEMA = 'sales_v2'
);