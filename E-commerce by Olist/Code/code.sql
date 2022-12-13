--Top 5 products sold?
with b1 as (select product_category_name, count(1) as total_sale_figure
			from products
			group by 1),
	b2 as (select *,
		  dense_rank() over(order by total_sale_figure desc) as rnk
		  from b1)
select product_category_name, total_sale_figure from b2
where rnk <= 5 order by total_sale_figure desc;


-- Top 5 products returned the most revenue?
select p.product_category_name, cast(sum(ot.price) as money) Revenue
from products p
inner join order_items ot on ot.product_id = p.product_id  
group by 1 order by Revenue desc limit 5;


--Customers' cities where products were sold the most
with b1 as (select c.customer_city, count(1) as total
			from customers c
			join orders o on c.customer_id = o.customer_id
			join order_items oi on o.order_id = oi.order_id
			join products p on oi.product_id = p.product_id
			where product_category_name in ('cama_mesa_banho','esporte_lazer',
					   'moveis_decoracao','beleza_saude',
					   'utilidades_domesticas')
			group by 1 order by total desc),
	b2 as (select *, dense_rank() over(order by total desc) as rnk from b1)
select customer_city from b2 where rnk <= 5;

-- Sellers' cities where products were bought the most?
select seller_city, count(1) total
from sellers sell
join order_items oi on oi.seller_id = sell.seller_id
join products p on p.product_id = oi.product_id
where product_category_name in ('cama_mesa_banho','esporte_lazer',
					   'moveis_decoracao','beleza_saude',
					   'utilidades_domesticas')
group by 1 order by total desc;

-- Find out delivery time slot?
Select order_purchase_timestamp, order_approved_at,
case when extract (day from order_estimated_delivery_date - order_delivered_customer_date) >0
then 'Early'
else 'Late_delivery'
end as Delivery_status
from orders where order_delivered_customer_date is not null; 

-- Total amount of each type of payment?
select payment_type, cast(sum(payment_value) as money) total
from order_payments
group by 1 order by total desc;

-- Total sales during 3 years
select extract(year from o.order_purchase_timestamp) year_sale,
cast(sum(ot.price) as money) total_sale
from order_items ot
join orders o on ot.order_id = o.order_id
group by 1 order by 1 desc;

	
	