create schema mysales;

-- Switch to using the SALES database
USE mysales;

-- Create a new schema named COHORT_ANALYSIS
-- Note: MySQL doesn't have schemas in the same way as Snowflake. 
-- In MySQL, databases serve a similar purpose to schemas in Snowflake. 
-- Therefore, you can ignore the schema creation or manage it with a separate database if necessary.

-- Create a table named RETAIL with various columns to store retail data
CREATE TABLE IF NOT EXISTS RETAIL (
    InvoiceNo VARCHAR(10),
    StockCode VARCHAR(20),
    Description VARCHAR(100),
    Quantity DECIMAL(8,2),  -- Use DECIMAL for numbers with precision in MySQL
    InvoiceDate VARCHAR(25),
    UnitPrice DECIMAL(8,2), -- Use DECIMAL for numbers with precision in MySQL
    CustomerID BIGINT,       -- Use BIGINT for large integer IDs
    Country VARCHAR(25)
);

-- Select the first 5 rows from the RETAIL table
SELECT * FROM RETAIL LIMIT 5;



LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Online Retail Data.csv'
INTO TABLE retail
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(InvoiceNo, StockCode, Description, Quantity, @date_str, 
UnitPrice, CustomerID, Country)
SET InvoiceDate = STR_TO_DATE(@date_str, '%d/%m/%Y %H:%i');


select count(*) from retail;
select count(distinct InvoiceNo) from retail;
select count(distinct customerid) from retail;



-- Step 1: Create a Common Table Expression (CTE) named CTE1 to prepare data
WITH CTE1 AS (
    SELECT 
        InvoiceNo, CUSTOMERID, 
		INVOICEDATE, -- MySQL uses STR_TO_DATE for date parsing
        ROUND(QUANTITY * UNITPRICE, 2) AS REVENUE
    FROM RETAIL
    WHERE CUSTOMERID IS NOT NULL
),

-- Step 2: Create CTE2 to calculate purchase and first purchase months
CTE2 AS (
    SELECT InvoiceNo, CUSTOMERID, INVOICEDATE, 
        DATE_FORMAT(INVOICEDATE, '%Y-%m-01') AS PURCHASE_MONTH, -- MySQL equivalent to truncating to month: use DATE_FORMAT
        DATE_FORMAT(MIN(INVOICEDATE) OVER (PARTITION BY CUSTOMERID ORDER BY INVOICEDATE), '%Y-%m-01') AS FIRST_PURCHASE_MONTH,
        REVENUE
    FROM CTE1
),

-- Step 3: Create CTE3 to determine cohort months
CTE3 AS (
    SELECT InvoiceNo, FIRST_PURCHASE_MONTH,
        CONCAT('Month_', TIMESTAMPDIFF(MONTH, FIRST_PURCHASE_MONTH, PURCHASE_MONTH)) AS COHORT_MONTH -- Use TIMESTAMPDIFF in MySQL
    FROM CTE2
)

-- Step 4: Perform the final query to pivot and count invoices by cohort months
-- Since MySQL does not have a direct PIVOT function, we use conditional aggregation
SELECT 
    FIRST_PURCHASE_MONTH,
    SUM(CASE WHEN COHORT_MONTH = 'Month_0' THEN 1 ELSE 0 END) AS Month_0,
    SUM(CASE WHEN COHORT_MONTH = 'Month_1' THEN 1 ELSE 0 END) AS Month_1,
    SUM(CASE WHEN COHORT_MONTH = 'Month_2' THEN 1 ELSE 0 END) AS Month_2,
    SUM(CASE WHEN COHORT_MONTH = 'Month_3' THEN 1 ELSE 0 END) AS Month_3,
    SUM(CASE WHEN COHORT_MONTH = 'Month_4' THEN 1 ELSE 0 END) AS Month_4,
    SUM(CASE WHEN COHORT_MONTH = 'Month_5' THEN 1 ELSE 0 END) AS Month_5,
    SUM(CASE WHEN COHORT_MONTH = 'Month_6' THEN 1 ELSE 0 END) AS Month_6,
    SUM(CASE WHEN COHORT_MONTH = 'Month_7' THEN 1 ELSE 0 END) AS Month_7,
    SUM(CASE WHEN COHORT_MONTH = 'Month_8' THEN 1 ELSE 0 END) AS Month_8,
    SUM(CASE WHEN COHORT_MONTH = 'Month_9' THEN 1 ELSE 0 END) AS Month_9,
    SUM(CASE WHEN COHORT_MONTH = 'Month_10' THEN 1 ELSE 0 END) AS Month_10,
    SUM(CASE WHEN COHORT_MONTH = 'Month_11' THEN 1 ELSE 0 END) AS Month_11,
    SUM(CASE WHEN COHORT_MONTH = 'Month_12' THEN 1 ELSE 0 END) AS Month_12
FROM CTE3
GROUP BY FIRST_PURCHASE_MONTH
ORDER BY FIRST_PURCHASE_MONTH;




-- Step 1: Create a Common Table Expression (CTE) named CTE1 to prepare data
WITH CTE1 AS (
    SELECT 
        InvoiceNo, CUSTOMERID, 
        INVOICEDATE, -- MySQL uses STR_TO_DATE for date parsing
        ROUND(QUANTITY * UNITPRICE, 2) AS REVENUE
    FROM RETAIL
    WHERE CUSTOMERID IS NOT NULL
),

