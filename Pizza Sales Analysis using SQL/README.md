# Pizza Sales Analysis Using SQL

## Project Overview

The goal of this project is to analyze pizza sales data using SQL queries. The data comes from multiple related tables that store information about orders, pizzas, and sales transactions. By executing a series of SQL queries, we aim to gain insights into the pizza sales trends, revenue generation, customer preferences, and other critical metrics.

### Key Features
1. **Total Orders**: Count the total number of pizza orders placed.
2. **Revenue Analysis**: Calculate the total revenue generated from pizza sales.
3. **Most Expensive Pizza**: Identify the highest-priced pizza in the database.
4. **Most Common Pizza Size**: Determine the most frequently ordered pizza size.
5. **Top 5 Most Ordered Pizza Types**: Find the top 5 most ordered pizza types and their quantities.
6. **Pizza Category Distribution**: Determine the quantity of pizzas ordered by their category.
7. **Order Distribution by Hour**: Analyze the distribution of pizza orders throughout the day.
8. **Category-Wise Distribution**: Examine the quantity of pizzas ordered by their category.
9. **Average Number of Pizzas Ordered Per Day**: Calculate the average number of pizzas ordered per day.
10. **Top 3 Revenue-Generating Pizza Types**: Identify the top 3 pizza types by total revenue.
11. **Revenue Contribution by Category**: Calculate the percentage contribution of each pizza type to total revenue.
12. **Cumulative Revenue Analysis**: Analyze the cumulative revenue generated over time.

This repository contains a collection of SQL queries and their results based on a pizza sales database. The analysis includes total sales, revenue, most popular pizzas, and other metrics based on orders.

## SQL Query Script and Results

### 1. **Total Number of Orders**

#### SQL Query:
```sql
SELECT COUNT(*) AS total_orders FROM orders;
```

#### Output Table:
| total_orders |
|--------------|
| 21350        |

### 2. **Total Revenue from Pizza Sales**

#### SQL Query:
```sql
SELECT SUM(price * quantity) AS total_sales
FROM orders
JOIN pizzas ON orders.pizza_id = pizzas.id;
```

#### Output Table:
| total_sales |
|-------------|
| 817860.05   |

### 3. **Highest-Priced Pizza**

#### SQL Query:
```sql
SELECT name, price
FROM pizzas
ORDER BY price DESC
LIMIT 1;
```

#### Output Table:
| name              | price |
|-------------------|-------|
| The Greek Pizza   | 35.95 |

### 4. **Most Common Pizza Sizes Ordered**

#### SQL Query:
```sql
SELECT size, COUNT(*) AS order_count
FROM orders
JOIN pizzas ON orders.pizza_id = pizzas.id
GROUP BY size
ORDER BY order_count DESC;
```

#### Output Table:
| size | order_count |
|------|-------------|
| L    | 18526       |
| M    | 14137       |
| S    | 544         |
| XL   | 28          |
| XXL  | 1           |

### 5. **Top 5 Most Ordered Pizza Types by Quantity**

#### SQL Query:
```sql
SELECT name, SUM(quantity) AS quantity
FROM orders
JOIN pizzas ON orders.pizza_id = pizzas.id
GROUP BY name
ORDER BY quantity DESC
LIMIT 5;
```

#### Output Table:
| name                      | quantity |
|---------------------------|----------|
| The Classic Deluxe Pizza   | 2453     |
| The Barbecue Chicken Pizza | 2432     |
| The Hawaiian Pizza         | 2422     |
| The Pepperoni Pizza        | 2418     |
| The Thai Chicken Pizza     | 2371     |

### 6. **Total Quantity Ordered per Pizza Category**

#### SQL Query:
```sql
SELECT category, SUM(quantity) AS quantity
FROM orders
JOIN pizzas ON orders.pizza_id = pizzas.id
GROUP BY category;
```

#### Output Table:
| category | quantity |
|----------|----------|
| Classic  | 2453     |
| Supreme  | 2432     |
| Veggie   | 2422     |
| Chicken  | 2418     |
| Thai     | 2371     |

### 7. **Orders by Hour of the Day**

#### SQL Query:
```sql
SELECT EXTRACT(HOUR FROM order_time) AS hour, COUNT(*) AS order_count
FROM orders
GROUP BY hour
ORDER BY order_count DESC;
```

#### Output Table:
| hour | order_count |
|------|-------------|
| 11   | 1231        |
| 12   | 2520        |
| 13   | 2455        |
| 14   | 1472        |
| 15   | 1468        |
| 16   | 1920        |
| 17   | 2336        |
| 18   | 2399        |
| 19   | 2009        |
| 20   | 1642        |
| 21   | 1198        |
| 22   | 663         |
| 23   | 28          |
| 10   | 8           |
| 9    | 1           |

