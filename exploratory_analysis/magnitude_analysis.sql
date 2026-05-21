/*

Magnitude analysis takes the form of

*Aggregate functions* applied to *measure* grouped by/as per *dimension*

eg: 
total sales by country
*/

-- Total number of customers by country
SELECT
	country,
	COUNT(DISTINCT(customer_key)) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- total customers by gender
SELECT
	gender,
	COUNT(DISTINCT(customer_key)) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- total products by category
SELECT
	category,
	COUNT(DISTINCT(product_key)) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- average cost in each category
SELECT
	category,
	AVG(cost) AS average_cost
FROM gold.dim_products
GROUP BY category
ORDER BY average_cost DESC

-- total revenue for each category
SELECT
	p.category,
	SUM(s.sales_amount) AS revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON p.product_key = s.product_key
GROUP BY category
ORDER BY revenue DESC 

-- total revenue for each customer
SELECT
	customer_id,
	SUM(s.sales_amount) AS revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY customer_id
ORDER BY revenue DESC

-- distribution of sold items across countries

SELECT
	c.country,
	SUM(s.quantity) AS total_sold_items
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC
