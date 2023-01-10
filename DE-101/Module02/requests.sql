-----------------
-- Total sales --
-----------------

select sum(sales) as sum_sales
from mknn_store_orders;
-- 2297200.8603

------------------
-- Total profit --
------------------

select sum(profit) as sum_profit
from mknn_store_orders;
--286397.0217

------------------
-- Profit ratio --
------------------

select sum(sales) / sum(profit) as profit_ratio
from mknn_store_orders;
--8.0210

----------------------
-- Profit per Order --
----------------------

select 
	order_id,
	sum(profit) as sum_profit
from mknn_store_orders
group by order_id;

------------------------
-- Sales per Customer --
------------------------

select
	customer_id,
	sum(sales) as sum_sales
from mknn_store_orders
group by customer_id;

-------------------
-- Avg. Discount --
-------------------

select
	extract(year from order_date) as year,
	avg(discount) * 100 as avg_discount_pct
from mknn_store_orders
group by year

------------------------------
-- Monthly Sales by Segment --
------------------------------

select 
	segment,
	trim(to_char(order_date, 'Month')) as month,
	extract(year from order_date) as year,
	sum(sales) as sum_sales
from mknn_store_orders mso
group by segment, month, year
order by segment, month, year

---------------------------------------
-- Monthly Sales by Product Category --
---------------------------------------

select 
	category,
	trim(to_char(order_date, 'Month')) as month,
	extract(year from order_date) as year,
	sum(sales) as sum_sales
from mknn_store_orders mso
group by category, month, year
order by category, month, year

----------------------------------
-- Sales and Profit by Customer --
----------------------------------

select
	customer_id,
	sum(sales) as sum_sales,
	sum(profit) as sum_profit
from mknn_store_orders
group by customer_id

----------------------
-- Customer Ranking --
----------------------

select 
	customer_id,
	row_number() over (order by sum(profit) desc) as rank_by_profit,
	sum(sales) as sum_sales,
	sum(profit) as sum_profit
from mknn_store_orders
group by customer_id

----------------------
-- Sales per region --
----------------------

select
	region,
	sum(sales) as sum_sales
from mknn_store_orders
group by region
