-- lead and lag
-- lag : Used to compare current value with previous value
-- compare current emp salary with previously joined emp
select empname,salary,prev_sal , salary-prev_sal as sal_diff from 
(select * , lag(salary) over(order by empid asc) as prev_sal from emp_data); 

-- find all the employee who are getting salaries greater than prev emp salary
select empname,salary,prev_sal , salary-prev_sal as sal_diff from 
(select * , lag(salary) over(order by empid asc) as prev_sal from emp_data)
where salary>prev_sal;

-- lead : Lead is used to compare current value with next value

-- compare current saalry with next salary
select * , lead(salary) over(order by empid asc) as next_sal from
emp_data;

-- find sal difference
select empname,salary,next_sal , salary-next_sal as sal_diff from
(select * , lead(salary) over(order by empid asc) as next_sal from
emp_data);

-- find employees who are getting salary less than next joined emp
select empname,salary,next_sal , salary-next_sal as sal_diff from
(select * , lead(salary) over(order by empid asc) as next_sal from
emp_data) where salary < next_sal;
