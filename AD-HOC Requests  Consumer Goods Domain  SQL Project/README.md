# Ad-Hoc Requests Consumer Goods Domain SQL Project

## Introduction

This project serves as a comprehensive SQL analysis in the Consumer Goods sector, specifically tailored to answer ad-hoc business requests. Each SQL query provides a focused insight that supports data-driven decisions, from understanding market reach to analyzing product costs and sales trends.

## About the Project

This project includes 10 SQL queries addressing various business questions in the Consumer Goods domain. Each query targets a specific aspect of business operations to reveal trends, analyze customer behaviors, and identify product performance. The queries cover areas such as customer analysis, product segmentation, cost comparison, and sales trends.

## Data Information

Download Data: https://codebasics.io/challenge/codebasics-resume-project-challenge/7

The data used in this project is drawn from the following tables:

1. **dim_customer**: Contains customer-related data.
   - **customer_code**: Unique identification code for each customer (e.g., '70002017').
   - **customer**: Customer names (e.g., 'Atliq Exclusive').
   - **platform**: Sales platforms (e.g., "Brick & Mortar", "E-Commerce").
   - **channel**: Distribution methods (e.g., "Retailers", "Direct", "Distributors").
   - **market**: Countries where customers are located.
   - **region**: Geographic categorization (e.g., "APAC", "EU").
   - **sub_zone**: Sub-regions (e.g., "India", "ROA").

2. **dim_product**: Contains product-related data.
   - **product_code**: Unique identification code for each product.
   - **division**: Product categories (e.g., "P & A", "N & S").
   - **segment**: Further categorization of products (e.g., "Peripherals", "Notebook").
   - **category**: Specific subcategories of products.
   - **product**: Names of individual products.
   - **variant**: Different versions of products (e.g., "Standard", "Premium").

3. **fact_gross_price**: Contains gross price information for each product.
   - **product_code**: Unique identification code for each product.
   - **fiscal_year**: Fiscal period of sale (covers 2020 and 2021).
   - **gross_price**: Initial price of a product before reductions.

4. **fact_manufacturing_cost**: Contains production cost information for each product.
   - **product_code**: Unique identification code for each product.
   - **cost_year**: Fiscal year of production.
   - **manufacturing_cost**: Total production cost, including materials and labor.

5. **fact_pre_invoice_deductions**: Contains pre-invoice deduction information.
   - **customer_code**: Unique identification code for each customer.
   - **fiscal_year**: Fiscal period of sale.
   - **pre_invoice_discount_pct**: Percentage of deductions applied before invoicing.

6. **fact_sales_monthly**: Contains monthly sales data for each product.
   - **date**: Sale date in monthly format for 2020 and 2021.
   - **product_code**: Unique identification code for each product.
   - **customer_code**: Unique identification code for each customer.
   - **sold_quantity**: Number of units sold.
   - **fiscal_year**: Fiscal period of sale.

## SQL Queries and Analysis

Below, each SQL query is listed with its purpose, the SQL code, expected output, and insights that can be drawn from the result.

### Query 1: Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.
**Purpose**: Identify all markets in the APAC region where "Atliq Exclusive" is active.

```sql
SELECT DISTINCT market
FROM dim_customer
WHERE customer_name = 'Atliq Exclusive' AND region = 'APAC';
```

| market      |
|-------------|
| Australia   |
| Bangladesh  |
| India       |
| Indonesia   |
| Japan       |
| Newzealand  |
| Philiphines |
| South Korea |

**Insight**: This query provides a list of markets within the APAC region where "Atliq Exclusive" is operational, assisting with regional sales targeting.

---

### Query 2: What is the percentage of unique product increase in 2021 vs. 2020? The final output contains these fields, unique_products_2020 unique_products_2021 percentage_chg.
**Purpose**: Calculate the percentage increase in unique products sold between 2020 and 2021.

```sql
WITH cte1 AS (
SELECT count(DISTINCT product_code) AS unique_product_2021
    FROM fact_sales_monthly
WHERE fiscal_year = 2021
),
        
 cte2 as
 (
SELECT count(DISTINCT product_code) AS unique_product_2020
    FROM fact_sales_monthly
WHERE fiscal_year = 2020
),
        
cte3 AS (
SELECT unique_product_2021,
        unique_product_2020
FROM cte1
cross
JOIN cte2
)
select*,ROUND ((( unique_product_2021-unique_product_2020)/ unique_product_2020)*100 ,1 )AS percentage_change
FROM cte3;
```

