/*
Data segmentation
-------------------
takes the form of 
[measure] by [measure]

total products by sales range
total customers by age...

We categorise the measure, using case when, on the right to create a new measure.
*/

-- Segment products into cost ranges and count how many products fall in each
WITH product_segments AS(
SELECT
	product_key,
	product_name,
	cost,
	CASE WHEN cost < 100 THEN 'Below 100'
		WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
		ELSE 'Above 1000'
	END AS cost_range
FROM gold.dim_products)

SELECT
	COUNT(product_key) AS total_products,
	cost_range
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

/*
Group customers into three segments based on their spending behaviour
- VIP: at least 12months history and spending more than 5k
- regular: customers wiht at least 12months history but spending less than 5k
- New customers: history less than 12months
*/
WITH customer_spending AS (
SELECT
	c.customer_key,
	SUM(f.sales_amount) AS total_spending,
	MIN(order_date) AS first_order,
	MAX(order_date) AS last_order,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM gold.fact_sales f 
LEFT JOIN gold.dim_customers c 
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)

SELECT
	customer_segment,
	COUNT(customer_key) AS total_customers
FROM(
	SELECT
		customer_key,
		CASE WHEN lifespan >= 12 AND total_spending >= 5000 THEN 'VIP'
			WHEN lifespan >= 12 THEN 'Regular Customer'
			ELSE 'New Customer'
		END customer_segment
	FROM customer_spending)t
GROUP BY customer_segment
ORDER BY total_customers DESC
