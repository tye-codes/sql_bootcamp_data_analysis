/*
================================================================
Product Report	
================================================================
Purpose:
This report consolidates key product metrics and behaviours.

Highlights: 
	1. Gathers essential fields such as product name, category and subcategory
	2. Segments products by revenue to identify high-performers, mid-range and low
	3. Aggregates product-level metrics:
		- Total orders
		- Total sales
		- Total quantity sold
		- total customers (unique)
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- Recency (months since last order)
		- average order revenue (AOR)
		- average monthly Revenue
================================================================
*/
CREATE VIEW gold.report_products AS
WITH base_query AS(
/* -------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
------------------------------------------------------------- */
SELECT
	fs.order_number,
	fs.order_date,
	fs.sales_amount,
	fs.quantity,
	fs.customer_key,
	dp.product_key,
	dp.product_name,
	dp.category,
	dp.subcategory,
	dp.cost
FROM gold.fact_sales fs
INNER JOIN gold.dim_products dp
ON fs.product_key = dp.product_key),

product_aggregation AS(
/* -------------------------------------------------------------
2) Aggregation Query: Performs aggregations of values
------------------------------------------------------------- */
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	SUM(sales_amount) AS total_sales,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
	MAX(order_date) AS last_sale_date,
	COUNT(DISTINCT(order_number)) AS total_orders,
	COUNT(DISTINCT(customer_key)) AS unique_customers,
	SUM(quantity) AS total_quantity_sold,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity,0)),1) AS avg_selling_price
FROM base_query
GROUP BY 
	product_key,
	product_name,
	category,
	subcategory,
	cost)

/* -------------------------------------------------------------
3) Final Query: Combine all products into one report.
------------------------------------------------------------- */
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	lifespan,
	last_sale_date,
	total_orders,
	unique_customers,
	total_quantity_sold,
	avg_selling_price,
	total_sales,
	CASE 
		WHEN total_sales < 450000 THEN 'Low Performer'
		WHEN total_sales BETWEEN 450000 AND 900000 THEN 'Mid Performer'
		ELSE 'High Performer'
	END AS performance_category,
	-- Average order revenue (AOR)
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales/total_orders
	END AS avg_order_revenue,
	-- Average monthly revenure
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales/lifespan
	END AS avg_monthly_revenue
FROM product_aggregation
