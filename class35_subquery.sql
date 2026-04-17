-- sub query : Query inside another query

-- Outer query + operator + inner query

-- find max sales;
select max(sales) from superstore_sales;

-- find which customer is giving maximum sales
select customer_name,sales  from superstore_sales
where sales = (select max(sales) from superstore_sales);

-- find which customer is giving minimum sales
select * from superstore_sales
where sales = (select min(sales) from superstore_sales);

-- find all the customers who are getting sales greater than avg_ sales
select * from superstore_sales
where sales > (select avg(sales) from superstore_sales);


-- find all the customers who has given max sales in each region
select * from superstore_sales
	where (region,sales) in
(select region,max(sales) from superstore_sales
group by region);

-- find all the customers who ha sgiven min sales in each region

select * from superstore_sales
	where (region,sales) in
(select region,min(sales) from superstore_sales
group by region);

-- find all the customers where sales is maximum in each sub_category

select * from superstore_sales
where (sub_category,sales) in 
(select sub_category,max(sales) from superstore_sales
	group by sub_category);

-- find all customers except those who are giving highest sales

select * from superstore_sales
where sales != (select max(sales) from superstore_sales);

-- find all the customers in west region who have not given highest sales
select * from superstore_sales
where (region,sales) not in 
(select region,max(sales) from superstore_sales
	group by region);


-- find the customer who is giving max sales in west region
select * from superstore_sales where region='West' and sales =
(select max(sales) from superstore_sales where region='West');


-- find which customer is giving max sales in Phones and Chairs
select * from superstore_sales where
sub_category in ('Phones','Chairs') and sales =
(select max(sales) from superstore_sales where sub_category in ('Phones','Chairs'))
