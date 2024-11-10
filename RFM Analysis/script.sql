create schema rfm_analysis;
use rfm_analysis;
select ORDERDATE from rfm_data;

-- We need to calculate each metrics
select max(ORDERDATE) from rfm_data;

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
