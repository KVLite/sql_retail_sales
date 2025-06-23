-- SQL Retail Sales Analysis - P1

-- Create the Table
CREATE TABLE retail_sales 
			(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,	
				customer_id	INT,
				gender VARCHAR(15),
				age	INT,
				category VARCHAR(15),	
				quantity INT,	
				price_per_unit FLOAT,
				cogs FLOAT,	
				total_sale  FLOAT
			);

select * from retail_sales
limit 10;

select 
	count (*) 
	from retail_sales;

select * from retail_sales;

-- Data Cleaning

select * from retail_sales
where transactions_id is null; 

select * from retail_sales
where sale_date is null; 

select * from retail_sales
where sale_time is null; 

select * from retail_sales
where customer_id is null; 

select * from retail_sales
where 
	transactions_id is null
	or
    sale_date is null
    or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or 
	total_sale is null;

delete from retail_sales
where 
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;
	
-- Data Exploration

-- How many sales do we have?

SELECT COUNT(*) AS total_sale from retail_sales;  --  total records is 1997

-- How many unique customers do we have?

SELECT COUNT(DISTINCT customer_id) from retail_sales;  -- 155

-- How many unique categories do we have?

SELECT COUNT(DISTINCT category) from retail_sales; 3

-- How many category names do we have?

SELECT DISTINCT category from retail_sales;  -- 3, electronics, clothing, beauty

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the 
-- quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a query, calculate the total sales (total_sale) for each category
-- Q.4 Write query, find the average age of customers who purchased items from the 'Beaty' cartegory
-- Q.5 Write query, find all transactions where the total_sale is greater than 1000
-- Q.6 Write query, find the total number of transactions made by each gender in each category
-- Q.7 Write query, calculate the average sale for each month. find out best selling month in each year
-- Q.8 Write query, find the top 5 customers based on the highest total sales
-- Q.9 Write query, find the number of unique customers who purchased items from each category
-- Q.10 Writ query, create each shift and number of orders (example morning <= 12, afternoon between
-- 12 & 17, evening > 17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * 
FROM  retail_sales 
WHERE sale_date = '2022-11-05';  -- 11 records returned

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the 
-- quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'  -- 17 lines returned
	AND quantity >= 4;

-- Q.3 Write a query, calculate the total sales (total_sale) for each category

SELECT 
	category,
	sum(total_sale) as net_sale 
FROM retail_sales
group by 1;

SELECT 
	category,
	sum(total_sale) as net_sale, 
	count(*) as total_orders
FROM retail_sales
group by 1;

-- Q.4 Write query, find the average age of customers who purchased items from the 'Beaty' category

select * from retail_sales;

SELECT age
from retail_sales;

SELECT *
FROM retail_sales
where category = 'Beauty';

SELECT 
	ROUND(avg(age), 2) as average_age
FROM retail_sales
where category = 'Beauty';


-- Q.5 Write query, find all transactions where the total_sale is greater than 1000

SELECT *
	FROM retail_sales
	WHERE total_sale > 1000;

-- Q.6 Write query, find the total number of transactions made by each gender in each category

SELECT 
	category,
	gender,
	COUNT(*) as total_transactions
FROM retail_sales
group by 1,2
ORDER BY 1;

-- Q.7 Write query, calculate the average sale for each month. find out best selling month in each year

SELECT *
	FROM retail_sales;

SELECT 
	year,
	month,
	ROUND(avg_sale) as average_sale
FROM 
(
SELECT
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1,2
) AS t1
WHERE rank = 1;
--ORDER BY 1, 3 desc;

-- Q.8 Write query, find the top 5 customers based on the highest total sales

SELECT * FROM retail_sales;

SELECT 
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write query, find the number of unique customers who purchased items from each category

SELECT
	(category),
	COUNT(distinct customer_id) as Unique_Customers 
FROM retail_sales
GROUP BY 1;

-- Q.10 Write query, create each shift and number of orders (example morning <= 12, afternoon between 12 & 17, evening > 17)

SELECT * FROM retail_sales;

WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 Then 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift    -- Creates new column called shift stating Morning, Afternoon, or Evening. 
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) as total_orders
	FROM hourly_sale
GROUP BY shift;
	
-- End of project

-- Current time
--SELECT EXTRACT (HOUR FROM CURRENT_TIME);     -- Shows 13, or 1:57pm




