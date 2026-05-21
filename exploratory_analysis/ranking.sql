/*
Ranking:
------------
Rank [dimension] by [aggregate function] of [measure]

eg: rank countries by total sales
----------------------------------
used window functions to improve useability. 
*/

-- Which 5  products generate the highest revenue?
SELECT 
*
FROM(
	SELECT
		dp.product_name,
		SUM(fs.sales_amount) AS revenue,
		ROW_NUMBER() OVER (ORDER BY SUM(fs.sales_amount) DESC) AS rank
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_products dp
	ON dp.product_key = fs.product_key
	GROUP BY dp.product_name
) t
WHERE rank <= 5
-- What are the 5 worst performing products in terms of sales?

SELECT
	*
FROM(
	SELECT
		dp.product_name,
		SUM(fs.sales_amount) AS revenue,
		ROW_NUMBER () OVER(ORDER BY SUM(fs.sales_amount) ASC) AS rank
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_products dp
	ON dp.product_key = fs.product_key
	GROUP BY dp.product_name)t
WHERE rank <= 5
