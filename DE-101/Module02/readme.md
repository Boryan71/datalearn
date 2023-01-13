### Overview (обзор ключевых метрик)
  - Total Sales
  ```
  select sum(sales) as sum_sales
  from orders;
  ```
  ![1](./sum_sales.bmp)
  - Total Profit
  ```
  select sum(profit) as sum_profit
  from orders;
  ```
  ![2](./sum_profit.bmp)
  - Profit Ratio
  ```
  select sum(sales) / sum(profit) as profit_ratio
  from orders;
  ```
  ![3](./profit_ratio.bmp)
  - Profit per Order
  ```
  select 
  	order_id,
  	sum(profit) as sum_profit
  from orders
  group by order_id;
  ```
  ![4](./profit_per_order.bmp)
  - Sales per Customer
  ```
  select
	customer_id,
	sum(sales) as sum_sales
  from orders
  group by customer_id;
  ```
  ![5](./sales_per_customer.bmp)
  - Avg. Discount
  ```
  select
	extract(year from order_date) as year,
	avg(discount) * 100 as avg_discount_pct
  from orders
  group by year;
  ```
  ![6](./avg_discount.bmp)
  - Monthly Sales by Segment
  ```
  select 
	segment,
	trim(to_char(order_date, 'Month')) as month,
	extract(year from order_date) as year,
	sum(sales) as sum_sales
  from orders
  group by segment, month, year
  order by segment, month, year;
  ```
  ![7](./monthly_sales_by_segment.bmp)
  - Monthly Sales by Product Category
  ```
  select 
	category,
	trim(to_char(order_date, 'Month')) as month,
	extract(year from order_date) as year,
	sum(sales) as sum_sales
  from orders
  group by category, month, year
  order by category, month, year;
  ```
  ![8](./monthly_sales_by_product_category.bmp)
 ### Customer Analysis
  - Sales and Profit by Customer
  ```
  select
	customer_id,
	sum(sales) as sum_sales,
	sum(profit) as sum_profit
  from orders
  group by customer_id;
  ```
  ![9](./sales_and_profit_by_customer.bmp)
  - Customer Ranking
  ```
  select 
	customer_id,
	row_number() over (order by sum(profit) desc) as rank_by_profit,
	sum(sales) as sum_sales,
	sum(profit) as sum_profit
  from orders
  group by customer_id;
  ```
  ![10](./rank_by_profit.bmp)
  - Sales per region
  ```
  select
	region,
	sum(sales) as sum_sales
  from orders
  group by region;
  ```
  ![11](./sales_per_region.bmp)