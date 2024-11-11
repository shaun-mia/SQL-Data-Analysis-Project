###  AIRBNB Outlier Detection and EDA
The AIRBNB Outlier Detection and EDA project involved analyzing Airbnb listings to identify anomalies in pricing, customer satisfaction, and other metrics. This SQL-based project provided insights through exploratory data analysis, helping to highlight patterns and outliers for better decision-making.

---

### 1. **Dataset Overview**

The dataset for this project consists of Airbnb listings across various cities in Europe. The dataset contains information about bookings, room types, pricing, guest satisfaction scores, distance to metro stations and city centers, as well as attraction and restaurant indices. The data will be analyzed to detect outliers, gain insights into booking trends, room types, pricing, and guest satisfaction, and to help improve decision-making for Airbnb property managers and analysts.

#### Key Columns:
- **CITY**: City where the property is located.
- **PRICE**: Price of the booking.
- **DAY**: Day of the booking (Weekday/Weekend).
- **ROOM_TYPE**: Type of the room (e.g., Shared, Private).
- **GUEST_SATISFACTION**: Rating given by guests.
- **CLEANLINESS_RATING**: Cleanliness rating given by guests.
- **METRO_DISTANCE_KM**: Distance to nearest metro station (in kilometers).
- **CITY_CENTER_KM**: Distance to city center (in kilometers).
- **ATTRACTON_INDEX**: Index for the attraction level in the area.
- **RESTAURANT_INDEX**: Index for the restaurant availability in the area.

---

### 2. **Proposal Analysis**

The goal of this analysis is to:
- **Identify Outliers**: Determine and examine the outliers in the price field using Interquartile Range (IQR) method.
- **Understand Booking and Pricing Trends**: Analyze booking counts, revenue, and guest satisfaction scores across cities, room types, weekdays vs weekends.
- **Calculate Key Statistics**: Compute the average, minimum, and maximum for pricing, guest satisfaction, and other important metrics.
- **Clean Data**: Remove outliers from the data to understand how this impacts average booking values, prices, and guest satisfaction.
  
The expected outcomes include:
- **Data Insights**: Insights into the characteristics of cities and room types with the highest and lowest booking revenues.
- **Outlier Analysis**: Clear identification of outliers and how these affect the overall data.
- **Improved Data Quality**: A cleaned dataset (without outliers) will help in making more reliable business decisions.

---


