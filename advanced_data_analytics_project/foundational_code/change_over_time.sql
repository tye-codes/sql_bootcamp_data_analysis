/*
Change over time analysis
--------------------------
Format is:
[aggregate function] of [measure] by [date dimension]
eg:
avg sales by month
*/

-- Show the change over time analysis on a monthly basis. 
SELECT 
	DATETRUNC(month, order_date) AS order_date,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT(customer_key)) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)
