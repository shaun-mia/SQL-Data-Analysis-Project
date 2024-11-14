select * from amazon_data;

-- List all products with a discounted price below ₹500.

select * from amazon_data
where discounted_price<500;

-- Find products with a discount percentage of 50% or more.
SELECT * 
FROM amazon_data 
WHERE discount_percentage >= 0.5;

-- Retrieve all products where the name contains the word "Cable."
SELECT * 
FROM amazon_data  
WHERE product_name LIKE '%Cable%';

-- Display the difference between the average of the actual price and the discounted price for each product.

SELECT product_id, product_name, 
       (AVG(actual_price) - AVG(discounted_price)) AS avg_price_difference
FROM amazon_data
GROUP BY product_id, product_name;

-- Query reviews that mention "fast charging" in their content.

SELECT * 
FROM amazon_data 
WHERE review_content LIKE '%fast charging%';

-- Identify products with a discount percentage between 20% and 40%.
SELECT * 
FROM amazon_data 
WHERE discount_percentage BETWEEN .2 AND .4;

-- Find products that have an actual price above ₹1,000 and are rated 4 stars or above.

SELECT * 
FROM amazon_data 
WHERE actual_price > 1000 AND rating >= 4;


-- Find products where the discounted price ends with a 9
SELECT * 
FROM amazon_data 
WHERE discounted_price LIKE '%9';


-- Display review contents that contains words like worst, waste, poor, or not good.
SELECT product_name,review_content 
FROM amazon_data 
WHERE review_content LIKE '%worst%' 
   OR review_content LIKE '%waste%' 
   OR review_content LIKE '%poor%' 
   OR review_content LIKE '%not good%';

-- List all products where the category includes "Accessories."

SELECT * 
FROM amazon_data 
WHERE category LIKE '%Accessories%';

-- Identify the Top 5 Most Discounted Products in Each Category

WITH ProductDiscounts AS (
    SELECT 
        product_id,
        category,
        discount_percentage,
        RANK() OVER (PARTITION BY category ORDER BY discount_percentage DESC) AS discount_rank
    FROM 
        amazon_data
)
SELECT 
    product_id,
    category,
    discount_percentage
FROM 
    ProductDiscounts
WHERE 
    discount_rank <= 5
ORDER BY 
    category, discount_percentage DESC;
        
   -- Calculate the Percentage of 5-Star Reviews for Each Product Relative to All Reviews

WITH FiveStarReviews AS (
    SELECT 
        product_id,
        COUNT(CASE WHEN rating = 5 THEN 1 END) AS five_star_count,
        COUNT(rating) AS total_review_count
    FROM 
        amazon_data
    GROUP BY 
        product_id
)
SELECT 
    product_id,
    five_star_count,
    total_review_count,
    ROUND((five_star_count * 100.0 / total_review_count), 2) AS five_star_percentage
FROM 
    FiveStarReviews
ORDER BY 
    five_star_percentage DESC;
    
    --  Calculate the Sales Contribution of Each Product to Its Category
    
    WITH CategorySales AS (
    SELECT 
        category,
        SUM(discounted_price) AS total_category_sales
    FROM 
        amazon_data
    GROUP BY 
        category
)
SELECT 
    a.product_id,
    a.category,
    a.discounted_price AS product_sales,
    ROUND((a.discounted_price * 100.0 / cs.total_category_sales), 2) AS sales_contribution_percentage
FROM 
    amazon_data as a
JOIN 
    CategorySales cs ON a.category = cs.category
ORDER BY 
    a.category, sales_contribution_percentage DESC;