**Expected Output**:
| unique_products_2020 | unique_products_2021 | percentage_change |
|----------------------|----------------------|----------------|
| 245                  | 334                  | 36.33          |

**Insight**: Indicates a 20% increase in unique products sold, reflecting product diversity and potentially new launches in 2021.

---

### Query 3: Provide a report with all the unique product counts for each segment and sort them in descending order of product counts. The final output contains 2 fields, segment product_count.

**Purpose**: Get the count of products in each segment.

```sql
SELECT 
    *
FROM
    dim_product;

SELECT 
    segment, COUNT(product_code) AS product_count
FROM
    dim_product
GROUP BY segment
ORDER BY product_count DESC;
```

**Expected Output**:
| segment     | product_count |
|-------------|---------------|
| Notebook    | 129           |
| Accessories | 116           |
| Peripherals | 84            |
| Desktop     | 32            |
| Storage     | 27            |
| Networking  | 9             |

**Insight**: Shows the distribution of products across segments, useful for inventory and resource allocation.

---

### Query 4: Follow-up: Which segment had the most increase in unique products in 2021 vs 2020? The final output contains these fields, segment product_count_2020 product_count_2021 difference.

**Purpose**: Determine which segment saw the highest growth in unique products from 2020 to 2021.

```sql
SELECT 
 COUNT(DISTINCT product_code) AS unique_product_2020
FROM
 fact_sales_monthly
WHERE
 fiscal_year = 2020;

SELECT 
 p.segment,
        
 COUNT(DISTINCT CASE

    WHEN S.fiscal_year = 2020 THEN
    S.product_code
 END) AS product_count_2020,
 COUNT(DISTINCT CASE

    WHEN S.fiscal_year = 2021 THEN
    S.product_code
 END) AS product_count_2021,
 (COUNT(DISTINCT CASE

    WHEN S.fiscal_year = 2021 THEN
    S.product_code
 END) - COUNT(DISTINCT CASE

    WHEN S.fiscal_year = 2020 THEN
    S.product_code
 END)) AS difference
FROM
 dim_product AS p
 LEFT JOIN
 fact_sales_monthly AS S
    ON p.product_code = S.product_code
WHERE
 S.fiscal_year IN (2020 , 2021)
GROUP BY p.segment
ORDER BY difference DESC;

```

**Expected Output**:
| Segment     | product_count_2020 | product_count_2021 | difference |
|-------------|--------------------|--------------------|------------|
| Accessories | 69                 | 103                | 34         |
| Notebook    | 92                 | 108                | 16         |
| Peripherals | 59                 | 75                 | 16         |
| Desktop     | 7                  | 22                 | 15         |
| Storage     | 12                 | 17                 | 5          |
| Networking  | 6                  | 9                  | 3          |

**Insight**: Beverages segment has the highest increase in unique products, suggesting a focus on product expansion.

---

### Query 5:
Get the products that have the highest and lowest manufacturing costs. The final output should contain these fields, product_code product manufacturing_cost codebasics.io.

**Purpose**: Identify products with the maximum and minimum manufacturing costs.

```sql

SELECT 
 p.product_code,
        p.product,
        f.manufacturing_cost
FROM
 dim_product AS p
 LEFT JOIN
 fact_manufacturing_cost AS f
    ON p.product_code = f.product_code
WHERE
 manufacturing_cost = (SELECT 
 MAX(manufacturing_cost)
 FROM
 fact_manufacturing_cost) 
UNIONSELECT 
 p.product_code,
        p.product,
        f.manufacturing_cost
FROM
 dim_product AS p
 LEFT JOIN
 fact_manufacturing_cost AS f
    ON p.product_code = f.product_code
WHERE
 manufacturing_cost = (SELECT 
 MIN(manufacturing_cost)
 FROM
 fact_manufacturing_cost);
```

**Expected Output**:
| product_code | product               | manufacturing_cost |
|--------------|-----------------------|--------------------|
|  A6120110206 | AQ HOME Allin1 Gen 2  | 240.5364           |
| A2118150101  | AQ Master wired x1 Ms | 0.8920             |

**Insight**: Highlights cost outliers in manufacturing, valuable for pricing and cost management strategies.

---

### Query 6: Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market. The final output contains these fields, customer_code customer average_discount_percentage.

**Purpose**: Find the top 5 customers in India with the highest average pre-invoice discount in 2021.

