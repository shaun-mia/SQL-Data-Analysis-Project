-- Provide the list of markets in which customer "Atliq Exclusive" operates its
--  business in the APAC region.

use gdb023;

select distinct market from dim_customer
where customer ="Atliq Exclusive" and  region="APAC";

-- What is the percentage of unique product increase in 2021 vs. 2020? 
-- The final output contains these fields, unique_products_2020 unique_products_2021 
-- percentage_chg
with cte1 as (
select count(distinct product_code) as unique_product_2021 from fact_sales_monthly
where fiscal_year = 2021
),
 cte2 as
    (
select count(distinct product_code) as unique_product_2020 from fact_sales_monthly
where fiscal_year = 2020
),
cte3 as (
select unique_product_2021, unique_product_2020
from cte1
cross join cte2
)
select*,ROUND ((( unique_product_2021-unique_product_2020)/ unique_product_2020)*100 ,1 )as pct_change
from cte3;
-- (334-245)/245=36.3265

-- Provide a report with all the unique product counts for each segment and sort 
-- them in descending order of product counts. 
-- The final output contains 2 fields, segment product_count
SELECT *  
from dim_product;

select segment,
count( product_code) as product_count
from dim_product
group by segment
order by product_count desc;

-- Follow-up: Which segment had the most increase in unique products in  2021 vs 2020? 

select count(distinct product_code) as unique_product_2020 from fact_sales_monthly
where fiscal_year = 2020;

select 
	p.segment,
    count(distinct case when S.fiscal_year = 2020 then S.product_code end) as product_count_2020,
	count(distinct case when S.fiscal_year = 2021 then S.product_code end) as product_count_2021,
    
    (count(distinct case when S.fiscal_year = 2021 then S.product_code end)-
    count(distinct case when S.fiscal_year = 2020 then S.product_code end)) as difference

from dim_product as p
left join fact_sales_monthly as S on p.product_code = S.product_code
where S.fiscal_year in (2020, 2021)
group by p.segment
order by difference desc; 

-- Get the products that have the highest and lowest manufacturing costs.
with cte1 as (

		select a.customer_code,
        a.customer, a.market, b.fiscal_year, b.pre_invoice_discount_pct
        from dim_customer as a
        join fact_pre_invoice_deductions as b
        on a.customer_code = b.customer_code

),
cte2 as 
(
			select customer_code,
            customer,
            market,
            fiscal_year,
            avg(pre_invoice_discount_pct) as average_discount_pct
            from cte1
            where fiscal_year = 2021 and market = 'India'
            group by customer_code, customer, market, fiscal_year
)

select customer_code, customer, round(average_discount_pct*100, 2) as average_discount_pct
 from cte2
 order by average_discount_pct desc
 limit 5;
        
        
