/*
================================================================
Customer Report
================================================================
Purpose:
This report consolidates key customer metrics and behaviours.

Highlights: 
	1. Gathers essential fields such as name and age.
	2. Segments customers into segments (VIP, regular, new) and age groups
	3. Aggregates customer-level metrics:
		- Total orders
		- Total sales
		- Total quantity purchased
		- total products
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- Recency (months since last order)
		- average order value
		- average monthly spend
================================================================
*/
CREATE VIEW gold.report_customers AS
WITH base_query AS(
/* -------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
------------------------------------------------------------- */
SELECT
	fs.order_number,
	fs.product_key,
	fs.order_date,
	fs.sales_amount,
	fs.quantity,
	dc.customer_key,
	dc.customer_number,
	CONCAT(dc.first_name, ' ', dc.last_name) AS customer_name,
	DATEDIFF(year, dc.birthdate, GETDATE()) AS age
FROM gold.fact_sales fs
INNER JOIN gold.dim_customers dc
ON fs.customer_key = dc.customer_key
),

customer_aggregation AS(
/* -------------------------------------------------------------
2) Aggregation Query: Aggregates key values.
------------------------------------------------------------- */
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT(order_number)) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT(product_key)) AS total_unique_products,
	MAX(order_date) AS last_order_date,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	age)

/* -------------------------------------------------------------
3) Final Query: Collects all customer information into one table.
------------------------------------------------------------- */
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE 
		WHEN age < 20 THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 49 THEN '20-49'
		WHEN age BETWEEN 50 AND 69 THEN '50-69'
		WHEN age BETWEEN 70 AND 89 THEN '70-89'
		ELSE '90 and over'
	END AS age_segment,
	CASE 
		WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan >= 12 THEN 'Regular Customer'
		ELSE 'New Customer'
	END AS customer_segment,
	total_orders,
	total_sales,
	total_quantity,
	total_unique_products,
	last_order_date,
	lifespan,
	DATEDIFF(month, last_order_date, GETDATE()) AS recency,
	-- Compute average order value (AOV)
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE total_sales/total_orders 
	END AS avg_order_value,
	-- Compute average monthly spend
	CASE 
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales/lifespan
	END AS avg_monthly_spend
FROM customer_aggregation
