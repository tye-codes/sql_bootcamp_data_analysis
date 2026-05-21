/*
These queries give a high level view of the all tables available in the database and a one step lower view on the columns in those tables. The requirements of the 
data in each column is accesssible through the INFORMATION_SCHEMA.COLUMNS query. 
*/

-- Explore all objects in the database
SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Explore all columns in the database for dim_customers table
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'
