## Cohort Analysis Using SQL

### Data Source
- **Source**: [Kaggle - Online Retail Data Set from UCI ML Repository](https://www.kaggle.com/datasets/jihyeseo/online-retail-data-set-from-uci-ml-repo)

### Purpose of Analysis
The goal of this analysis is to perform cohort analysis on an online retail dataset to understand customer purchasing behavior over time. Cohort analysis helps identify patterns by categorizing customers into groups based on their first purchase date and tracking their activities in subsequent months. This analysis will allow the business to assess customer retention, revenue patterns, and engagement.

### Data Overview
The dataset represents online retail transactions, including the following details for each purchase:
- **InvoiceNo**: Unique identifier for each transaction.
- **StockCode**: Product code.
- **Description**: Description of the item.
- **Quantity**: Number of units purchased.
- **InvoiceDate**: Date and time of purchase.
- **UnitPrice**: Price per unit of the product.
- **CustomerID**: Unique identifier for each customer.
- **Country**: Country of the customer.

---

### SQL Code

Here’s your code separated into distinct steps to help make each section easier to follow:

---

### Step 1: Create Schema and Database
```sql
CREATE SCHEMA sales;

-- Switch to using the SALES database
USE sales;
```

---

### Step 2: Create Retail Table
```sql
CREATE TABLE IF NOT EXISTS RETAIL (
    InvoiceNo VARCHAR(10),
    StockCode VARCHAR(20),
    Description VARCHAR(100),
    Quantity DECIMAL(8,2),
    InvoiceDate VARCHAR(25),
    UnitPrice DECIMAL(8,2),
    CustomerID BIGINT,
    Country VARCHAR(25)
);
```

---

### Step 3: Load Data into Retail Table
```sql
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Online Retail Data.csv'
INTO TABLE retail
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(InvoiceNo, StockCode, Description, Quantity, @date_str, 
UnitPrice, CustomerID, Country)
SET InvoiceDate = STR_TO_DATE(@date_str, '%d/%m/%Y %H:%i');
```

---

### Step 4: Verify Data Load
```sql
-- Select first 5 rows to confirm data load
SELECT * FROM RETAIL LIMIT 5;
```
### Results of the query:
  | INVOICENO | STOCKCODE | DESCRIPTION                      | QUANTITY | INVOICEDATE     | UNITPRICE | CUSTOMERID | COUNTRY        |
|-----------|-----------|----------------------------------|----------|-----------------|-----------|------------|----------------|
| 536365    | 85123A    | WHITE HANGING HEART T-LIGHT HOLDER | 6        | 1/12/10 8:26    | 2.55      | 17850      | United Kingdom |
| 536366    | 22633     | HAND WARMER UNION JACK            | 6        | 1/12/10 8:28    | 1.85      | 17850      | United Kingdom |
| 536367    | 84879     | ASSORTED COLOUR BIRD ORNAMENT     | 32       | 1/12/10 8:34    | 1.69      | 13047      | United Kingdom |
| 536368    | 22960     | JAM MAKING SET WITH JARS          | 6        | 1/12/10 8:34    | 4.25      | 13047      | United Kingdom |
| 536369    | 21756     | BATH BUILDING BLOCK WORD          | 3        | 1/12/10 8:35    | 5.95      | 13047      | United Kingdom |

```sql
-- Check total row count
SELECT COUNT(*) FROM retail;
```
### Results of the query:
  | Total_Row |
  |-----------|
  |   22190   |
```sql
-- Check distinct count of customers;
SELECT COUNT(DISTINCT CustomerID) AS Total_Customers FROM retail;
```
### Results of the query:
  | Total_Customers |
  |-----------------|
  |      4372       |


---

### Query 1: Count of Invoices by Cohort Month 
   ```sql
-- Prepare Data for Revenue Calculation
   WITH CTE1 AS (
       SELECT 
           InvoiceNo, CUSTOMERID, 
           INVOICEDATE, 
           ROUND(QUANTITY * UNITPRICE, 2) AS REVENUE
       FROM RETAIL
       WHERE CUSTOMERID IS NOT NULL
   ),
   -- Calculate Purchase and First Purchase Months
   CTE2 AS (
       SELECT InvoiceNo, CUSTOMERID, INVOICEDATE, 
           DATE_FORMAT(INVOICEDATE, '%Y-%m-01') AS PURCHASE_MONTH,
           DATE_FORMAT(MIN(INVOICEDATE) OVER (PARTITION BY CUSTOMERID ORDER BY INVOICEDATE), '%Y-%m-01') AS FIRST_PURCHASE_MONTH,
           REVENUE
       FROM CTE1
   ),
   -- Determine Cohort Months
   CTE3 AS (
       SELECT InvoiceNo, FIRST_PURCHASE_MONTH,
           CONCAT('Month_', TIMESTAMPDIFF(MONTH, FIRST_PURCHASE_MONTH, PURCHASE_MONTH)) AS COHORT_MONTH
       FROM CTE2
   )
   -- Pivot Invoices by Cohort Month
   SELECT 
       FIRST_PURCHASE_MONTH,
       SUM(CASE WHEN COHORT_MONTH = 'Month_0' THEN 1 ELSE 0 END) AS Month_0,
       SUM(CASE WHEN COHORT_MONTH = 'Month_1' THEN 1 ELSE 0 END) AS Month_1,
       -- Continue for Months 2 through 12
   FROM CTE3
   GROUP BY FIRST_PURCHASE_MONTH
   ORDER BY FIRST_PURCHASE_MONTH;
   ```
### Results of the query:

| FIRST_PURCHASE_MONTH | Month_0 | Month_1 | Month_2 | Month_3 | Month_4 | Month_5 | Month_6 | Month_7 | Month_8 | Month_9 | Month_10 | Month_11 | Month_12 |
|----------------------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|----------|----------|----------|
| 2010-12-01           | 1708    | 689     | 579     | 753     | 611     | 801     | 736     | 691     | 661     | 798     | 762      | 1135     | 395      |
| 2011-01-01           | 547     | 149     | 182     | 151     | 233     | 196     | 178     | 172     | 189     | 235     | 282      | 89       | 0        |
| 2011-02-01           | 474     | 136     | 113     | 162     | 141     | 134     | 124     | 164     | 136     | 187     | 40       | 0        | 0        |
| 2011-03-01           | 548     | 123     | 178     | 150     | 142     | 123     | 159     | 161     | 222     | 48      | 0        | 0        | 0        |
| 2011-04-01           | 386     | 109     | 93      | 78      | 83      | 89      | 94      | 120     | 32      | 0       | 0        | 0        | 0        |
| 2011-05-01           | 366     | 93      | 64      | 70      | 93      | 87      | 113     | 37      | 0       | 0       | 0        | 0        | 0        |
| 2011-06-01           | 298     | 71      | 58      | 91      | 79      | 129     | 30      | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-07-01           | 235     | 50      | 59      | 57      | 84      | 25      | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-08-01           | 203     | 59      | 70      | 68      | 26      | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-09-01           | 377     | 127     | 154     | 42      | 0       | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-10-01           | 455     | 167     | 57      | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-11-01           | 425     | 55      | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-12-01           | 45      | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |

---

### Query 2: Distinct Customer Count by Cohort Month

   ```sql
   --  Prepare Data for Revenue Calculation (Same as Query 1 Step 1)
   WITH CTE1 AS (
       SELECT 
           InvoiceNo, CUSTOMERID, 
           INVOICEDATE, 
           ROUND(QUANTITY * UNITPRICE, 2) AS REVENUE
       FROM RETAIL
       WHERE CUSTOMERID IS NOT NULL
   ),
   -- Calculate Purchase and First Purchase Months (Same as Query 1 Step 2)
   CTE2 AS (
       SELECT InvoiceNo, CUSTOMERID, INVOICEDATE, 
           DATE_FORMAT(INVOICEDATE, '%Y-%m-01') AS PURCHASE_MONTH,
           DATE_FORMAT(MIN(INVOICEDATE) OVER (PARTITION BY CUSTOMERID ORDER BY INVOICEDATE), '%Y-%m-01') AS FIRST_PURCHASE_MONTH,
           REVENUE
       FROM CTE1
   ),
   -- Determine Cohort Months (Same as Query 1 Step 3)

   CTE3 AS (
       SELECT CUSTOMERID, FIRST_PURCHASE_MONTH,
           CONCAT('Month_', TIMESTAMPDIFF(MONTH, FIRST_PURCHASE_MONTH, PURCHASE_MONTH)) AS COHORT_MONTH
       FROM CTE2
   )
   -- Count Distinct Customers in Each Cohort Month
  
   SELECT FIRST_PURCHASE_MONTH as Cohort,
       COUNT(DISTINCT IF(COHORT_MONTH = 'Month_0', CUSTOMERID, NULL)) as Month_0,
       COUNT(DISTINCT IF(COHORT_MONTH = 'Month_1', CUSTOMERID, NULL)) as Month_1,
       -- Continue for Months 2 through 12
   FROM CTE3
   GROUP BY FIRST_PURCHASE_MONTH
   ORDER BY FIRST_PURCHASE_MONTH;
   ```


### Results of the query:

| Cohort     | Month_0 | Month_1 | Month_2 | Month_3 | Month_4 | Month_5 | Month_6 | Month_7 | Month_8 | Month_9 | Month_10 | Month_11 | Month_12 |
|------------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|----------|----------|----------|
| 2010-12-01 | 948     | 362     | 317     | 367     | 341     | 376     | 360     | 336     | 336     | 374     | 354      | 474      | 260      |
| 2011-01-01 | 421     | 101     | 119     | 102     | 138     | 126     | 110     | 108     | 131     | 146     | 155      | 63       | 0        |
| 2011-02-01 | 380     | 94      | 73      | 106     | 102     | 94      | 97      | 107     | 98      | 119     | 35       | 0        | 0        |
| 2011-03-01 | 440     | 84      | 112     | 96      | 102     | 78      | 116     | 105     | 127     | 39      | 0        | 0        | 0        |
| 2011-04-01 | 299     | 68      | 66      | 63      | 62      | 71      | 69      | 78      | 25      | 0       | 0        | 0        | 0        |
| 2011-05-01 | 279     | 66      | 48      | 48      | 60      | 68      | 74      | 29      | 0       | 0       | 0        | 0        | 0        |
| 2011-06-01 | 235     | 49      | 44      | 64      | 58      | 79      | 24      | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-07-01 | 191     | 40      | 49      | 44      | 52      | 22      | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-08-01 | 167     | 42      | 42      | 42      | 23      | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-09-01 | 298     | 89      | 97      | 36      | 0       | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-10-01 | 352     | 93      | 46      | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-11-01 | 321     | 43      | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-12-01 | 41      | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
---

### Query 3: Revenue by Cohort Month
   ```sql
    -- Prepare Data for Revenue Calculation (Same as Query 1 Step 1)
   WITH CTE1 AS (
       SELECT 
           CUSTOMERID,
           INVOICEDATE,
           ROUND(QUANTITY * UNITPRICE, 0) AS REVENUE
       FROM RETAIL
       WHERE CUSTOMERID IS NOT NULL
   ),
    -- Calculate Purchase and First Purchase Months (Same as Query 1 Step 2)
   CTE2 AS (
       SELECT 
           CUSTOMERID, 
           INVOICEDATE, 
           DATE_FORMAT(INVOICEDATE, '%Y-%m-01') AS PURCHASE_MONTH,
           DATE_FORMAT(MIN(INVOICEDATE) OVER (PARTITION BY CUSTOMERID ORDER BY INVOICEDATE), '%Y-%m-01') AS FIRST_PURCHASE_MONTH,
           REVENUE
       FROM CTE1
   ),
   -- Calculate Cohort Months (Similar to Query 1 Step 3)
   CTE3 AS (
       SELECT 
           FIRST_PURCHASE_MONTH as Cohort,
           CONCAT('Month_', TIMESTAMPDIFF(MONTH, FIRST_PURCHASE_MONTH, PURCHASE_MONTH)) AS COHORT_MONTH,
           REVENUE
       FROM CTE2
   )

     -- Sum Revenue by Cohort Month
   SELECT 
       Cohort,
       SUM(CASE WHEN COHORT_MONTH = 'Month_0' THEN REVENUE ELSE 0 END) AS Month_0,
       SUM(CASE WHEN COHORT_MONTH = 'Month_1' THEN REVENUE ELSE 0 END) AS Month_1,
       -- Continue for Months 2 through 12
   FROM CTE3
   GROUP BY Cohort
   ORDER BY Cohort;
   ```
### Results of the query:

| Cohort     | Month_0 | Month_1 | Month_2 | Month_3 | Month_4 | Month_5 | Month_6 | Month_7 | Month_8 | Month_9 | Month_10 | Month_11 | Month_12 |
|------------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|----------|----------|----------|
| 2010-12-01 | 66819   | 25595   | 25505   | 32794   | 24509   | 33942   | 34833   | 24244   | 22871   | 40953   | 55315    | 53170    | 18593    |
| 2011-01-01 | 18911   | 4214    | 5733    | 4793    | 8181    | 5998    | 5240    | 5611    | 6779    | 7445    | 12044    | 3417     | 0        |
| 2011-02-01 | 17831   | 3788    | 6407    | 6048    | 2141    | 3263    | 4255    | 5126    | 6673    | 7472    | 2033     | 0        | 0        |
| 2011-03-01 | 14892   | 3900    | 6661    | 4622    | 3046    | 3109    | 6379    | 7161    | 9163    | 2284    | 0        | 0        | 0        |
| 2011-04-01 | 9695    | 3012    | 2943    | 2041    | 2101    | 1754    | 2185    | 3608    | 460     | 0       | 0        | 0        | 0        |
| 2011-05-01 | 12778   | 2901    | 2839    | 2620    | 2132    | 2484    | 3032    | 920     | 0       | 0       | 0        | 0        | 0        |
| 2011-06-01 | 9320    | 2583    | 1182    | 2225    | 3465    | 6772    | 650     | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-07-01 | -657    | 1142    | 1160    | 942     | 1938    | 559     | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-08-01 | 4950    | 62      | -783    | -2118   | -707    | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-09-01 | 11905   | 2244    | 3150    | 1008    | 0       | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-10-01 | 9761    | 3797    | 2230    | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-11-01 | 13651   | 3190    | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-12-01 | 10046   | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
---

## Conclusion
The cohort analysis queries perform three main operations to analyze customer purchase behavior over time:

1. Customer Retention and Cohort Month Tracking: The queries identify customer cohorts by their initial purchase month and calculate retention by counting distinct customers in each subsequent month, helping to visualize customer retention trends.

2. Revenue Analysis by Cohort: They calculate the revenue generated by each cohort over a 12-month period, providing insight into the revenue consistency or decline of each cohort month over time.

3. Customer and Purchase Month Aggregation: Using conditional aggregation, the queries summarize data to allow straightforward analysis of customer retention rates and revenue contributions, facilitating data-driven decisions for improving customer lifetime value and engagement.


## 👤 Author

[![GitHub](https://img.shields.io/badge/GitHub-000000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/shaun-mia)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/shaun-mia/)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:shaunmia.cse@gmail.com)
