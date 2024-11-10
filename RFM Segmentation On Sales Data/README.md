# RFM Segmentation on Sales Data

This project performs RFM (Recency, Frequency, Monetary) segmentation on sales data to categorize customers based on their purchasing behavior. The RFM model helps identify key customer segments such as Loyal Customers, Potential Churners, and Big Spenders.

## Table of Contents
- [Database Setup](#database-setup)
- [Data Exploration](#data-exploration)
- [Sales Analysis](#sales-analysis)
- [RFM Segmentation](#rfm-segmentation)
- [Customer Segmentation](#customer-segmentation)
- [Queries](#queries)

## Database Setup

### Step 1: Create the Database and Table

```sql
CREATE DATABASE rfm_analysis;

USE rfm_analysis;

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
```

## Data Exploration

### Inspecting Data
To view the first 10 rows of data:
```sql
SELECT * FROM rfm_data LIMIT 10;
```
### Output

| ORDERNU | QUANTITY | PRICEEACI | ORDERLIN | SALES  | ORDERDA    | STATUS  | QTRID | MONTHIC | YEARID | PRODUCTIMSRP | PRODUCTI   | CUSTOMEI         | PHONE        | ADDRESSL1               | ADDRESSL2 | CITY         | STATE | POSTALCO | COUNTRY | TERRITORY | CONTACTI | CONTACTI2 | DEALSIZE |
|---------|----------|-----------|----------|--------|------------|---------|-------|---------|--------|--------------|------------|------------------|--------------|-------------------------|-----------|--------------|-------|----------|---------|-----------|----------|-----------|----------|
| 10107   | 30       | 95.70     | 2        | 2871.00 | 2003-02-24 | Shipped | 1     | 2       | 2003   | Motorcycles  | 95         | S10_1678        | Land of Toys Inc. | 2125557818 | 897 Long Airport Avenue | NYC       | NY    | 10022    | USA     | NA        | Yu       | Kwai      | Small    |
| 10121   | 34       | 81.35     | 5        | 2765.90 | 2003-05-07 | Shipped | 2     | 5       | 2003   | Motorcycles  | 95         | S10_1678        | Reims Collectables | 26.47.1555 | 59 rue de l'Abbaye     | Reims     |        | 51100    | France  | EMEA      | Henriot  | Paul      | Small    |
| 10134   | 41       | 94.74     | 2        | 3884.34 | 2003-07-01 | Shipped | 3     | 7       | 2003   | Motorcycles  | 95         | S10_1678        | Lyon Souveniers    | +33 1 46 62 7555 | 27 rue du Colonel Pierre Avia | Paris |        | 75508    | France  | EMEA      | Da Cunha | Daniel    | Medium   |
| 10145   | 45       | 83.26     | 6        | 3746.70 | 2003-08-25 | Shipped | 3     | 8       | 2003   | Motorcycles  | 95         | S10_1678        | Toys4GrownUps.com | 6265557265 | 78934 Hillside Dr.     | Pasadena | CA     | 90003    | USA     | NA        | Young    | Julie     | Medium   |
| 10159   | 49       | 100.00    | 14       | 5205.27 | 2003-10-10 | Shipped | 4     | 10      | 2003   | Motorcycles  | 95         | S10_1678        | Corporate Gift Ideas Co. | 6505551386 | 7734 Strong St. | San Francisco | CA |          | USA       | NA      | Brown    | Julie     | Medium   |
| 10168   | 36       | 96.66     | 1        | 3479.76 | 2003-10-28 | Shipped | 4     | 10      | 2003   | Motorcycles  | 95         | S10_1678        | Technics Stores Inc. | 6505556809 | 9408 Furth Circle      | Burlingame | CA     | 94217    | USA     | NA        | Hirano   | Juri      | Medium   |
| 10180   | 29       | 86.13     | 9        | 2497.77 | 2003-11-11 | Shipped | 4     | 11      | 2003   | Motorcycles  | 95         | S10_1678        | Daedalus Designs Imports | 20.16.1555 | 184, chausse de Tournai | Lille |        | 59000    | France  | EMEA      | Rance    | Martine   | Small    |
| 10188   | 48       | 100.00    | 1        | 5512.32 | 2003-11-18 | Shipped | 4     | 11      | 2003   | Motorcycles  | 95         | S10_1678        | Herkku Gifts       | +47 2267 3215 | Drammen 121, PR 744 Sentrum | Bergen |        | N 5804 | Norway  | EMEA      | Oeztan   | Veysel    | Medium   |
| 10201   | 22       | 98.57     | 2        | 2168.54 | 2003-12-01 | Shipped | 4     | 12      | 2003   | Motorcycles  | 95         | S10_1678        | Mini Wheels Co.    | 6505555787 | 5557 North Pendale Street | San Francisco | CA |          | USA       | NA      | Murphy   | Julie     | Small    |
| 10211   | 41       | 100.00    | 14       | 4708.44 | 2004-01-15 | Shipped | 1     | 1       | 2004   | Motorcycles  | 95         | S10_1678        | Auto Canal Petit   | (1) 47.55.6555 | 25, rue Lauriston      | Paris   |        | 75016    | France  | EMEA      | Perrier  | Dominique | Medium   |


### Checking Unique Values
Explore unique values in different columns:
```sql
SELECT DISTINCT status FROM rfm_data;
```
### Output

| Status     |
|------------|
| Shipped    |
| Disputed   |
| In Process |
| Cancelled  |
| On Hold    |
| Resolved   |

```sql
SELECT DISTINCT COUNTRY FROM rfm_data;

```
### Output

| Country      |
|--------------|
| USA          |
| France       |
| Norway       |
| Australia    |
| Finland      |
| Austria      |
| UK           |
| Spain        |
| Sweden       |
| Singapore    |
| Canada       |
| Japan        |
| Italy        |
| Denmark      |
| Belgium      |
| Philippines  |
| Germany      |
| Switzerland  |
| Ireland      |


```sql
SELECT DISTINCT YEARID FROM rfm_data;

```
### Output

| YEAR_ID |
|---------|
| 2003    |
| 2004    |
| 2005    |

```sql

SELECT DISTINCT PRODUCTLINE FROM rfm_data;
```
### Output

| PRODUCTLINE       |
|-------------------|
| Motorcycles       |
| Classic Cars      |
| Trucks and Buses  |
| Vintage Cars      |
| Planes            |
| Ships             |
| Trains            |
```sql
SELECT DISTINCT DEALSIZE FROM rfm_data;
```
### Output
| DEALSIZE |
|----------|
| Small    |
| Medium   |
| Large    |
```sql
SELECT DISTINCT TERRITORY FROM rfm_data;

```
### Output

| TERRITORY |
|-----------|
| NA        |
| EMEA      |
| APAC      |
| Japan     |


## Sales Analysis

### Sales by Product Line
Calculate the total revenue and number of orders for each product line:
```sql
SELECT PRODUCTLINE, ROUND(SUM(sales), 0) AS Revenue, COUNT(DISTINCT ORDERNUMBER) AS NO_OF_ORDERS
FROM rfm_data
GROUP BY PRODUCTLINE
ORDER BY NO_OF_ORDERS DESC;
```

### Output:
| PRODUCTLINE      | REVENUE   | NO_OF_ORDERS |
|------------------|-----------|--------------|
| Classic Cars     | 3,797,679 | 190          |
| Vintage Cars     | 1,778,697 | 163          |
| Motorcycles      | 1,151,329 | 70           |
| Trucks and Buses | 1,056,547 | 68           |
| Ships            | 651,089   | 60           |
| Planes           | 910,313   | 54           |
| Trains           | 217,392   | 43           |



### Sales by Year
Analyze total revenue by year to identify sales trends:
```sql
SELECT YEARID, SUM(sales) AS Revenue
FROM rfm_data
GROUP BY YEARID
ORDER BY Revenue DESC;
```
### Output:
| YEAR_ID | REVENUE      |
|---------|--------------|
| 2004    | 4,412,321.07 |
| 2003    | 3,359,238.69 |
| 2005    | 1,791,486.71 |


### Sales by Deal Size
Calculate revenue based on deal size:
```sql
SELECT DEALSIZE, SUM(sales) AS Revenue
FROM rfm_data
GROUP BY DEALSIZE
ORDER BY Revenue DESC;
```
### Output:
| DEALSIZE | REVENUE      |
|----------|--------------|
| Medium   | 5,815,484.87 |
| Small    | 2,505,263.91 |
| Large    | 1,242,297.69 |


### Top-Selling City in a Country
Identify the city with the highest sales in a specified country:
```sql
SELECT city, SUM(sales) AS Revenue
FROM rfm_data
WHERE country = 'UK'
GROUP BY city
ORDER BY Revenue DESC
LIMIT 1000;
```
### Output
| CITY       | REVENUE    |
|------------|------------|
| Manchester | 157,807.81 |
| London     | 124,823.54 |
| Liverpool  | 118,008.27 |
| Cowes      | 78,240.84  |

### Best Selling Product in the United States
```sql
-- Determining the best-selling product in the United States.
select country, YEAR_ID, PRODUCTLINE, sum(sales) Revenue
from SALES_SAMPLE_DATA
where country = 'USA'
group by  country, YEAR_ID, PRODUCTLINE
order by 4 desc;
```
### Output:
| COUNTRY | YEAR_ID | PRODUCTLINE      | REVENUE    |
|---------|---------|------------------|------------|
| USA     | 2004    | Classic Cars     | 560,448.26 |
| USA     | 2003    | Classic Cars     | 558,544.09 |
| USA     | 2004    | Vintage Cars     | 301,982.35 |
| USA     | 2004    | Motorcycles      | 287,243.09 |
| USA     | 2003    | Vintage Cars     | 266,141.82 |
| USA     | 2004    | Trucks and Buses | 230,219.17 |
| USA     | 2005    | Classic Cars     | 225,645.87 |
| USA     | 2005    | Vintage Cars     | 189,631.73 |
| USA     | 2003    | Motorcycles      | 178,108.95 |
| USA     | 2004    | Planes           | 177,431.76 |
| USA     | 2003    | Trucks and Buses | 125,794.86 |
| USA     | 2004    | Ships            | 102,595    |
| USA     | 2003    | Planes           | 90,016.44  |
| USA     | 2005    | Planes           | 60,984.69  |
| USA     | 2003    | Ships            | 58,237.59  |
| USA     | 2005    | Motorcycles      | 55,019.66  |
| USA     | 2005    | Ships            | 48,855.55  |
| USA     | 2005    | Trucks and Buses | 41,828.39  |
| USA     | 2003    | Trains           | 28,304.13  |
| USA     | 2004    | Trains           | 25,551.06  |
| USA     | 2005    | Trains           | 15,398.37  |

### Best Month for Sales by Year
Find the month with the highest sales in a specific year:
```sql
SELECT MONTHIC, SUM(sales) AS Revenue, COUNT(ORDERNU) AS Frequency
FROM rfm_data
WHERE YEARID = 2003
GROUP BY MONTHIC
ORDER BY Revenue DESC;
```
### output:
| MONTH_ID | REVENUE    | FREQUENCY |
|----------|------------|-----------|
| 11       | 985,828.35 | 282       |
| 10       | 541,033.18 | 150       |
| 9        | 263,973.36 | 76        |
| 12       | 261,876.46 | 70        |
| 8        | 197,809.3  | 58        |
| 4        | 197,390.35 | 57        |
| 7        | 187,731.88 | 50        |
| 6        | 168,082.56 | 46        |
| 3        | 164,755.9  | 48        |
| 2        | 140,836.19 | 41        |
| 5        | 131,599.9  | 41        |
| 1        | 118,321.26 | 35        |


## RFM Segmentation

### Calculate RFM Metrics

1. **Calculate Recency, Frequency, and Monetary Value**:
   ```sql
   WITH cte1 AS (
       SELECT 
           CUSTOMERNAME,
           SUM(sales) AS MonetaryValue,
           AVG(sales) AS AvgMonetaryValue,
           COUNT(DISTINCT ORDERNUMBER) AS Frequency,
           MAX(ORDERDA) AS LastOrderDate,
           (SELECT MAX(ORDERDA) FROM rfm_data) AS FinalDate
       FROM rfm_data
       GROUP BY CUSTOMERNAME
   ),
   cte2 AS (
       SELECT *,
           DATEDIFF(FinalDate, LastOrderDate) + 1 AS Recency
       FROM cte1
   ),
   cte3 AS (
       SELECT *,
           NTILE(4) OVER(ORDER BY Recency DESC) AS RFM_Recency,
           NTILE(4) OVER(ORDER BY Frequency) AS RFM_Frequency,
           NTILE(4) OVER(ORDER BY MonetaryValue) AS RFM_Monetary
       FROM cte2
   )
   SELECT *
   FROM cte3;
   -- Assign RFM Score and Segment Customers**:
 
   WITH cte4 AS (
       SELECT *,
           CONCAT(RFM_Recency, RFM_Frequency, RFM_Monetary) AS RFM_SCORE
       FROM cte3
   )
   SELECT *,
       CUSTOMERNAME,
       RFM_SCORE,
       CASE 
           WHEN RFM_SCORE IN ('414', '314', '424', '434', '444', '324', '334') THEN 'Loyal Customers'
           WHEN RFM_SCORE IN ('113', '124', '214') THEN 'Potential Churners'
           WHEN RFM_SCORE IN ('411', '422') THEN 'New Customers'
           WHEN RFM_SCORE IN ('314', '244') THEN 'Big Spenders'
           WHEN RFM_SCORE IN ('134', '244') THEN 'Can’t Lose Them'
           ELSE 'Other'
       END AS Segment
   FROM cte4;
   ```

 ### Output:

| Company Name                              | Sales Amount  | Sales Per Customer | Frequency | Start Date  | End Date    | Days Active | Score 1 | Score 2 | Score 3 | Score 4 | Customer Group                | Customer ID | Category             |
|-------------------------------------------|---------------|---------------------|-----------|-------------|-------------|-------------|---------|---------|---------|---------|-------------------------------|-------------|----------------------|
| La Rochelle Gifts                         | 180124.90     | 3398.58             | 4         | 2005-05-31  | 2005-05-31  | 1           | 4       | 4       | 4       | 444     | La Rochelle Gifts            | 444         | Loyal Customers       |
| Euro Shopping Channel                     | 912294.11     | 3522.37             | 26        | 2005-05-31  | 2005-05-31  | 1           | 4       | 4       | 4       | 444     | Euro Shopping Channel        | 444         | Loyal Customers       |
| Diecast Classics Inc.                     | 122138.14     | 3939.94             | 4         | 2005-05-30  | 2005-05-31  | 2           | 4       | 4       | 4       | 444     | Diecast Classics Inc.        | 444         | Loyal Customers       |
| Petit Auto                                 | 74972.52      | 2998.90             | 3         | 2005-05-30  | 2005-05-31  | 2           | 4       | 2       | 2       | 422     | Petit Auto                   | 422         | New Customers         |
| Souveniers And Things Co.                 | 151570.98     | 3295.02             | 4         | 2005-05-29  | 2005-05-31  | 3           | 4       | 4       | 4       | 444     | Souveniers And Things Co.    | 444         | Loyal Customers       |
| Mini Gifts Distributors Ltd.              | 654858.06     | 3638.10             | 17        | 2005-05-29  | 2005-05-31  | 3           | 4       | 4       | 4       | 444     | Mini Gifts Distributors Ltd. | 444         | Loyal Customers       |
| Salzburg Collectables                      | 149798.63     | 3744.97             | 4         | 2005-05-17  | 2005-05-31  | 15          | 4       | 4       | 4       | 444     | Salzburg Collectables        | 444         | Loyal Customers       |
| L'ordine Souveniers                        | 142601.33     | 3656.44             | 3         | 2005-05-10  | 2005-05-31  | 22          | 4       | 2       | 4       | 424     | L'ordine Souveniers          | 424         | Loyal Customers       |
| Australian Collectables, Ltd               | 64591.46      | 2808.32             | 3         | 2005-05-09  | 2005-05-31  | 23          | 4       | 2       | 1       | 421     | Australian Collectables, Ltd | 421         | Other                 |
| Gifts4AllAges.com                          | 83209.88      | 3200.38             | 3         | 2005-05-06  | 2005-05-31  | 26          | 4       | 4       | 2       | 442     | Gifts4AllAges.com            | 442         | Other                 |

The table continues similarly for the rest of the data. Let me know if you'd like more entries or further formatting.

   

## Customer Segmentation

This section categorizes customers into segments:
- **Loyal Customers**: High engagement and spending
- **Potential Churners**: Less recent interactions, lower spending
- **New Customers**: Recently joined and have moderate spending
- **Big Spenders**: High monetary value and frequency
- **Can't Lose Them**: Significant spending but with lower engagement

## Queries

Use the provided SQL queries for RFM analysis and segmentation based on sales data. Adjust and execute these queries as per your analysis needs.



## 👤 Author

[![GitHub](https://img.shields.io/badge/GitHub-000000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/shaun-mia)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/shaun-mia/)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:shaunmia.cse@gmail.com)