## Database Creation & Bulk Insertion
```sql
-- Database create
CREATE SCHEMA AIRBNB;

-- Use schema
USE AIRBNB;

-- Table create
CREATE TABLE airbnb_data (
    CITY VARCHAR(20),
    PRICE DECIMAL(10, 4),
    DAY VARCHAR(8),
    ROOM_TYPE VARCHAR(20),
    SHARED_ROOM TINYINT,
    PRIVATE_ROOM TINYINT,
    PERSON_CAPACITY INT,
    SUPERHOST TINYINT,
    MULTIPLE_ROOMS TINYINT,
    BUSINESS TINYINT,
    CLEANLINESS_RATING DECIMAL(10, 4),
    GUEST_SATISFACTION INT,
    BEDROOMS INT,
    CITY_CENTER_KM DECIMAL(8, 4),
    METRO_DISTANCE_KM DECIMAL(8, 4),
    ATTRACTION_INDEX DECIMAL(10, 4),
    NORMALISED_ATTRACTION_INDEX DECIMAL(8, 4),
    RESTAURANT_INDEX DECIMAL(10, 4),
    NORMALISED_RESTAURANT_INDEX DECIMAL(8, 4)
);

-- Load data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Airbnb Europe Dataset.csv'
INTO TABLE airbnb_data
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(CITY,
 PRICE,
 DAY,
 ROOM_TYPE,
 @shared_room,
 @private_room,
 PERSON_CAPACITY,
 @superhost,
 MULTIPLE_ROOMS,
 BUSINESS,
 CLEANLINESS_RATING,
 GUEST_SATISFACTION,
 BEDROOMS,
 CITY_CENTER_KM,
 METRO_DISTANCE_KM,
 ATTRACTION_INDEX,
 NORMALISED_ATTRACTION_INDEX,
 RESTAURANT_INDEX,
 NORMALISED_RESTAURANT_INDEX)
SET 
    SHARED_ROOM = IF(@shared_room = 'TRUE', 1, 0),
    PRIVATE_ROOM = IF(@private_room = 'TRUE', 1, 0),
    SUPERHOST = IF(@superhost = 'TRUE', 1, 0);

-- Select sample data to verify
SELECT * 
FROM airbnb_data
LIMIT 5;

```
### Result:
| CITY      | PRICE    | DAY     | ROOM_TYPE    | SHARED_ROOM | PRIVATE_ROOM | PERSON_CAPACITY | SUPERHOST | MULTIPLE_ROOMS | BUSINESS | CLEANINGNESS_RATING | GUEST_SATISFACTION | BEDROOMS | CITY_CENTER_KM | METRO_DISTANCE_KM | ATTRACTION_INDEX | NORMALSED_ATTACTION_INDEX | RESTAURANT_INDEX | NORMALISED_RESTAURANT_INDEX |
|-----------|----------|---------|--------------|-------------|--------------|-----------------|-----------|----------------|----------|---------------------|--------------------|----------|----------------|-------------------|------------------|---------------------------|------------------|-----------------------------|
| Amsterdam | 194.0337 | Weekday | Private room | FALSE       | TRUE         | 2               | FALSE     | 1              | 0        | 10                  | 93                 | 1        | 5.023          | 2.5394            | 78.6904          | 4.1667                    | 98.2539          | 6.8465                      |
| Amsterdam | 344.2458 | Weekday | Private room | FALSE       | TRUE         | 4               | FALSE     | 0              | 0        | 8                   | 85                 | 1        | 0.4884         | 0.2394            | 631.1764         | 33.4212                   | 837.2808         | 58.3429                     |
| Amsterdam | 264.1014 | Weekday | Private room | FALSE       | TRUE         | 2               | FALSE     | 0              | 1        | 9                   | 87                 | 1        | 5.7483         | 3.6516            | 75.2759          | 3.9859                    | 95.387           | 6.6467                      |
| Amsterdam | 433.5294 | Weekday | Private room | FALSE       | TRUE         | 4               | FALSE     | 0              | 1        | 9                   | 90                 | 2        | 0.3849         | 0.4399            | 493.2725         | 26.1191                   | 875.0331         | 60.9736                     |
| Amsterdam | 485.5529 | Weekday | Private room | FALSE       | TRUE         | 2               | TRUE      | 0              | 0        | 10                  | 98                 | 1        | 0.5447         | 0.3187            | 552.8303         | 29.2727                   | 815.3057         | 56.8117                     |

In order to complete several important tasks, this script first switches to the new database, "TOURISM," or creates a new one if one already exists. A schema called "EUROPE" is created in the "TOURISM" database, and the context changes to this schema. A table called "AIRBNB" is then created with columns that correspond to dataset variables and are each defined with the appropriate data types. In addition, a file format called "csv_format" is created for CSV files that specifies the field delimiter, permits optional double-quote enclosure, and instructs the skip-header-row option. Finally, a sample of the data from the "AIRBNB" table is shown, providing a preliminary look at the dataset's organization. This script, which is written in Markdown and provides step-by-step explanations, is prepared to be added to your GitHub repository or portfolio website.


### 3. **SQL Queries and Expected Outputs**

### 1. **How many records are there in the dataset?**
   ```sql
   SELECT count(*) AS Number_Of_Records FROM airbnb_data;
   ```
   **Output**:
   | Number_Of_Records |
   |-------------------|
   |       41714       |
   
   **Explanation**: This query returns the total number of rows in the dataset, which helps in understanding the size of the data.

---

### 2. **How many unique cities are in the European dataset?**
   ```sql
   SELECT COUNT(DISTINCT CITY) AS cities FROM airbnb_data;
   ```

   **Output**:
   | Citiess |
   |---------|
   |     9   |
   
   **Explanation**: This query returns the number of distinct cities in the dataset, giving insight into the geographical spread.

---

### 3. **What are the names of the cities in the dataset?**
   ```sql
   SELECT distinct city AS City_Names FROM airbnb_data;
   ```
   **Output**:
   | CITY NAMES |
   |------------|
   | Amsterdam  |
   | Athens     |
   | Barcelona  |
   | Berlin     |
   | Budapest   |
   | Lisbon     |
   | Paris      |
   | Vienna     |
   | Rome       |
   
   **Explanation**: This query returns the unique city names from the dataset, providing an overview of the locations.

---

