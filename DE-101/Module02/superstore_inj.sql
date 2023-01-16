-- ************************************************** Измерение "Календарь"

insert into store_dim_calendar(
	order_date,
	ship_date,
	year,
	quarter,
	month,
	week,
	week_day) 
select 
	distinct(mso.order_date) as order_date,
	mso2.ship_date as ship_date,
	cast(extract(year from mso.order_date) as integer) as year,
	cast(extract(quarter from mso.order_date) as integer) as quarter,
	cast(extract(month from mso.order_date) as integer) as month,
	cast(extract(week from mso.order_date) as integer) as week,
	cast(extract(isodow from mso.order_date) as integer) as week_day
from store_orders mso
left join store_orders mso2
	on mso.row_id = mso2.row_id
order by order_date asc


-- ************************************************** Измерение "География"

insert into store_dim_geography (geo_id, country, city, state, region, postal_code)
select
	100+row_number() over () as geo_id,
	country,
	city, 
	state,
	region,
	case
		when postal_code is null and 
			 city = 'Burlington' and 
			 state = 'Vermont' -- В источнике заказы в данный штат и город не имеют почтового индекса.
		then 05401
		else postal_code
	end as postal_code
from (select 
		distinct(country),
		city, 
		state,
		region,
		postal_code
	from store_orders mso
	order by 3, 2) t2
	
-- ************************************************** Измерение "Перевозка"

insert into mknn_store_dim_shipping
select
	100+row_number() over (),
	ship_mode
from (select distinct(ship_mode) from mknn_store_orders mso order by 1) t1

-- ************************************************** Измерение "Покупатель"

insert into mknn_store_dim_customer(customer_id, customer_name, segment)
select
	distinct(customer_id),
	customer_name,
	segment
from mknn_store_orders order by 1

-- ************************************************** Измерение "Продукт"

insert into mknn_store_dim_product(product_id, category, sub_category, product_name)
select 
	distinct(product_id),
	category,
	sub_category,
	product_name
from mknn_store_orders mso 
order by 1

-- ************************************************** Измерение "Продажи"
НЕ РАБОТАЕТ, НУЖНО ПОПРАВИТЬ!
insert into mknn_store_fact_sales (row_id, order_id, customer_id, ship_id, order_date, geo_id, ship_date, product_id, sales, quantity, discount, profit)
select
	row_id,
	order_id,
	customer_id,
	ship_id,
	order_date,
	geo_id,
	ship_date,
	product_id,
	sales,
	quantity,
	discount,
	profit
from mknn_store_orders mso
inner join mknn_store_dim_shipping msds
	on mso.ship_mode = msds.ship_mode
inner join mknn_store_dim_geography msdg
	on (mso.country = msdg.country and
	mso.city = msdg.city and
	mso.state =  msdg.state and 
	mso.region = msdg.region and
	mso.postal_code = msdg.postal_code) --этим иннером мы выкинули тот город и штат, где не указан почтовый индекс. Нужно исправить начальный ddl, удалить все констрейнты и загрзуить данные заново.
	or (msdg.postal_code = 05401 and mso.postal_code is null) -- этим мы вернули города, но это явный костыль!