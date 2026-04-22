select * from superstore_sales;

-- case: If else concept 
-- Used to create new column based on conditions

-- Create profit_val
-- if profit>0 --> pos_profit
-- if profit<0 --> neg profit
-- if profit =0 --> no_profit

select profit,
case
when profit>0 then 'pos_profit'
when profit<0 then 'neg_profit'
else 'no_profit'
end as profit_val
from superstore_sales;


-- if discount > 0 --> discount_applied else no discount
select discount,
case
when discount>0 then 'discount_applied'
else 'no_discount'
end as discount_status
from superstore_sales;

-- if sales > 700 high sales
-- if sales between 400 to 700 --> avg Sales
-- if less than 400 --> lowe sales

select sales,
case
when sales > 700 then 'high_sales'
when sales between 400 and 700 then 'avg_sales'
when sales<400 then 'low_sales'
end as sales_val
from superstore_sales;