-- DQL: Data Query Language
-- select : used to fetch entire data or subset of data
select * from superstore_sales;

-- fetch sales,city,region profit,category
select sales,city,region,profit,category from superstore_sales;

-- distinct : used find unique values in a column

-- find unique region
select distinct region from superstore_sales;

-- find unique category
select distinct category from superstore_sales;
-- find unique sub_category
select distinct sub_category from superstore_sales;

-- find unique values in region and category
select distinct(region,category) from superstore_sales;

-- Where : fetch data based on conditions
-- comparison operators: used to fetch data based on single condition
-- =,>,<,<=,>=,!=
-- Find all the order placed from West region
select * from superstore_sales where region='West';

-- find all the orders which are not related to Technology
select * from superstore_sales where category!='Technology';

-- find all the orders where profit is negative
select * from superstore_sales where profit<0;

-- find all the orders where quantity is more than 7
select * from superstore_sales where quantity>7;

-- Logical operators : used to fetch data based on multiple conditions
-- and , or ,not
-- and : If both condition are True it returns the rows
-- find all the orders placed from West where profit is negative
select * from superstore_sales where
region ='West' and profit<0;

/*find all the orders placed from Technology
where quantity is greatre than 5*/
select * from superstore_sales
where category='Technology' and quantity > 5;

--or: it returns rows if either of the condition is True
-- find all the orders placed from either East or West
select * from superstore_sales where region='East' or region='West';

-- find all the orders related to Phones , Tables , Chairs
select * from superstore_sales
where sub_category = 'Phones' or 
	sub_category='Tables' or sub_category='Chairs';

-- not : returns opposite to condition
-- fetch all the orders except from West region
select * from superstore_sales
where not region='West';

-- in : multiple or conditions
-- find all the orders placed from East,West , South
select * from superstore_sales
where region in ('East','West','South');


-- find all the orders related to Phones,Art,Tables,Binders
select * from superstore_sales
where sub_category in ('Phones','Art','Tables','Binders');


-- Between : Used fetch data based on range of values

-- find all the orders placed in the year 2023

select * from superstore_sales
where order_date between '2023-01-01' and '2023-12-31';

-- find all the order placed between jan 2024 to march 2024
select * from superstore_sales
where order_date between '2024-01-01' and '2024-03-31';


--order by : Used to sort data in increasing or decreasing order
-- sort data in increasing order of sales

select * from superstore_sales order by sales asc;

-- sort data in decreasing order of sales
select * from superstore_sales order by sales desc;

-- limit : Used to limit the number of rows
-- fetch first 5 rows
select * from superstore_sales limit 5;

-- find top 5 orders which are giving highest sales
select * from superstore_sales order by sales desc  limit 5;


-- find bottom 3 orders where profit is less
select * from superstore_sales order by profit asc limit 3;

-- find top 5 orders related to Phones where sales is highest
select * from superstore_sales where sub_category='Phones'
order by sales desc limit 5;