-- Step 2: Create CTE2 to calculate purchase and first purchase months
CTE2 AS (
    SELECT InvoiceNo, CUSTOMERID, INVOICEDATE, 
        DATE_FORMAT(INVOICEDATE, '%Y-%m-01') AS PURCHASE_MONTH, -- Truncate to the first day of the month
        DATE_FORMAT(MIN(INVOICEDATE) OVER (PARTITION BY CUSTOMERID ORDER BY INVOICEDATE), '%Y-%m-01') AS FIRST_PURCHASE_MONTH,
        REVENUE
    FROM CTE1
),

-- Step 3: Create CTE3 to determine cohort months
CTE3 AS (
    SELECT CUSTOMERID, FIRST_PURCHASE_MONTH,
        CONCAT('Month_', TIMESTAMPDIFF(MONTH, FIRST_PURCHASE_MONTH, PURCHASE_MONTH)) AS COHORT_MONTH -- Use TIMESTAMPDIFF in MySQL
    FROM CTE2
)

-- Final Query: Count distinct customers in each cohort for subsequent months
SELECT FIRST_PURCHASE_MONTH as Cohort,
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_0', CUSTOMERID, NULL)) as Month_0,
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_1', CUSTOMERID, NULL)) as Month_1,
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_2', CUSTOMERID, NULL)) as Month_2,
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_3', CUSTOMERID, NULL)) as Month_3,
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_4', CUSTOMERID, NULL)) as Month_4,
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_5', CUSTOMERID, NULL)) as Month_5,
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_6', CUSTOMERID, NULL)) as Month_6,
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_7', CUSTOMERID, NULL)) as Month_7,
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_8', CUSTOMERID, NULL)) as Month_8,
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_9', CUSTOMERID, NULL)) as Month_9,
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_10', CUSTOMERID, NULL)) as Month_10,
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_11', CUSTOMERID, NULL)) as Month_11,
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_12', CUSTOMERID, NULL)) as Month_12
FROM CTE3
GROUP BY FIRST_PURCHASE_MONTH
ORDER BY FIRST_PURCHASE_MONTH;



-- Step 1: Create a Common Table Expression (CTE) named CTE1 to calculate revenue from valid transactions
WITH CTE1 AS (
    SELECT 
        CUSTOMERID,
        INVOICEDATE, -- Convert the date string to DATETIME
        ROUND(QUANTITY * UNITPRICE, 0) AS REVENUE -- Calculate and round the revenue
    FROM RETAIL
    WHERE CUSTOMERID IS NOT NULL
),

-- Step 2: Create CTE2 to calculate purchase and first purchase months
CTE2 AS (
    SELECT 
        CUSTOMERID, 
        INVOICEDATE, 
        DATE_FORMAT(INVOICEDATE, '%Y-%m-01') AS PURCHASE_MONTH, -- Truncate date to the first day of the month
        DATE_FORMAT(MIN(INVOICEDATE) OVER (PARTITION BY CUSTOMERID ORDER BY INVOICEDATE), '%Y-%m-01') AS FIRST_PURCHASE_MONTH, -- Determine first purchase month
        REVENUE
    FROM CTE1
),

-- Step 3: Create CTE3 to calculate cohort months
CTE3 AS (
    SELECT 
        FIRST_PURCHASE_MONTH as Cohort, -- Rename first purchase month as Cohort
        CONCAT('Month_', TIMESTAMPDIFF(MONTH, FIRST_PURCHASE_MONTH, PURCHASE_MONTH)) AS COHORT_MONTH, -- Calculate cohort month difference
        REVENUE
    FROM CTE2
)

-- Final Query: Calculate the total revenue for each cohort month using conditional aggregation
SELECT 
    Cohort, -- The first purchase month (Cohort)
    SUM(CASE WHEN COHORT_MONTH = 'Month_0' THEN REVENUE ELSE 0 END) AS Month_0,
    SUM(CASE WHEN COHORT_MONTH = 'Month_1' THEN REVENUE ELSE 0 END) AS Month_1,
    SUM(CASE WHEN COHORT_MONTH = 'Month_2' THEN REVENUE ELSE 0 END) AS Month_2,
    SUM(CASE WHEN COHORT_MONTH = 'Month_3' THEN REVENUE ELSE 0 END) AS Month_3,
    SUM(CASE WHEN COHORT_MONTH = 'Month_4' THEN REVENUE ELSE 0 END) AS Month_4,
    SUM(CASE WHEN COHORT_MONTH = 'Month_5' THEN REVENUE ELSE 0 END) AS Month_5,
    SUM(CASE WHEN COHORT_MONTH = 'Month_6' THEN REVENUE ELSE 0 END) AS Month_6,
    SUM(CASE WHEN COHORT_MONTH = 'Month_7' THEN REVENUE ELSE 0 END) AS Month_7,
    SUM(CASE WHEN COHORT_MONTH = 'Month_8' THEN REVENUE ELSE 0 END) AS Month_8,
    SUM(CASE WHEN COHORT_MONTH = 'Month_9' THEN REVENUE ELSE 0 END) AS Month_9,
    SUM(CASE WHEN COHORT_MONTH = 'Month_10' THEN REVENUE ELSE 0 END) AS Month_10,
    SUM(CASE WHEN COHORT_MONTH = 'Month_11' THEN REVENUE ELSE 0 END) AS Month_11,
    SUM(CASE WHEN COHORT_MONTH = 'Month_12' THEN REVENUE ELSE 0 END) AS Month_12
FROM CTE3
GROUP BY Cohort -- Group by the cohort (first purchase month)
ORDER BY Cohort;