### 8. **Category-wise Distribution of Pizzas**

#### SQL Query:
```sql
SELECT category, COUNT(*) AS count
FROM pizzas
GROUP BY category;
```

#### Output Table:
| category | count |
|----------|-------|
| Chicken  | 6     |
| Classic  | 8     |
| Supreme  | 9     |
| Veggie   | 9     |

### 9. **Average Number of Pizzas Ordered per Day**

#### SQL Query:
```sql
SELECT AVG(order_count) AS avg_pizza_ordered_per_day
FROM (SELECT COUNT(*) AS order_count FROM orders GROUP BY DATE(order_time)) AS daily_orders;
```

#### Output Table:
| avg_pizza_ordered_per_day |
|---------------------------|
| 138                       |

### 10. **Top 3 Most Ordered Pizza Types by Revenue**

#### SQL Query:
```sql
SELECT name, SUM(price * quantity) AS revenue
FROM orders
JOIN pizzas ON orders.pizza_id = pizzas.id
GROUP BY name
ORDER BY revenue DESC
LIMIT 3;
```

#### Output Table:
| name                      | revenue |
|---------------------------|---------|
| The Thai Chicken Pizza     | 43434   |
| The Barbecue Chicken Pizza | 42768   |
| The California Chicken Pizza | 41410  |

### 11. **Percentage Contribution of Each Pizza Type to Total Revenue**

#### SQL Query:
```sql
SELECT category, 
       SUM(price * quantity) / (SELECT SUM(price * quantity) FROM orders JOIN pizzas ON orders.pizza_id = pizzas.id) * 100 AS revenue_percentage
FROM orders
JOIN pizzas ON orders.pizza_id = pizzas.id
GROUP BY category;
```

#### Output Table:
| category | revenue_percentage |
|----------|--------------------|
| Classic  | 26.91              |
| Supreme  | 25.46              |
| Chicken  | 23.96              |
| Veggie   | 23.68              |

### 12. **Cumulative Revenue Over Time**

#### SQL Query:
```sql
SELECT order_date, 
       SUM(price * quantity) OVER (ORDER BY order_date) AS cum_revenue
FROM orders
JOIN pizzas ON orders.pizza_id = pizzas.id
GROUP BY order_date;
```

#### Output Table:
| order_date | cum_revenue |
|------------|-------------|
| 2015-01-01 | 2713.85     |
| 2015-01-02 | 5445.75     |
| 2015-01-03 | 8108.15     |
| 2015-01-04 | 9863.60     |
| 2015-01-05 | 11929.55    |
| 2015-01-06 | 14358.50    |
| 2015-01-07 | 16560.70    |
| 2015-01-08 | 19399.05    |
| 2015-01-09 | 21526.40    |
| 2015-01-10 | 23990.35    |

---

## Conclusion

The analysis provides valuable insights into the pizza sales data. Key findings include:
- The total number of orders and revenue from pizza sales.
- The most popular pizza sizes and types.
- Revenue distribution among different pizza categories.
- Hourly ordering trends, showing peak periods.
- The contribution of each pizza type to total revenue.

By examining these metrics, we can gain a deeper understanding of customer preferences and optimize menu offerings, pricing, and promotional strategies. Additionally, the hourly order distribution data helps in staffing and operational planning to meet demand during peak hours.


## Getting Started

### Prerequisites
- You should have access to a relational database management system (RDBMS) like MySQL, PostgreSQL, or SQLite.
- A database containing the following tables: `orders`, `order_details`, `pizzas`, and `pizza_types`.
- The necessary relationships (e.g., `pizza_id`, `pizza_type_id`, `order_id`, etc.) between the tables should be established.

### Running the Queries
1. Open your database management tool (e.g., MySQL Workbench, pgAdmin).
2. Connect to the database that contains the pizza sales data.
3. Run the SQL queries one by one to analyze different aspects of pizza sales.

## Contributing

If you would like to contribute to this project, feel free to fork the repository and submit pull requests. We welcome improvements, bug fixes, or additional features.

## About the Author

For questions or further information:

- **Name**: Shaun Mia
- **Email**: shaunmia.cse@gmail.com
- **LinkedIn**: [Shaun Mia](https://www.linkedin.com/in/shaun-mia/)
- **GitHub**: [shaun-mia](https://github.com/shaun-mia)
