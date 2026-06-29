-- Databricks notebook source
--Specifying the data base and the schema to be used
USE brightcoffee.shop;


---Previewing data sets
SELECT *
FROM bright_coffee_shop_sales;


---Find rows that contains Nulls
SELECT *
FROM bright_coffee_shop_sales
WHERE transaction_id IS NULL
   OR transaction_time IS NULL
   OR transaction_qty IS NULL
   OR transaction_date IS NULL
   OR unit_price IS NULL
   OR store_id IS NULL
   OR store_location IS NULL
   OR product_id IS NULL
   OR product_category IS NULL
   OR product_detail IS NULL
   OR product_type IS NULL;

---Count the number of rows
SELECT COUNT(*) AS total_rows
FROM bright_coffee_shop_sales; 

---checking for duplicates in the transaction_id column and counting the rows
SELECT COUNT(transaction_id) AS trans_id_count,
       COUNT(DISTINCT transaction_id) AS trans_id_count
FROM bright_coffee_shop_sales;

 ---Finding unique store locations
 SELECT DISTINCT store_location
 FROM bright_coffee_shop_sales; 

 ---formating dates to show the name
 SELECT transaction_date,
        DAYNAME(transaction_date) AS day_name
 FROM bright_coffee_shop_sales;

 ---Remove date stamp
 SELECT transaction_time,
        DATE_FORMAT(transaction_time,'HH:mm:ss') AS clean_time
FROM bright_coffee_shop_sales;
 
---Date range of data sets
SELECT MIN(transaction_date) AS earliest_date,
       MAX(transaction_date) AS latest_date
FROM bright_coffee_shop_sales;

---Product levels
SELECT product_category
FROM bright_coffee_shop_sales;

SELECT product_type
FROM bright_coffee_shop_sales;

---Finding total number of transactions
SELECT DISTINCT product_detail
FROM bright_coffee_shop_sales;

---Transaction per day
SELECT transaction_date,
       COUNT(DISTINCT transaction_date) AS total_transaction
FROM bright_coffee_shop_sales
GROUP BY transaction_date;

---Transaction per month
--SELECT MONTHNAME(trsansaction_date) AS Month
--SUM(unit_price * transaction_qty) AS Total_transaction
--FROM bright_coffee_shop_sales;

---Describing the datasets t see wher the error in the above SQL is coming from
Describe table bright_coffee_shop_sales;

---Continue with transaction per month
SELECT 
CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price,',','.') AS DOUBLE) AS Revenue
FROM bright_coffee_shop_sales;

---Month


---Case statements buckets
SELECT transaction_time,
        DATE_FORMAT(transaction_time,'HH:mm:ss') AS clean_time,
CASE
    WHEN HOUR (transaction_time) BETWEEN 6 AND 10 THEN 'Morning'
    WHEN HOUR (transaction_time) BETWEEN 10 AND 13 THEN 'Afternoon'
    WHEN HOUR (transaction_time) BETWEEN 13 AND 30 THEN 'Late_afternoon'
    ELSE 'Evening'
    END AS time_bucket 
FROM bright_coffee_shop_sales; ---hours bucket

---Describing day of week and day of week
SELECT DAYNAME(transaction_date),
       DAYOFWEEK(transaction_date),
     CASE 
         WHEN DAYNAME(transaction_date) IN('Sat', 'Sun') THEN  "Weekend"
         ELSE 'Weekday'
      END AS day_type
FROM bright_coffee_shop_sales;  

--------------------------------------------------------------------------------------------------------------------------------------------

--Final Big query with all the columns

SELECT *
FROM bright_coffee_shop_sales;

SELECT transaction_date, transaction_id, 
       DATE_FORMAT(transaction_time,'HH:mm:ss') AS clean_time, ---Clean time (tomestamp formatting)
       transaction_qty,
       store_id,
       store_location,
       product_id,
       unit_price,
       product_category,
       product_type,
       product_detail,
       DAYNAME(transaction_date) AS day_name, ---Day name (Monday,Tuesday...)
       MONTHNAME(transaction_date) AS month_name, ----Month name(January, February...)
       DAYOFMONTH(transaction_date) AS day_number, ---day of month (1-31)
       
       CASE 
         WHEN DAYNAME(transaction_date) IN('Sat', 'Sun') THEN  "Weekend"
         ELSE 'Weekday'
      END AS day_type, ------Weeeknd vs weekday

 CASE
       WHEN HOUR (transaction_time) BETWEEN 6 AND 10 THEN 'Morning'
       WHEN HOUR (transaction_time) BETWEEN 10 AND 13 THEN 'Afternoon'
       WHEN HOUR (transaction_time) BETWEEN 13 AND 30 THEN 'Late_afternoon'
       ELSE 'Evening'
    END AS time_bucket, ---time bucket

  CASE
       WHEN DAYOFMONTH(transaction_date) BETWEEN 1 AND 10 THEN 'Early Month'
       WHEN DAYOFMONTH(transaction_date) BETWEEN 11 AND 20 THEN 'Mid Month'  
       ELSE 'Month End'
    END AS month_period,  ---month period bucket

  CASE
      WHEN (CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price,',','.') AS DOUBLE)) <= 50 THEN 'Cheap spend'
      WHEN (CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price,',','.') AS DOUBLE)) BETWEEN 51 AND 200 THEN 'Low spend'
      WHEN (CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price,',','.') AS DOUBLE)) BETWEEN 201 AND 300 THEN 'Medium spend'
      ELSE 'Expensive spend'
      END AS Spend_bucket,  ---spending buckets categories
    CAST(REPLACE(unit_price,',','.') AS DOUBLE) AS clean_time, ---Clean numeric time
    ROUND((CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price,',','.') AS DOUBLE)),2) AS Revenue ---revenue pper row
FROM bright_coffee_shop_sales;     



