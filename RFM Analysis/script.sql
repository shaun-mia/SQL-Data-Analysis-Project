-- Creating the Database
CREATE DATABASE rfm_analysis;

CREATE TABLE rfm_data (
    ORDERNU INT,
    QUANTITY INT,
    PRICEEACI DECIMAL(10,2),
    ORDERLIN INT,
    SALES DECIMAL(10,2),
    ORDERDA DATE,
    STATUS VARCHAR(20),
    QTRID INT,
    MONTHIC INT,
    YEARID INT,
    PRODUCTIMSRP DECIMAL(10,2),
    PRODUCTI VARCHAR(50),
    CUSTOMEI INT,
    PHONE VARCHAR(20),
    ADDRESSL1 VARCHAR(100),
    ADDRESSL2 VARCHAR(100),
    CITY VARCHAR(50),
    STATE VARCHAR(50),
    POSTALCO VARCHAR(20),
    COUNTRY VARCHAR(50),
    TERRITORY VARCHAR(50),
    CONTACTI VARCHAR(50),
    CONTACTI2 VARCHAR(50),
    DEALSIZE VARCHAR(20)
);


-- Inspecting Data
SELECT * FROM rfm_data LIMIT 10;
-- unique value 

select distinct status from rfm_data;

select distinct status from rfm_data;
select distinct COUNTRY from rfm_data;

select distinct year_id from rfm_data;
select distinct PRODUCTLINE from rfm_data;

select distinct DEALSIZE from rfm_data;
select distinct TERRITORY from rfm_data;


-- Grouping sales by product line to understand the distribution of sales across different product categories.
-- We're calculating the total revenue and the number of orders for each product line.
select PRODUCTLINE, ROUND(sum(sales),0) AS Revenue, COUNT(DISTINCT ORDERNUMBER) AS NO_OF_ORDERS
from rfm_data
group by PRODUCTLINE
order by 3 desc;

-- Analyzing sales revenue by year to identify trends or changes over time.
select YEAR_ID, sum(sales) Revenue
from rfm_data
group by YEAR_ID
order by 2 desc;

-- Investigating sales revenue by deal size to understand the impact of deal sizes on revenue.
select  DEALSIZE,  sum(sales) Revenue
from rfm_data
group by DEALSIZE
order by 2 desc;

-- Identifying the city with the highest sales in a specific country (e.g., 'UK').
SELECT city, SUM(sales) AS Revenue
FROM rfm_data
WHERE country = 'UK'
GROUP BY city
ORDER BY Revenue DESC
LIMIT 0, 1000;

-- Finding the best month for sales in a specific year (e.g., 2003) and calculating revenue and frequency.
select  MONTH_ID, sum(sales) Revenue, count(ORDERNUMBER) Frequency
from rfm_data
where YEAR_ID = 2003
group by  MONTH_ID
order by 2 desc;

-- Finding the best month for sales in a specific year (e.g., 2004) and calculating revenue and frequency.
select  MONTH_ID, sum(sales) Revenue, count(ORDERNUMBER) Frequency
from rfm_data
where YEAR_ID = 2004
group by  MONTH_ID
order by 2 desc;

-- Finding the best month for sales in a specific year (e.g., 2005 )and calculating revenue and frequency.
select  MONTH_ID, sum(sales) Revenue, count(ORDERNUMBER) Frequency
from rfm_data
where YEAR_ID = 2005
group by  MONTH_ID
order by 2 desc;



-- Identifying the top-selling product line in a specific month (e.g., November 2004).
select  MONTH_ID, PRODUCTLINE, sum(sales) Revenue, count(ORDERNUMBER)
from SALES_SAMPLE_DATA
where YEAR_ID = 2004 and MONTH_ID = 11
group by  MONTH_ID, PRODUCTLINE
order by 3 desc;



-- Determining the best-selling product in the United States.
select country, YEAR_ID, PRODUCTLINE, sum(sales) Revenue
from rfm_data
where country = 'USA'
group by  country, YEAR_ID, PRODUCTLINE
order by 4 desc;


-- Identifying the top-selling product line in a specific month (e.g., November 2004).
select  MONTH_ID, PRODUCTLINE, sum(sales) Revenue, count(ORDERNUMBER)
from rfm_data
where YEAR_ID = 2004 and MONTH_ID = 11
group by  MONTH_ID, PRODUCTLINE
order by 3 desc;







-- We need to calculate each metrics
SELECT 
    MAX(ORDERDATE)
FROM
    rfm_data;

with cte1 as (
select customername,
sum(sales) as monetaryvalue,
avg(sales) as AVGmonetaryvalue,
count(distinct ordernumber) as Frequency,
max(orderdate) as last_order_date,
(select max(ORDERDATE) from rfm_data)  as final_date
from rfm_data
group by CUSTOMERNAME
),
cte2 as (
select*,datediff(final_date,last_order_date)+1 as Recency from cte1
order by Recency
),
cte3 as (
select*,
ntile(4) over(order by recency desc) as rfm_recency,
ntile(4) over(order by frequency ) as rfm_frequency,
ntile(4) over(order by monetaryvalue) as rfm_monetary
 from cte2),
 
 -- quatiles concepts
 cte4 as (
 select *, concat(rfm_recency,rfm_frequency,rfm_monetary) as RFM_SCORE
 from cte3
 )
SELECT*,
    customername,
    rfm_score,
    CASE 
        WHEN RFM_SCORE IN ('414', '314','424','434','444','324','334') THEN 'Loyal Customers'
        WHEN RFM_SCORE IN ('113', '124', '214') THEN 'Potential Churners'
        WHEN RFM_SCORE IN ('411', '422') THEN 'New Customers'
        WHEN RFM_SCORE IN ('314', '244') THEN 'Big Spenders'
        WHEN RFM_SCORE IN ('134', '244') THEN 'Can’t Lose Them'
        ELSE 'Other'
    END AS segment
FROM 
    cte4;