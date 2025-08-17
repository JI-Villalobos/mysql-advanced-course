--create an user
create user if not exists 'developer'@'%' identified by 'developer_password';
--the use of '%' allows the user to connect from any host

--show users
select Host, User from mysql.user;

--grants privileges to the user
--most used privileges: CREATE, ALTER, DROP, INSERT, UPDATE, DELETE, SELECT, INDEX, REFERENCES, EXECUTE, GRANT

grant create, alter, insert, update, select, references, index on salez_v2.* to 'developer'@'%';