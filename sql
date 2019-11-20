-- For each country calculate the total spending for each customer, and 
-- include a column (called 'difference') showing how much more each customer 
-- spent compared to the next highest spender in that country. 
-- For the 'difference' column, fill any nulls with zero.
-- ROUND your all of your results to the next penny.

-- hints: 
-- keywords to google - lead, lag, coalesce
-- If rounding isn't working: 
-- https://stackoverflow.com/questions/13113096/how-to-round-an-average-to-2-decimal-places-in-postgresql/20934099

WITH customer_info AS (SELECT customers.customer_id, customers.country, order_details.unit_price * order_details.quantity as total  
FROM customers inner join orders on customers.customer_id = orders.customer_id
inner join order_details on order_details.order_id = orders.order_id 
inner join products on products.product_id = order_details.product_id),



product_totals_country AS (
SELECT customer_id, country, sum(total) as total_sum
FROM customer_info
GROUP BY country, customer_id
ORDER BY country desc

),

sums AS (SELECT customer_id, country, total_sum, lead(total_sum, 1) over (partition by country order by country, total_sum desc) previous, lag(total_sum, 1) over (partition by country order by country, total_sum) difference 
		 FROM product_totals_country)

SELECT * from sums;