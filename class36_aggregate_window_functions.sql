select * from emp_data;

-- window aggregate functions
-- find max salary
select max(salary) from emp_data;

select *,max(salary) over() as max_salary from emp_data;


-- find which employee getting first highest salary
select * from 
(select *,max(salary) over() as max_salary from emp_data) 
 where salary = max_salary 	;

-- CTE : Common table Expression
with cte as
(select *,max(salary) over() as max_salary from emp_data) 
select * from cte where salary = max_salary;

-- find which employee is getting min salary
select * from 
(select * ,min(salary) over() as min_salary from emp_data)
	where salary = min_salary;

-- cte
with cte as
(select * ,min(salary) over() as min_salary from emp_data)
select * from cte where salary=min_salary;


-- find all the employees whose salaries are greater than average salary
select * from 
(select * , avg(salary) over() avg_salary from emp_data)
	where salary >avg_salary;

with cte as
(select * , avg(salary) over() avg_salary from emp_data)
select * from cte where salary>avg_salary;


-- find which is getting first highest salary in each department
select * from 
(select * , max(salary) over(partition by department)
	as max_salary from emp_data)
where salary = max_salary;


with cte as
(select * , max(salary) over(partition by department)
	as max_salary from emp_data)
select * from cte where salary=max_salary;


-- find which employees are getting min salary in each department
select * from 
(select * , min(salary) over(partition by department)
	as min_salary from emp_data)
where salary = min_salary;


with cte as
(select * , min(salary) over(partition by department)
	as min_salary from emp_data)
select * from cte where salary=min_salary;


/* find all the department and employees where count of employees
is less than 4*/
select * from 
(select * , count(*) over(partition by department) as emp_count from
emp_data)
	where emp_count<4;

with cte as
(select * , count(*) over(partition by department) as emp_count from
emp_data)
select * from cte where emp_count<4;
