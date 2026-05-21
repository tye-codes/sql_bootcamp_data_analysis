/*
DATEDIFF is a useful tool for finding the difference between dates during exploratory data analysis. 
*/

-- Find the date of the first and last order and how many years of sales available.

SELECT 
	MIN(order_date) first_order_date,
	MAX(order_date) last_order_date,
	DATEDIFF(year, MIN(order_date), MAX(order_date)) order_range_years
FROM gold.fact_sales

-- Find youngest and oldest customers in the data.
SELECT
	DATEDIFF(YEAR, MIN(birthdate), GETDATE()) oldest_age,
	DATEDIFF(YEAR, MAX(birthdate), GETDATE()) youngest_age
FROM gold.dim_customers