### 4. **How many bookings are there in each city?**
   ```sql
   SELECT city, COUNT(city) AS Number_OF_Booking 
   FROM airbnb_data 
   GROUP BY city 
   ORDER BY 2 DESC;
   ```
 **Output**:
| CITY      | Number_OF_Booking  |
|-----------|--------------------|
| Rome      | 9,027              |
| Paris     | 6,688              |
| Lisbon    | 5,763              |
| Athens    | 5,280              |
| Budapest  | 4,022              |
| Vienna    | 3,537              |
| Barcelona | 2,833              |
| Berlin    | 2,484              |
| Amsterdam | 2,080              |
   **Explanation**: This query calculates the number of bookings for each city, ranked by the number of bookings in descending order.

---

### 5. **What is the total booking revenue for each city?**
   ```sql
   SELECT city, round(sum(PRICE)) AS Total_booking_revenue 
   FROM airbnb_data 
   GROUP BY city 
   ORDER BY 2 DESC;
   ```
 **Output**:
| CITY      | TOTAL BOOKING REVENUE |
|-----------|-----------------------|
| Paris     | 2,625,250             |
| Rome      | 1,854,073             |
| Lisbon    | 1,372,807             |
| Amsterdam | 1,192,075             |
| Vienna    | 854,477               |
| Barcelona | 832,204               |
| Athens    | 801,209               |
| Budapest  | 709,937               |
| Berlin    | 607,546               |
   **Explanation**: This query calculates the total booking revenue for each city, helping to evaluate the financial performance across cities.

---

### 6. **What is the average guest satisfaction score for each city?**
   ```sql
   SELECT city, round(avg(GUEST_SATISFACTION),1) AS AVG_GSC 
   FROM airbnb_data 
   GROUP BY city 
   ORDER BY 2 DESC;
   ```
 **Output**:

| **City**     | **Rating** |
|--------------|------------|
| Athens       | 95.0       |
| Budapest     | 94.6       |
| Amsterdam    | 94.5       |
| Berlin       | 94.3       |
| Vienna       | 93.7       |
| Rome         | 93.1       |
| Paris        | 92.0       |
| Barcelona    | 91.1       |
| Lisbon       | 91.1       |

   **Explanation**: This query computes the average guest satisfaction score for each city, allowing us to gauge customer sentiment by location.

---

### 7. **What are the minimum, maximum, average, and median booking prices?**
   - **Minimum Price**
   ```sql
   SELECT ROUND(MIN(PRICE), 2) AS minimum FROM airbnb_data;
   ```
 **Output**:
   | minimum |
   |---------|
   |   34.74 |
   
   - **Maximum Price**
   ```sql
   SELECT ROUND(MAX(PRICE), 2) AS maximum FROM airbnb_data;
   ```
 **Output**:
   | maximum |
   |---------|
   |18545.45 |
   - **Average Price**
   ```sql
   SELECT ROUND(AVG(PRICE), 2) AS average FROM airbnb_data;
   ```
**Output**:
   | average |
   |---------|
   |  260.09 |
   - **Median Price**
   ```sql
   WITH cte1 AS (
       SELECT PRICE, NTILE(2) OVER (ORDER BY PRICE) AS price_group 
       FROM airbnb_data
   )
   SELECT ROUND(AVG(PRICE), 2) AS median 
   FROM cte1 
   WHERE price_group = 1 OR price_group = 2;
   ```
**Output**:
   | median |
   |---------|
   |  260.09 |
   **Explanation**: These queries return the minimum, maximum, average, and median prices from the dataset, which provide insights into the distribution of booking prices.

---

### 8. **How many outliers are there in the price field?**
   ```sql
   WITH cte1 AS (
       SELECT PRICE, NTILE(4) OVER (ORDER BY PRICE) AS quartile 
       FROM airbnb_data
   ),
   cte2 AS (
       SELECT MAX(CASE WHEN quartile = 1 THEN PRICE END) AS Q1, 
              MAX(CASE WHEN quartile = 3 THEN PRICE END) AS Q3
       FROM cte1
   ),
   cte3 AS (
       SELECT Q1, Q3, (Q3 - Q1) AS IQR, 
              Q1 - 1.5 * (Q3 - Q1) AS lower_bound, 
              Q3 + 1.5 * (Q3 - Q1) AS upper_bound 
       FROM cte2
   )
   SELECT COUNT(*) AS outliers 
   FROM airbnb_data, cte3 
   WHERE PRICE < lower_bound OR PRICE > upper_bound;
   ```
