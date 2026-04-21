-- ranking window functions
-- row number
-- dense rank
-- rank

-- row number : Assigns unique values to each row
-- Use row number when no repeatative values
/*
salary| row number
90000 | 1 
80000 | 2
80000 | 3
70000 | 4
60000 | 5
60000 | 6
60000 | 7
50000 | 8
*/

-- dense rank : gives same rank for repeated ones and continues
/*
salary| dense_rank
90000 | 1 
80000 | 2
80000 | 2
70000 | 3
60000 | 4
60000 | 4
60000 | 4
50000 | 5
*/

-- rank : gives same rank for repeated ones but skips the continuity
/*
salary| rank
90000 | 1 
80000 | 2
80000 | 2
70000 | 4
60000 | 5
60000 | 5
60000 | 5
50000 | 8
*/



-- find which employee is getting 2nd highest salary
select * from 
(select * , row_number() over(order by salary desc) as rn from
emp_data)
where rn=2;

with cte as 
(select * , row_number() over(order by salary desc) as rn from
emp_data) 
select * from cte where rn=2;

-- find which employee is getting 5th highest salary using dense_rank
select * from 
(select * , dense_rank() over(order by salary desc) as dr from
emp_data)
where dr=5;

with cte as 
(select * , dense_rank() over(order by salary desc) as dr from
emp_data) 
select * from cte where dr=5;


select * from 
(select * , rank() over(order by salary desc) as r from
emp_data)
where r=5;

with cte as 
(select * , rank() over(order by salary desc) as r from
emp_data) 
select * from cte where r=5;

-- find which employee is getting 3rd minimum salary using dense rank
select * from 
(select * , dense_rank() over(order by salary asc) as dr from
emp_data)
where dr=3;

with cte as 
(select * , dense_rank() over(order by salary asc) as dr from
emp_data) 
select * from cte where dr=3;


-- find which employee is geting 2nd highest salary in each dept
select * from
(select * , dense_rank()over(partition by department order by salary desc)
as dr from emp_data)
where dr=2;

-- find which employee is getting 3rd minimum slaary in each dept
select * from
(select * , dense_rank()over(partition by department order by salary asc)
as dr from emp_data)
where dr=3;