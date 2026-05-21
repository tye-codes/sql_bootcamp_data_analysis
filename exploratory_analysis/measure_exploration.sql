/*
High level overview of the aggregated measures available in the data.
*/

-- Find Total Sales, Items sold and average selling price, total orders,
-- total customers and total paying customers
SELECT 
	SUM(s.sales_amount) AS total_sales,
	SUM(s.quantity) AS quantity_sold,
	AVG(s.sales_amount) AS average_price,
	COUNT(DISTINCT(s.order_number)) AS total_orders,
	COUNT(DISTINCT(s.customer_key)) AS total_unique_paying_customers,
	COUNT(DISTINCT(customer_id)) AS total_unique_customers
FROM gold.fact_sales s
FULL JOIN gold.dim_customers c
ON s.customer_key = c.customer_key


-- Find total unique products. 
SELECT
	COUNT(DISTINCT(product_key)) AS total_unique_products
FROM gold.dim_products
-------------------------------------------------

-- Generate a report that shows all key metrics of the business 
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL 
SELECT 'Total Quantity' AS measure_name, SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL 
SELECT 'Average Price' AS measure_name, AVG(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL 
SELECT 'total_orders' AS measure_name, COUNT(DISTINCT(order_number)) AS measure_value FROM gold.fact_sales
UNION ALL 
SELECT 'total_unique_paying_customers' AS measure_name, COUNT(DISTINCT(customer_key)) AS measure_value FROM gold.fact_sales
UNION ALL 
SELECT 'total_unique_customers' AS measure_name, COUNT(DISTINCT(customer_id)) AS measure_value FROM gold.dim_customers
UNION ALL 
SELECT 'total_unique_products' AS measure_name, COUNT(DISTINCT(product_key)) AS measure_value FROM gold.dim_products