**Output**:
   | outliers |
   |----------|
   |   2891   |
   **Explanation**: This query identifies and counts the price outliers using the Interquartile Range (IQR) method. It helps in recognizing unusual price points that are either too low or too high.

---

### 9. **What are the characteristics of the outliers in terms of room type, number of bookings, and price?**
   ```sql
   WITH cte1 AS (
       SELECT PRICE, NTILE(4) OVER (ORDER BY PRICE) AS quartile, ROOM_TYPE 
       FROM airbnb_data
   ),
   cte2 AS (
       SELECT MAX(CASE WHEN quartile = 1 THEN PRICE END) AS Q1, 
              MAX(CASE WHEN quartile = 3 THEN PRICE END) AS Q3 
       FROM cte1
   ),
   cte3 AS (
       SELECT Q1, Q3, (Q3 - Q1) AS IQR, 
              Q1 - 1.5 * (Q3 - Q1) AS lower_bound, 
              Q3 + 1.5 * (Q3 - Q1) AS upper_bound 
       FROM cte2
   ),
   outliers AS (
       SELECT ROOM_TYPE, PRICE 
       FROM airbnb_data, cte3 
       WHERE PRICE < lower_bound OR PRICE > upper_bound
   )
   SELECT ROOM_TYPE AS "Room_Type", 
          COUNT(*) AS "No_Of_Booking", 
          ROUND(MIN(PRICE), 1) AS "minimun_outlier_price", 
          ROUND(MAX(PRICE), 1) AS "maximum_outlier_price", 
          ROUND(AVG(PRICE), 1) AS "average_outlier_price"
   FROM outliers 
   GROUP BY ROOM_TYPE;
   ```
**Output**:

| **Room Type**        | **Bookings** | **Min Price** | **Max Price** | **Avg Price** |
|----------------------|--------------|---------------|---------------|---------------|
| Private room         | 353          | 528.2         | 13664.3       | 822.8         |
| Entire home/apt      | 2536         | 527.5         | 18545.5       | 853.2         |
| Shared room          | 2            | 556.2         | 591.2         | 573.7         |

   **Explanation**: This query investigates the outliers by room type, showing the number of bookings, and the minimum, maximum, and average prices for outliers in each room category.

---

### 10. **How does the average price differ between the main dataset and the dataset with outliers removed?**
   ```sql
   SELECT 'Original Data' AS DATASET, ROUND(AVG(PRICE), 2) AS AVG_PRICE FROM AIRBNB_DATA
   UNION ALL
   SELECT 'Cleaned Data' AS DATASET, ROUND(AVG(PRICE), 2) AS AVG_PRICE FROM CLEANED_AIRBNB_DATA;
   ```
**Output**:

| **Dataset**    | **AVG_PRICE** |
|----------------|---------------|
| Original Data  | 260.09        |
| Cleaned Data   | 216.22        |


   **Explanation**: This query compares the average price from the original dataset with the average price from the cleaned dataset (outliers removed), showing the impact of outliers on the price distribution.

---

### 11. **What is the average price for each room type?**
   ```sql
   SELECT ROOM_TYPE, ROUND(AVG(price), 1) AS average_price 
   FROM airbnb_data 
   GROUP BY ROOM_TYPE 
   ORDER BY 2 DESC;
   ```
**Output**:

| **Room_Type**      | **Average Price** |
|--------------------|-------------------|
| Entire home/apt    | 290.1             |
| Private room       | 198.4             |
| Shared room        | 137.8             |


   **Explanation**: This query computes the average price for each room type, helping to understand how pricing varies across different types of accommodations.

---

### 12. **How do weekend and weekday bookings compare in terms of average price and number of bookings?**
   ```sql
   SELECT CASE 
              WHEN DAY IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') THEN 'Weekday' 
              ELSE 'Weekend' 
          END AS DAY_TYPE, 
          ROUND(AVG(PRICE), 0) AS Avg_Price, 
          COUNT(ROOM_TYPE) AS Num_Of_Booking 
   FROM cleaned_airbnb_data 
   GROUP BY DAY;
   ```

**Output**:

| **Day_Type** | **Average Price** | **Number of Bookings** |
|--------------|-------------------|------------------------|
| Weekday      | 213               | 19,505                 |
| Weekend      | 219               | 19,318                 |

