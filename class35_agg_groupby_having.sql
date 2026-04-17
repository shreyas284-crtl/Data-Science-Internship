select * from superstore_sales;

/* Aggregate function: used for analysis which
aggregates all values in column to single value
- min
- max
- sum
- avg
- count */
-- Find sum of sales
select sum(sales) as sum_sales from superstore_sales;

-- find max sales
select max(sales) as max_sales from superstore_sales;

-- find min sales
select min(sales) as min_sales from superstore_sales;

-- find avg sales
select avg(sales) as avg_sales from superstore_sales;

-- find count of orders
select count(*) as total_orders from superstore_sales;

select sum(profit),max(profit),min(profit),avg(profit),count(*)
from superstore_sales;

-- find sum of sales from West region
select sum(sales) as sum_of_sales from superstore_sales
where region='West';


-- find avg sales related to Phones and Technology
select avg(sales) as avg_of_sales from superstore_sales
where category='Technology' and sub_category='Phones';

-- find total orders from East,West and South
select count(*) as total_orders from superstore_sales
where region in ('East','West','South');


-- Group by: Grouping data and finding aggregates
-- Find sum of sales in each region
-- group by :region
-- sum : sales
select region,sum(sales) from superstore_sales
group by region;

-- Having : Used to filter data of group by result
-- find regions where sum of sales is greater than 60000

select region,sum(sales) from superstore_sales
group by region having sum(sales)>60000;

-- find max sales in each category

select category , max(sales)
from superstore_sales group by category;

-- find categories which has max sales less than 990
select category , max(sales)
from superstore_sales group by category having 
	max(sales)<990;

-- find total orders w.r.t evry sub_category
select sub_category,count(*) from superstore_sales
group by sub_category;


-- find all subcategories where orders are greater than 70
select sub_category,count(*) from superstore_sales
group by sub_category having count(*)>70;


-- find max sales ,min sales, count of orders w.r.t each catgeory
select category , max(sales),min(sales),count(*) from 
superstore_sales group by category;


-- find sum of sales , avg sales  w.r.t each region and category
select region,category , sum(sales),avg(sales)
from superstore_sales
group by region,category;


-- find top 5 subcategories which has count of orders is high

select sub_category,count(*) from superstore_sales
group by sub_category order by count(*) desc limit 5;


-- find bottom 5 states where sum of sales in minimum
select state,sum(sales) from superstore_sales
group by state order by sum(sales) asc limit 5;







