
# Amazon Sales Data Analysis

## Introduction

This project provides an analysis of Amazon sales data, with a focus on product pricing, discounts, ratings, and reviews. It includes SQL queries to extract insights such as high-discount products, pricing comparisons, and review sentiment analysis.

## Data Overview

The dataset, `amazon_data`, contains information on various products listed on Amazon. Each product has fields including:

- `product_id`: Unique identifier for each product.
- `product_name`: Name of the product.
- `category`: Category under which the product is listed.
- `discounted_price`: Price after discount.
- `actual_price`: Original price before discount.
- `discount_percentage`: Percentage discount applied to the product.
- `rating`: Average user rating of the product.
- `rating_count`: Number of ratings given by users.
- `about_product`: Additional information about the product.
- `user_id`: Unique identifier for each user.
- `user_name`: Name of the user.
- `review_id`: Unique identifier for each review.
- `review_title`: Title of the review.
- `review_content`: Content of the review.
- `img_link`: URL of the product image.
- `product_link`: URL of the product page on Amazon.

## Usage Queries

Below are a series of SQL queries that can be executed to extract insights from the data.

### Basic Queries

1. **View all data**:
   ```sql
   SELECT * FROM amazon_data;
   ```

2. **List products with discounted price below ₹500**:
   ```sql
   SELECT * FROM amazon_data WHERE discounted_price < 500;
   ```

3. **Find products with a discount percentage of 50% or more**:
   ```sql
   SELECT * FROM amazon_data WHERE discount_percentage >= 0.5;
   ```

4. **Retrieve products containing "Cable" in their name**:
   ```sql
   SELECT * FROM amazon_data WHERE product_name LIKE '%Cable%';
   ```

5. **Calculate the average price difference between actual and discounted prices**:
   ```sql
   SELECT product_id, product_name, 
          (AVG(actual_price) - AVG(discounted_price)) AS avg_price_difference
   FROM amazon_data
   GROUP BY product_id, product_name;
   ```

6. **Find reviews mentioning "fast charging"**:
   ```sql
   SELECT * FROM amazon_data WHERE review_content LIKE '%fast charging%';
   ```

7. **Identify products with a discount percentage between 20% and 40%**:
   ```sql
   SELECT * FROM amazon_data WHERE discount_percentage BETWEEN 0.2 AND 0.4;
   ```

8. **Find products priced above ₹1,000 with ratings 4 or above**:
   ```sql
   SELECT * FROM amazon_data WHERE actual_price > 1000 AND rating >= 4;
   ```

9. **Products with a discounted price ending in 9**:
   ```sql
   SELECT * FROM amazon_data WHERE discounted_price LIKE '%9';
   ```

10. **Display reviews with negative sentiment**:
   ```sql
   SELECT product_name, review_content 
   FROM amazon_data 
   WHERE review_content LIKE '%worst%' 
      OR review_content LIKE '%waste%' 
      OR review_content LIKE '%poor%' 
      OR review_content LIKE '%not good%';
   ```

11. **List products in the "Accessories" category**:
   ```sql
   SELECT * FROM amazon_data WHERE category LIKE '%Accessories%';
   ```

### Advanced Queries

1. **Top 5 most discounted products in each category**:
   ```sql
   WITH ProductDiscounts AS (
       SELECT 
           product_id,
           category,
           discount_percentage,
           RANK() OVER (PARTITION BY category ORDER BY discount_percentage DESC) AS discount_rank
       FROM amazon_data
   )
   SELECT 
       product_id,
       category,
       discount_percentage
   FROM ProductDiscounts
   WHERE discount_rank <= 5
   ORDER BY category, discount_percentage DESC;
   ```

2. **Percentage of 5-star reviews for each product**:
   ```sql
   WITH FiveStarReviews AS (
       SELECT 
           product_id,
           COUNT(CASE WHEN rating = 5 THEN 1 END) AS five_star_count,
           COUNT(rating) AS total_review_count
       FROM amazon_data
       GROUP BY product_id
   )
   SELECT 
       product_id,
       five_star_count,
       total_review_count,
       ROUND((five_star_count * 100.0 / total_review_count), 2) AS five_star_percentage
   FROM FiveStarReviews
   ORDER BY five_star_percentage DESC;
   ```

3. **Sales contribution of each product to its category**:
   ```sql
   WITH CategorySales AS (
       SELECT 
           category,
           SUM(discounted_price) AS total_category_sales
       FROM amazon_data
       GROUP BY category
   )
   SELECT 
       a.product_id,
       a.category,
       a.discounted_price AS product_sales,
       ROUND((a.discounted_price * 100.0 / cs.total_category_sales), 2) AS sales_contribution_percentage
   FROM amazon_data AS a
   JOIN CategorySales cs ON a.category = cs.category
   ORDER BY a.category, sales_contribution_percentage DESC;
   ```


## Conclusion

This README provides a structured approach for analyzing Amazon sales data, covering basic queries, advanced CTE and window functions, and sample outputs. These queries help in understanding product performance, customer feedback, and sales distribution within categories. The insights obtained can assist in identifying top-performing products, customer sentiment, and category-wise product contribution, providing a comprehensive view of Amazon’s sales dynamics.
``` 
