select * from customers;
select * from orders;

-- Joins: Used to combine two or more columns based on common column
-- Inner Join: It returns matching records from both the tables
select * from customers as c
inner join orders as o
on c.customer_id=o.customer_id;

/*left join: It returns everything from left table and matching info from
right table if no matching returns a null*/
select * from customers as c
left join orders as o
on c.customer_id=o.customer_id;

/*right join : It returns everything from right table and matching info from 
left table if no matching returns null*/
select * from customers as c
right join orders as o
on c.customer_id=o.customer_id;

/* Full joins: It returns all matching and non matching rows*/
select * from customers as c
full join orders as o
on c.customer_id=o.customer_id;

/* find all customers who have placed orders related to Technology*/
select * from customers as c
inner join orders as o
on c.customer_id=o.customer_id
where category='Technology';

/*find all the customers and orders placed from west region*/
select * from customers as c
inner join orders as o
on c.customer_id=o.customer_id
where region='West';

/* find all the customers and order details for the orders that are 
placed from East or West*/
select * from customers as c
inner join orders as o
on c.customer_id=o.customer_id
where region in ('East','West');


/* find all the customers and orders placed related to West and chairs*/
select * from customers as c
inner join orders as o
on c.customer_id=o.customer_id
where region='West' and sub_category='Chairs';


/* find top 5 customers and order details where sales is highest*/
select * from customers as c
inner join orders as o
on c.customer_id=o.customer_id
order by sales desc limit 5;


/* find max sales*/
select max(sales) from customers as c
inner join orders as o
on c.customer_id=o.customer_id;

/* find maximum sales w.r.t each region*/
select region, max(sales) from customers as c
inner join orders as o
on c.customer_id=o.customer_id group by region;

/* find category wise sum of sales*/

select category, sum(sales) from customers as c
inner join orders as o
on c.customer_id=o.customer_id group by category;

/* find count of orders in every region*/
select region, count(*) from customers as c
inner join orders as o
on c.customer_id=o.customer_id group by region;

-- window functions
-- find which customers is giving first highest sales
with cte as 
(select * , max(sales) over() as max_sales from
customers as c inner join orders as o
on c.customer_id = o.customer_id)
select * from cte where sales=max_sales;


-- find which customers is giving minimum sales
with cte as 
(select * , min(sales) over() as min_sales from
customers as c inner join orders as o
on c.customer_id = o.customer_id)
select * from cte where sales=min_sales;

-- find which customers is giving first highest sales in every region
with cte as 
(select * , max(sales) over(partition by region) as max_sales from
customers as c inner join orders as o
on c.customer_id = o.customer_id)
select * from cte where sales=max_sales;

-- find which customers is giving first min sales in every region
with cte as 
(select * , min(sales) over(partition by region) as min_sales from
customers as c inner join orders as o
on c.customer_id = o.customer_id)
select * from cte where sales=min_sales;


-- find which customer is giving 3rd highest sales
with cte as 
(select * , dense_rank() over(order by sales desc) as dr from
customers as c inner join orders as o
on c.customer_id = o.customer_id)
select * from cte where dr=3;


-- find which customer is giving 2nd highest sales in each category
with cte as 
(select * , dense_rank() over(partition by category order by sales desc) as dr from
customers as c inner join orders as o
on c.customer_id = o.customer_id)
select * from cte where dr=2;


-- find which all customers giving sales more than previous customer

with cte as 
(select * , lag(sales) over( order by order_date asc) as prev_sales from
customers as c inner join orders as o
on c.customer_id = o.customer_id)
select * from cte where sales>prev_sales ;

-- find which all customers giving sales less than next customer
with cte as 
(select * , lead(sales) over( order by order_date asc) as next_sales from
customers as c inner join orders as o
on c.customer_id = o.customer_id)
select * from cte where sales<next_sales ;



with cte1 as
(select *  from
customers as c inner join orders as o
on c.customer_id = o.customer_id),
cte2 as
(select * , lead(sales) over(order by order_date asc) as next_sales
	from cte1)
select * from cte2 where sales<next_sales;