```sql
WITH cte1 AS (

		SELECT a.customer_code,
        
 a.customer,
        a.market,
        b.fiscal_year,
        b.pre_invoice_discount_pct

    FROM dim_customer AS a

JOIN fact_pre_invoice_deductions AS b

    ON a.customer_code = b.customer_code

),
        
cte2 AS 
(
			SELECT customer_code,
        
 customer,
        
 market,
        
 fiscal_year,
        
 avg(pre_invoice_discount_pct) AS average_discount_pct

    FROM cte1

    WHERE fiscal_year = 2021
        AND market = 'India'

    GROUP BY  customer_code,
        customer,
        market,
        fiscal_year
)

SELECT customer_code,
        customer,
        round(average_discount_pct*100,
        2) AS average_discount_pct

    FROM cte2

ORDER BY  average_discount_pct desc
 limit 5;
```

**Expected Output**:
| customer_code | customer | average_discount_percentage |
|---------------|----------|-----------------------------|
| 90002009      | Flipkart | 30.83                       |
| 90002006      | Viveks   | 30.38                       |
| 90002003      | Ezone    | 30.28                       |
| 90002002      | Croma    | 30.25                       |
| 90002016      | Amazon   | 29.33                       |

**Insight**: Provides insights into top customers benefiting from pre-invoice discounts, which could impact pricing strategy.

---

### Query 7:Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. This analysis helps to get an idea of low and high-performing months and take strategic decisions. The final report contains these columns: Month Year Gross sales Amount.

**Purpose**: Report monthly gross sales for "Atliq Exclusive".

```sql
WITH cte1 AS (
SELECT a.customer_code,
        
 a.customer,
        
 b.date,
        
 b.product_code,
        
 b.fiscal_year,
        
 b.sold_quantity

    FROM dim_customer AS a

JOIN fact_sales_monthly AS b

    ON a.customer_code=b.customer_code
 

    WHERE a.customer="Atliq Exclusive"

),
        
cte2 AS (
SELECT a.customer_code,
        
a.customer,
        
a.date,
        
a.product_code,
        
a.fiscal_year,
        
a.sold_quantity,
        
b.gross_price
FROM cte1 AS a
JOIN fact_gross_price AS b
ON a.product_code=b.product_code)


SELECT monthname(date) AS month,
        
fiscal_year AS year,
        
round(sum(sold_quantity*gross_price)/1000000,
        2 ) AS gross_sales_amt,
        
"Milions" AS Unit
FROM cte2
GROUP BY monthname(date),
        fiscal_year;
```

**Expected Output**:
| Month     | Year | Gross Sales Amount (in Millions $) |
|-----------|------|------------------------------------|
| September | 2020 | 9.09                               |
| October   | 2020 | 10.38                              |
| November  | 2020 | 15.23                              |
| December  | 2020 | 9.76                               |
| January   | 2020 | 9.58                               |
| February  | 2020 | 8.08                               |
| March     | 2020 | 0.77                               |
| April     | 2020 | 0.80                               |
| May       | 2020 | 1.59                               |
| June      | 2020 | 3.43                               |
| July      | 2020 | 5.15                               |
| August    | 2020 | 5.64                               |
| September | 2021 | 19.53                              |
| October   | 2021 | 21.02                              |
| November  | 2021 | 32.25                              |
| December  | 2021 | 20.41                              |
| January   | 2021 | 19.57                              |
| February  | 2021 | 15.99                              |
| March     | 2021 | 19.15                              |
| April     | 2021 | 11.48                              |
| May       | 2021 | 19.20                              |
| June      | 2021 | 15.46                              |
| July      | 2021 | 19.04                              |
| August    | 2021 | 11.32                              |

**Insight**: Shows monthly sales trends for "Atliq Exclusive," useful for seasonal analysis.

---

### Query 8: 
In which quarter of 2020, got the maximum total_sold_quantity? The final output contains these fields sorted by the total_sold_quantity, Quarter total_sold_quantity.


**Purpose**: Determine which quarter had the highest sales quantity in 2020.

```sql
SELECT 
    *
FROM
    fact_sales_monthly
WHERE
    fiscal_year IN (2020 , 2021);

SELECT 
    CASE
        WHEN date BETWEEN '2019-09-01' AND '2019-11-01' THEN 1
        WHEN date BETWEEN '2019-12-01' AND '2020-02-01' THEN 2
        WHEN date BETWEEN '2020-03-01' AND '2020-05-01' THEN 3
        WHEN date BETWEEN '2020-06-01' AND '2020-08-01' THEN 4
    END AS Quarters,
    FORMAT(SUM(sold_quantity), 0) AS total_sold_quantity
FROM
    fact_sales_monthly
WHERE
    fiscal_year = 2020
GROUP BY Quarters
ORDER BY total_sold_quantity DESC;
```

