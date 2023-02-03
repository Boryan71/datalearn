# Модуль 2: Базы данных и SQL

Одним из заданий данного модуля является установка базы Postgres к себе на компьютер. Мне повезло, у меня есть доступ к серверу на котором уже крутится БД, в которую я могу писать свои данные, поэтому я сразу [*создал таблицу orders и загрузил в нее данные Superstore*](./stg_orders.sql).

*Однако до этого я уже поднимал локально MySQL, так что этот шаг я пропустил осознанно.*

## 2.3 Overview (обзор ключевых метрик)

Расчет показателей из Модуля 1.

  - Total Sales
  ```sql
  select sum(sales) as sum_sales
  from orders;
  ```
  ![1](./pics/sum_sales.bmp)
  - Total Profit
  ```sql
  select sum(profit) as sum_profit
  from orders;
  ```
  ![2](./pics/sum_profit.bmp)
  - Profit Ratio
  ```sql
  select sum(sales) / sum(profit) as profit_ratio
  from orders;
  ```
  ![3](./pics/profit_ratio.bmp)
  - Profit per Order
  ```sql
  select 
  	order_id,
  	sum(profit) as sum_profit
  from orders
  group by order_id;
  ```
  ![4](./pics/profit_per_order.bmp)
  - Sales per Customer
  ```sql
  select
	customer_id,
	sum(sales) as sum_sales
  from orders
  group by customer_id;
  ```
  ![5](./pics/sales_per_customer.bmp)
  - Avg. Discount
  ```sql
  select
	extract(year from order_date) as year,
	avg(discount) * 100 as avg_discount_pct
  from orders
  group by year;
  ```
  ![6](./pics/avg_discount.bmp)
  - Monthly Sales by Segment
  ```sql
  select 
	segment,
	trim(to_char(order_date, 'Month')) as month,
	extract(year from order_date) as year,
	sum(sales) as sum_sales
  from orders
  group by segment, month, year
  order by segment, month, year;
  ```
  ![7](./pics/monthly_sales_by_segment.bmp)
  - Monthly Sales by Product Category
  ```sql
  select 
	category,
	trim(to_char(order_date, 'Month')) as month,
	extract(year from order_date) as year,
	sum(sales) as sum_sales
  from orders
  group by category, month, year
  order by category, month, year;
  ```
  ![8](./pics/monthly_sales_by_product_category.bmp)
 ### Customer Analysis
  - Sales and Profit by Customer
  ```sql
  select
	customer_id,
	sum(sales) as sum_sales,
	sum(profit) as sum_profit
  from orders
  group by customer_id;
  ```
  ![9](./pics/sales_and_profit_by_customer.bmp)
  - Customer Ranking
  ```sql
  select 
	customer_id,
	row_number() over (order by sum(profit) desc) as rank_by_profit,
	sum(sales) as sum_sales,
	sum(profit) as sum_profit
  from orders
  group by customer_id;
  ```
  ![10](./pics/rank_by_profit.bmp)
  - Sales per region
  ```sql
  select
	region,
	sum(sales) as sum_sales
  from orders
  group by region;
  ```
  ![11](./pics/sales_per_region.bmp)

## 2.4 Физическая модель данных

С помощью сервиса Sqldbm нарисовал модель данных:

![star_model](./pics/star_model.bmp)

## 2.5 База данных в облаке

Так как в данный момент AWS и GCP недоступны для пользователей из России, изучил информацию по Yandex.Cloud, однако решил пока не разворачивать облачное хранилище, буду пользоваться удаленным сервером (в принципе чем не облако🤔).

[Создал таблицы по приведенной выше модели и наполнил их данными](./dwh.sql)

## 2.6 
