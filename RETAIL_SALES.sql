
CREATE DATABASE Retail_Sales_Analysis_project;


use Retail_Sales_Analysis_project;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10;

SELECT count(*) FROM retail_sales;

-- DATA CLEANING

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
    SET SQL_SAFE_UPDATES=0;
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    

-- DATA EXPLORATION

-- How many sales we have?

SELECT COUNT(*) as total_sale FROM retail_sales;

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;


-- Data Analysis & Business Key Problems & Answers
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the monthof Nov-2022

SELECT 
    *
FROM
    retail_sales
WHERE
    CATEGORY = 'CLOTHING' AND QUANTITY >= 4
        AND SALE_DATE BETWEEN '2022-11-01' AND '2022-11-30';
 
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    CATEGORY,
    SUM(TOTAL_SALE) AS TOTAL_SALES,
    COUNT(*) AS TOTAL_ORDERS
FROM
    RETAIL_SALES
GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
    CATEGORY, AVG(AGE)
FROM
    retail_sales
GROUP BY 1
HAVING CATEGORY = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT 
    *
FROM
    retail_sales
WHERE
    TOTAL_SALE > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    CATEGORY, GENDER, COUNT(*) AS TOTAL_TRANSACTIONS
FROM
    retail_sales
GROUP BY CATEGORY , GENDER
ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH CTE_BEST_SELLING_MONTH AS(

SELECT YEAR(SALE_DATE),
       MONTH(SALE_DATE),
	  AVG(TOTAL_SALE),
	  rank() OVER(PARTITION BY YEAR(SALE_DATE) ORDER BY AVG(TOTAL_SALE) DESC) AS RNK
FROM RETAIL_SALES
GROUP BY YEAR(SALE_DATE),MONTH(SALE_DATE))
SELECT * FROM CTE_BEST_SELLING_MONTH
WHERE RNK=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    CUSTOMER_ID, SUM(TOTAL_SALE) AS TOTAL_SALES
FROM
    RETAIL_SALES
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
    CATEGORY, COUNT(DISTINCT CUSTOMER_ID) AS UNIQUE_CUSTOMERS
FROM
    RETAIL_SALES
GROUP BY CATEGORY;
       
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH HOURLY_SALES AS  (
SELECT * ,
    CASE 
       WHEN hour(SALE_TIME)<=12 THEN "MORNING"
       WHEN HOUR(SALE_TIME) BETWEEN 12 AND 17 THEN "AFTERNOON"
       ELSE "EVENING"
	END AS SHIFT
    FROM RETAIL_SALES
)
SELECT SHIFT,COUNT(*) AS TOTAL_ORDERS
FROM HOURLY_SALES
GROUP BY SHIFT;