**Expected Output**:
| Quarters | Total Sold Quantity |
|----------|---------------------|
| 1        | 7005619             |
| 2        | 6649642             |
| 4        | 5042541             |
| 3        | 2075087             |
**Insight**: Identifies the highest-performing quarter, aiding in quarterly planning.

---

### Query 9: Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution? The final output contains these fields, channel gross_sales_mln percentage.

**Purpose**: Identify the channel with the highest contribution to gross sales in 2021.

```sql
WITH cte1 AS 
(
			SELECT a.channel,
        
 b.product_code,
        
 b.fiscal_year,
        
 b.sold_quantity

    FROM dim_customer AS a

JOIN fact_sales_monthly AS b

    ON a.customer_code = b.customer_code

    WHERE fiscal_year = 2021
),
        

cte2 AS (
		SELECT a.channel,
        a.product_code,
        a.sold_quantity,
        b.gross_price

    FROM cte1 AS a

JOIN fact_gross_price AS b

    ON a.product_code = b.product_code
 ),
        
 
 cte3 AS (
SELECT channel,
        
			round(sum(sold_quantity*gross_price)/1000000,
        2) AS gross_sales_mln

    FROM cte2

    GROUP BY  channel)
 
 
	SELECT channel,
        gross_sales_mln,
        
			round((gross_sales_mln/total_sales)*100,
        2) AS pct_contrib

    FROM cte3,
        
		(SELECT sum(gross_sales_mln) AS total_sales
    FROM cte3) AS total

ORDER BY  gross_sales_mln desc;
```

**Expected Output**:
| Channel     | Gross Sales (In Millions $) | Percentage Contribution |
|-------------|-----------------------------|-------------------------|
| Retailer    | 1924.2                      | 73.22                   |
| Direct      | 406.7                       | 15.48                   |
| Distributor | 297.2                       | 11.31                   |

**Insight**: Indicates the most effective sales channel in 2021, useful for channel strategy.

---

### Query 10: Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021? The final output contains these fields, division product_code codebasics.io product total_sold_quantity rank_order.
**Purpose**: List the top 3 products by division based on total sales quantity for 2021.

```sql
WITH cte1 AS 

(
			SELECT a.division,
        
 a.product_code,
        
 a.product,
        
 sum(b.sold_quantity) AS total_sold_quantity

    FROM dim_product AS a

JOIN fact_sales_monthly AS b

    ON a.product_code = b.product_code

    WHERE b.fiscal_year = 2021

    GROUP BY  a.division, a.product_code, a.product
),

-- I need to show 3 top products per division, top products will be based
    ON total
-- sold quantity

cte2 AS (
	SELECT *,
        rank()
    OVER (partitiON by division
ORDER BY  total_sold_quantity desc) AS rnk

    FROM cte1 

)

SELECT *
    FROM cte2
WHERE rnk <= 3;
```

**Expected Output**:
| Division | product_code | product             | total_quantity_sold | ranking |
|----------|--------------|---------------------|---------------------|---------|
| N & S    | A6720160103  | AQ Pen Drive 2 IN 1 | 701373              | 1       |
| N & S    | A6818160202  | AQ Pen Drive DRC    | 688003              | 2       |
| N & S    | A6819160203  | AQ Pen Drive DRC    | 676245              | 3       |
| P & A    | A2319150302  | AQ Gamers Ms        | 428498              | 1       |
| P & A    | A2520150501  | AQ Maxima Ms        | 419865              | 2       |
| P & A    | A2520150504  | AQ Maxima Ms        | 419471              | 3       |
| PC       | A4218110202  | AQ Digit            | 17434               | 1       |
| PC       | A4319110306  | AQ Velocity         | 17280               | 2       |
| PC       | A4218110208  | AQ Digit            | 17275               | 3       |

**Insight**: Highlights top-performing products per division, aiding regional sales efforts.

---

## Conclusion

This project provides actionable insights into the Consumer Goods domain, covering customer behavior, product performance, and operational costs. These findings can guide strategic decisions across various business areas.

## About the Author

For questions or further information:

- **Name**: Shaun Mia
- **Email**: shaunmia.cse@gmail.com
- **LinkedIn**: [Shaun Mia](https://www.linkedin.com/in/shaun-mia/)
- **GitHub**: [shaun-mia](https://github.com/shaun-mia)
