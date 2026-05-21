/* 
SELECT DISTINCT is useful for giving a high-level overview of the dimensions available in the data.
*/

-- Explore all countries where customers come from

SELECT DISTINCT country FROM gold.dim_customers;

-- Explore all categories 
SELECT DISTINCT category, subcategory, product_name FROM gold.dim_products
ORDER BY 1, 2, 3;
