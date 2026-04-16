-- DML : Data Manipulation Language
-- insert
-- update
-- delete
-- truncate


create table emp
(empid int primary key,
	empname varchar(100),
	exp int , company varchar(20),
	salary int , age int check(age>18),
	country varchar(30) default 'India');
select * from emp;
-- insert: used to insert values
insert into emp values
(101,'John',3,'IBM',50000,25,'India');


insert into emp values
(102,'Rohan',2,'IBM',30000,24,'India'),
(103,'Mary',5,'Google',80000,28,'India'),
	(104,'Rahul',10,'Amazon',90000,35,'India'),
	(105,'Zara',5,'IBM',70000,30,'India'),
	(106,'Riya',7,'TCS',80000,32,'India');

select * from emp;

insert into emp(empid,empname,age)
values(107,'Ridaa',25);

insert into emp(empid,empname)
values(108,'Riyaan');

-- update: change the value

-- update age of Ridaa as 24
update emp  
set age = 24 where empid=107;

-- update exp=3 ,company=IBM , salary = 50000,age=27 at Riyaan
update emp
set exp=3,company='IBM',salary=5000,age=27 where empid=108;

-- update salary of Ridaa and Riya as 90000
update emp
set salary = 90000 where empid in (106,107);

-- delete : used to delete the row
-- delete record related tp Riyaan
delete from emp
	where empid=108;

-- delete Riyaa and Ridaa record

delete from emp
	where empid in (106,107);

select * from emp;

-- truncate:remove all the row
truncate emp;