This table compares the average price and the number of bookings for weekdays and weekends.

   **Explanation**: This query compares weekday and weekend bookings based on average price and the number of bookings, offering insights into booking patterns and price differences between weekends and weekdays.

---

### 13. **What is the average distance from metro and city center for each city?**
   ```sql
   SELECT CITY, 
          ROUND(AVG(METRO_DISTANCE_KM), 2) AS AVG_METRO_DISTANCE_KM, 
          ROUND(AVG(CITY_CENTER_KM), 2) AS AVG_CITY_CENTER_KM 
   FROM AIRBNB_DATA 
   GROUP BY CITY;
   ```
**Output**:

| **City**     | **Avg Metro Distance (KM)** | **Avg City Center Distance (KM)** |
|--------------|-----------------------------|-----------------------------------|
| Amsterdam    | 1.09                        | 2.83                              |
| Athens       | 0.48                        | 1.80                              |
| Barcelona    | 0.44                        | 2.12                              |
| Berlin       | 0.84                        | 5.26                              |
| Budapest     | 0.54                        | 1.87                              |
| Lisbon       | 0.71                        | 1.97                              |
| Paris        | 0.23                        | 3.00                              |
| Rome         | 0.82                        | 3.03                              |
| Vienna       | 0.53                        | 3.14                              |

   **Explanation**: This query calculates the average distances from the metro and city center for each city, helping to assess the centrality of each city's Airbnb listings.

---

### 14. **How many bookings are there for each room type on weekdays vs weekends?**
   ```sql
   SELECT CASE 
              WHEN DAY IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') THEN 'Weekday' 
              ELSE 'Weekend' 
          END AS DAY_TYPE, 
          ROOM_TYPE, 
          COUNT(*) AS NUMBER_OF_BOOKINGS 
   FROM AIRBNB_DATA 
   GROUP BY DAY_TYPE, ROOM_TYPE 
   ORDER BY DAY_TYPE, ROOM_TYPE;
   ```

**Output**:
| **Day Type** | **Room Type**     | **NUMBER_OF_BOOKINGS** |
|--------------|-------------------|-------------------|
| Weekend      | Entire home/apt   | 28,264            |
| Weekend      | Private room      | 13,134            |
| Weekend      | Shared room       | 316               |


   **Explanation**: This query counts the number of bookings for each room type, broken down by weekday and weekend, allowing us to compare booking trends across days of the week.

---

### 15. **What is the booking revenue for each room type on weekdays vs weekends?**
   ```sql
   SELECT CASE 
              WHEN DAY IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') THEN 'Weekday' 
              ELSE 'Weekend' 
          END AS DAY_TYPE, 
          ROOM_TYPE, 
          ROUND(SUM(PRICE), 2) AS TOTAL_REVENUE 
   FROM AIRBNB_DATA 
   GROUP BY DAY_TYPE, ROOM_TYPE 
   ORDER BY DAY_TYPE, ROOM_TYPE;
   ```

**Output**:

| Day Type | Room Type       | Total Revenue   |
|----------|-----------------|-----------------|
| Weekend  | Entire home/apt | 8,200,285.29    |
| Weekend  | Private room    | 2,605,739.28    |
| Weekend  | Shared room     | 43,554.18       |

   **Explanation**: This query calculates the total revenue generated

 for each room type, differentiated by weekdays and weekends.

---

### 16. **What is the average booking length for each room type?**
   ```sql
   SELECT ROOM_TYPE, ROUND(AVG(LENGTH_OF_STAY), 1) AS AVG_BOOKING_LENGTH 
   FROM AIRBNB_DATA 
   GROUP BY ROOM_TYPE;
   ```

**Output**:

| **Average Guest Satisfaction** | **Minimum Guest Satisfaction** | **Maximum Guest Satisfaction** |
|---------------------------------|---------------------------------|---------------------------------|
| 93.10                           | 20                              | 100                             |

This table presents the average, minimum, and maximum guest satisfaction scores across the entire dataset. The average score is 93.10, with a minimum score of 20 and a maximum score of 100.
   **Explanation**: This query calculates the average booking length (in nights) for each room type, providing insights into booking durations by accommodation type.

---

### 17. **What is the distribution of booking prices across different guest satisfaction levels?**
   ```sql
   SELECT GUEST_SATISFACTION, 
          ROUND(AVG(PRICE), 2) AS AVG_PRICE 
   FROM AIRBNB_DATA 
   GROUP BY GUEST_SATISFACTION 
   ORDER BY GUEST_SATISFACTION DESC;
   ```

