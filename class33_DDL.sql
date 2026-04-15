-- create database Students
create database students;

-- drop student database
drop database students;

-- create table
create table employee
(empid int primary key ,
 empname varchar(30) not null,
 exp int ,
 company varchar(20),
 salary int,
 country varchar(20) default 'India',
 age int check (age>18));

select * from employee;

-- ALter 
-- Add new columns
-- add address column
Alter table employee
add column address varchar(100);
-- add col1 ,col2
Alter table employee
add column col1 int ,
add column col2 int;

-- drop address
Alter table employee
drop column address;

-- drop col1,col2
Alter table  employee
drop column col1,drop column col2;

-- rename exp as emp_exp
Alter table employee
	rename exp to emp_exp;

-- change data type of empname to varchar(100)
Alter table employee
	alter column empname type varchar(100);

-- change table name
Alter table employee rename to emp_details;

--delete the table
drop table emp_details;

select * from emp_details;