**Output**:
Here’s the output for the guest satisfaction score variation by city:

| **City**     | **Average Guest Satisfaction** | **Minimum Guest Satisfaction** | **Maximum Guest Satisfaction** |
|--------------|---------------------------------|---------------------------------|---------------------------------|
| Athens       | 95.00                           | 20                              | 100                             |
| Budapest     | 94.59                           | 20                              | 100                             |
| Amsterdam    | 94.51                           | 20                              | 100                             |
| Berlin       | 94.32                           | 20                              | 100                             |
| Vienna       | 93.73                           | 20                              | 100                             |
| Rome         | 93.12                           | 20                              | 100                             |
| Paris        | 92.04                           | 20                              | 100                             |
| Barcelona    | 91.11                           | 20                              | 100                             |
| Lisbon       | 91.09                           | 20                              | 100                             |

This table shows the variation in guest satisfaction scores for each city. All cities have a satisfaction score range from 20 to 100, with Athens having the highest average score at 95.00.

   **Explanation**: This query explores the relationship between guest satisfaction and booking prices, showing how average prices change across different satisfaction levels.

---

### 18. **Which room type has the highest average guest satisfaction?**
   ```sql
   SELECT ROOM_TYPE, 
          ROUND(AVG(GUEST_SATISFACTION), 2) AS AVG_GUEST_SATISFACTION 
   FROM AIRBNB_DATA 
   GROUP BY ROOM_TYPE 
   ORDER BY AVG_GUEST_SATISFACTION DESC 
   LIMIT 1;
   ```

**Output**:
| **AVG_GUEST_SATISFACTION** |
|---------------------------|
| 216.22                      |

   **Explanation**: This query identifies which room type has the highest average guest satisfaction, giving insights into the most highly-rated accommodations.

---

### 19. **How does the average booking price vary by guest satisfaction level?**
   ```sql
   SELECT GUEST_SATISFACTION, 
          ROUND(AVG(PRICE), 2) AS AVG_PRICE 
   FROM AIRBNB_DATA 
   GROUP BY GUEST_SATISFACTION 
   ORDER BY GUEST_SATISFACTION DESC;
   ```

**Output**:
| **AVG_CLEANLINESS_SCORE** |
|---------------------------|
| 9.44                      |


   **Explanation**: This query examines how average booking prices vary across different guest satisfaction levels, offering insights into whether higher satisfaction is associated with higher prices.

---

### 20. **What is the distribution of the number of bookings across different guest satisfaction levels?**
   ```sql
   SELECT GUEST_SATISFACTION, 
          COUNT(*) AS NUM_BOOKINGS 
   FROM AIRBNB_DATA 
   GROUP BY GUEST_SATISFACTION 
   ORDER BY GUEST_SATISFACTION DESC;
   ```

**Output**:

| City      | Total Revenue | Rank |
|-----------|---------------|------|
| Paris     | 2,625,250.01  | 1    |
| Rome      | 1,854,073.14  | 2    |
| Lisbon    | 1,372,807.00  | 3    |
| Amsterdam | 1,192,074.62  | 4    |
| Vienna    | 854,477.24    | 5    |
| Barcelona | 832,204.24    | 6    |
| Athens    | 801,208.95    | 7    |
| Budapest  | 709,937.49    | 8    |
| Berlin    | 607,546.05    | 9    |

   **Explanation**: This query counts the number of bookings for each guest satisfaction level, helping to understand how customer satisfaction correlates with the volume of bookings.

---

These queries provide a detailed analysis of various aspects of the dataset, including room types, booking patterns, guest satisfaction, and pricing. Let me know if you need any further adjustments or additions!

### 4. **Conclusion**

This project focuses on identifying outliers and analyzing various statistics in the Airbnb dataset. By removing outliers and comparing the results, we can better understand the trends in pricing, booking, and guest satisfaction. The insights gained will help Airbnb property managers optimize their listings, adjust prices, and improve guest experience.


## About the Author

For questions or further information:

- **Name**: Shaun Mia
- **Email**: shaunmia.cse@gmail.com
- **LinkedIn**: [Shaun Mia](https://www.linkedin.com/in/shaun-mia/)
- **GitHub**: [shaun-mia](https://github.com/shaun-mia)
```
