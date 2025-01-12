# Amazon-SQL-Problems
![amazon](/amazon_images.png)

## 📚 Table of Contents
- [Project Overview](#project-overview)
- [Objective](#objective)
- [Procedure](#procedure)
- [Database Setup & Design](#database-setup--design)
- [Task: Data Cleaning](#task-data-cleaning)
- [Solving Business Problems](#solving-business-problems)
   - [1. Top Selling Products](#1-top-selling-products)
   - [2. Revenue by Category](#2-revenue-by-category)
   - [3. Average Order Value (AOV)](#3-average-order-value-aov)
   - [4. Monthly Sales Trend](#4-monthly-sales-trend)
   - [5. Customers with No Purchases](#5-customers-with-no-purchases)
   - [6. Least-Selling Categories by State](#6-least-selling-categories-by-state)
   - [7. Customer Lifetime Value (CLTV)](#7-customer-lifetime-value-cltv)
   - [8. Inventory Stock Alerts](#8-inventory-stock-alerts)
   - [9. Shipping Delays](#9-shipping-delays)
   - [10. Payment Success Rate](#10-payment-success-rate)
        

    
## **Project Overview**

I downloaded CSV files and analyzed a dataset containing over 20,000 sales records from an Amazon-like e-commerce platform. This project involved extensive querying of customer behavior, product performance, and sales trends using MySQL in software Navicat. Throughout this project, I addressed various SQL challenges, including revenue analysis, customer segmentation, and inventory management.

## **Objective**

The primary objective of this project is to showcase SQL proficiency through complex queries that address real-world e-commerce business challenges. The analysis covers various aspects of e-commerce operations, including:
- Customer behavior
- Sales trends
- Inventory management
- Payment and shipping analysis

## Procedure
-  Based on the source excel sheets i need to create relational database. I used [Quick database diagrams (QDD)](https://app.quickdatabasediagrams.com/ ) which saved me time and generated SQL code for me.
- ![[QuickDBD- Diagram.png]]
- Exported MySQL file -> Opened Navicat ->  MySQL Connection -> Created New Database amazon_db_ with  character set(utf8mb4) collation (utf8mb4_unicode_ci) -> Executed SQL file from QDD 

## **Database Setup & Design**


### **Schema Structure**

![schema](/QuickDBD-Free Diagram.png)


## **Task: Data Cleaning**

I cleaned up the data by:

- **Deleting Duplicates**: Found and deleted duplicate records in the customer and order tables.
- **Dealing with Missing Data**: Fixed nulls (missing data) in important columns like customer address and payment status. I either filled them in with default values or used other suitable methods.


## **Dealing with Missing Data (Nulls)**

Here's how I handled nulls based on the column:

- **Customer Address**: Filled in missing addresses with placeholder values.
- **Payment Status**: Marked orders with missing payment statuses as "Pending."
- **Shipping Information**: Kept null return dates blank, since not all shipments get returned.


## **Identifying Business Problems**
Key business problems identified:
1. High return rates for electronics product category.
2. Significant delays in shipments and inconsistencies in delivery times.
3.
4.

## **Solving Business Problems**

 ## 1. Top Selling Products
Query the top 10 products by total sales value.
Challenge: Include product name, total quantity sold, and total sales value.

```sql
/*
1. Top Selling Products
Query the top 10 products by total sales value.
Challenge: Include product name, total quantity sold, and total sales value.
*/ 
WITH total_quantity AS (
  SELECT
    product_name,
    price,
    sum(quantity) AS total_quantity_sold,
    o.order_status 
  FROM
    products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id 
  WHERE
    order_status = 'Completed' 
  GROUP BY p.product_id) 
SELECT
product_name,
total_quantity_sold,
ROUND(total_quantity_sold * price, 0) AS total_sales_value 
FROM
  total_quantity 
ORDER BY
  total_sales_value DESC 
 LIMIT 10
```

#### Result
<table>
<tr><th>product_name</th><th>total_quantity_sold</th><th>total_sales_value</th></tr>
<tr><td>Apple iMac Pro</td><td>101</td><td>504999</td></tr>
<tr><td>Canon EOS R5 Mirrorless Camera</td><td>50</td><td>194999</td></tr>
<tr><td>Apple iMac 27-Inch Retina</td><td>102</td><td>183599</td></tr>
<tr><td>Apple iMac 24-Inch</td><td>120</td><td>155999</td></tr>
<tr><td>Apple MacBook Pro 16-inch (2021)</td><td>59</td><td>147499</td></tr>
<tr><td>Dell Alienware Aurora R13</td><td>57</td><td>142499</td></tr>
<tr><td>Sony A7R IV Mirrorless Camera</td><td>41</td><td>135300</td></tr>
<tr><td>Apple MacBook Pro 14-inch</td><td>65</td><td>129999</td></tr>
<tr><td>Dell XPS 17 Laptop</td><td>59</td><td>123899</td></tr>
<tr><td>Sony A7S III Mirrorless Camera</td><td>35</td><td>122500</td></tr>
</table>

Key Steps:

- Analyzed database schema to establish relationships between products, order_items, and orders tables
- Implemented WHERE clause to filter for completed orders, excluding cancelled and returned items
- Utilized WITH clause to efficiently calculate total sales values in a two-step process
- Sorted and limited results to identify top 10 revenue-generating products

## 2. Revenue by Category
Calculate total revenue generated by each product category.
Challenge: Include the percentage contribution of each category to total revenue.

```sql
/*
2. Revenue by Category
Calculate total revenue generated by each product category.
Challenge: Include the percentage contribution of each category to total revenue.
*/ 
WITH total_quantity AS (
  SELECT
    category_name,
    price,
    SUM(quantity) AS total_quantity_sold 
  FROM
    products p
    JOIN category c ON p.category_id = c.category_id
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id 
  WHERE
    o.order_status = 'Completed' 
  GROUP BY
    category_name,price) 
SELECT
category_name,
SUM(ROUND(total_quantity_sold * price, 0)) AS total_sales_value,
ROUND(SUM(total_quantity_sold * price) * 100 / (SELECT SUM(total_quantity_sold * price) FROM total_quantity), 2) AS percentage_contribution 
FROM
  total_quantity 
GROUP BY
  category_name 
ORDER BY
  total_sales_value DESC;
```
#### Breaking Down The Code
**`SUM(ROUND(total_quantity_sold * price, 0)) AS total_sales_value`**
- Calculates the total revenue for each category 
- Formula: `total_quantity_sold * price` (revenue per product)
 
**`ROUND(SUM(total_quantity_sold * price) * 100 / (SELECT SUM(total_quantity_sold * price) FROM total_quantity), 2) AS percentage_contribution `**
- Calculates how much each category contributed to the total revenue as a percentage
- **`(SELECT SUM(total_quantity_sold * price) FROM total_quantity)`** calculates the total revenue for all categories

**`GROUP BY category_name `**: 
- Ensures that calculations for revenue and percentage contribution are grouped by `category_name`.

#### Result
<table>
<tr><th>category_name</th><th>total_sales_value</th><th>percentage_contribution</th></tr>
<tr><td>electronics</td><td>9306141</td><td>89.63</td></tr>
<tr><td>Sports & Outdoors</td><td>377193</td><td>3.63</td></tr>
<tr><td>Toys & Games</td><td>290595</td><td>2.8</td></tr>
<tr><td>Pet Supplies</td><td>218040</td><td>2.1</td></tr>
<tr><td>clothing</td><td>114608</td><td>1.1</td></tr>
<tr><td>home & kitchen</td><td>76282</td><td>0.73</td></tr>
</table>

## 3. Average Order Value (AOV)
Compute the average order value for each customer.
Challenge: Include only customers with more than 5 orders.

```sql
/*
3. Average Order Value (AOV)
Compute the average order value for each customer.
Challenge: Include only customers with more than 5 orders.
*/
SELECT
c.customer_id,
CONCAT(c.first_name, ' ', c.last_name) AS full_name,
sum(total_sale) / count(o.order_id) AS AOV,
count(o.order_id) AS total_orders 
FROM
  orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  JOIN customers c ON c.customer_id = o.customer_id 
GROUP BY 1,2 
HAVING
  total_orders >= 5 
ORDER BY
  AOV DESC 
  LIMIT 10
```
#### Breaking Down The Code

**`CONCAT(c.first_name, ' ', c.last_name) AS full_name`** 
- Combines the customer's first and last names into a single string.

**`sum(total_sale) / count(o.order_id) AS AOV`**
- Calculates the Average Order Value (AOV) for each customer.

**`HAVING total_orders >= 5`**
- Filters the results to include only customers who have placed more than 5 orders.
#### Result

<table>
<tr><th>customer_id</th><th>full_name</th><th>AOV</th><th>total_orders</th></tr>
<tr><td>473</td><td>Xavier Reed</td><td>2206.98</td><td>5</td></tr>
<tr><td>403</td><td>Derek Smith</td><td>2101.98</td><td>5</td></tr>
<tr><td>500</td><td>Benjamin Adams</td><td>1890.97</td><td>5</td></tr>
<tr><td>189</td><td>Yvonne Turner</td><td>1792.83</td><td>7</td></tr>
<tr><td>103</td><td>Samuel Reed</td><td>1524.27</td><td>7</td></tr>
<tr><td>312</td><td>William Martin</td><td>1451.97</td><td>5</td></tr>
<tr><td>503</td><td>Mia Reed</td><td>1396.97</td><td>5</td></tr>
<tr><td>266</td><td>Quinn Cooper</td><td>1393.97</td><td>5</td></tr>
<tr><td>314</td><td>Quinn Green</td><td>1366.81</td><td>6</td></tr>
<tr><td>203</td><td>Xavier Green</td><td>1299.97</td><td>7</td></tr>
</table>

## 4. Monthly Sales Trend
Query monthly total sales over the past year.
Challenge: Display the sales trend, grouping by month, return current_month sale, last month sale!

```sql
/*
4. Monthly Sales Trend
Query monthly total sales over the past year.
Challenge: Display the sales trend, grouping by month, return current_month sale, last month sale!
*/ 

SELECT
month_year,
total_sales AS current_month_sale,
LAG(total_sales, 1) OVER (ORDER BY month_year) AS last_month_sale 
FROM
  (
    SELECT
      DATE_FORMAT(o.order_date, '%Y-%m') AS month_year,
	  /* creates new format of date '2024-07' */
      SUM(oi.quantity * oi.price_per_unit) AS total_sales 
    FROM
      orders o
      JOIN order_items oi ON o.order_id = oi.order_id 
    WHERE
      o.order_date >= CURDATE() - INTERVAL 1 YEAR 
      AND order_status = 'Completed' 
    GROUP BY
      DATE_FORMAT(o.order_date, '%Y-%m') 
    ORDER BY
  month_year DESC) AS t1
```
#### Result
<table>
<tr><th>month_year</th><th>current_month_sale</th><th>last_month_sale</th></tr>
<tr><td>2024-01</td><td>129377.64</td><td></td></tr>
<tr><td>2024-02</td><td>85750.39</td><td>129377.64</td></tr>
<tr><td>2024-03</td><td>9212</td><td>85750.39</td></tr>
<tr><td>2024-04</td><td>12579.83</td><td>9212</td></tr>
<tr><td>2024-05</td><td>20490.85</td><td>12579.83</td></tr>
<tr><td>2024-06</td><td>8374.06</td><td>20490.85</td></tr>
<tr><td>2024-07</td><td>24501.74</td><td>8374.06</td></tr>
</table>


### **Query Breakdown and Notes**

#### **1. Outer Query:**

- **`month_year`:**
    - Retrieves the formatted month-year (e.g., `2024-07`) from the subquery.
    - This serves as the identifier for each monthly grouping.
- **`total_sales AS current_month_sale`:**
    - Displays the total sales for the current month (calculated in the subquery).
    - Alias `current_month_sale` is used for clarity.
- **`LAG(total_sales, 1) OVER (ORDER BY month_year)` (Key Feature):**
    - This uses the `LAG` function to fetch the **previous month's total sales**.
    - **`1`:** Specifies to look back one row (previous month).
    - **`ORDER BY month_year`:** Ensures chronological order (from oldest to newest) to calculate the previous month's sale.

---

#### **2. FROM Clause (Subquery `t1`):**

- **Purpose of Subquery:**
    - This calculates the monthly total sales (`total_sales`) grouped by `month_year` for the past 1 year.

---

#### **3. Subquery Details:**

- **`DATE_FORMAT(o.order_date, '%Y-%m') AS month_year`:**
    - Converts the `order_date` into a `YYYY-MM` format (e.g., `2024-07`).
    - Used as the grouping key to summarize sales by month.
- **`SUM(oi.quantity * oi.price_per_unit) AS total_sales`:**
    - Calculates total sales for each month.
    - Multiplies `quantity` by `price_per_unit` for each `order_item` and sums up the values per month.
- **`FROM orders o JOIN order_items oi ON o.order_id = oi.order_id`:**    
    - Joins the `orders` and `order_items` tables on their common `order_id`.
    - Ensures data from both tables is combined for calculating total sales.
- **`WHERE o.order_date >= CURDATE() - INTERVAL 1 YEAR`:**    
    - Filters orders placed within the last 1 year (relative to today's date).
    - `INTERVAL 1 YEAR` ensures proper handling of date subtraction.
    -  if I don't use `Interval` but only "- 1" it would substract 1 day 
- **`AND order_status = 'Completed'`:**    
    - Filters only orders that are marked as `Completed`.
- **`GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')`:**    
    - Groups the data by month (`month_year`) to calculate monthly totals.


---
#### **4. Putting It Together:**

- The subquery calculates total sales for each month (`total_sales`) over the past year.
- The outer query:
    - Displays the current month's total sales (`current_month_sale`).
    - Uses the `LAG` function to retrieve the last month's total sales (`last_month_sale`).
    - 

## 5. Customers with No Purchases
Find customers who have registered but never placed an order.
Challenge: List customer details and the time since their registration.

```sql
/*
5. Customers with No Purchases
Find customers who have registered but never placed an order.
Challenge: List customer details and the time since their registration.
*/ 

SELECT
first_name,
last_name,
state 
FROM
  customers c
  LEFT JOIN orders o ON c.customer_id = o.customer_id 
WHERE
  order_date IS NULL
```

#### Results
212 records

- A **LEFT JOIN** keeps **all customers**, even if they don’t have orders.
- We then filter to find those **without orders** (`o.order_date IS NULL`).

## 6. Least-Selling Categories by State

```sql
/*
6. Least-Selling Categories by State
Identify the least-selling product category for each state.
Challenge: Include the total sales for that category within each state.
*/ 
WITH ranking AS (
  SELECT
    category_name,
    ROUND(sum(total_sale), 2) AS total_sales,
    state,
    RANK() OVER (PARTITION BY state ORDER BY sum(total_sale) ASC) AS rank_1 
  FROM
    category cg
    JOIN products p ON cg.category_id = p.category_id
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    JOIN customers c ON c.customer_id = o.customer_id 
  GROUP BY
    category_name,
    state 
  ORDER BY total_sales) 

SELECT
state,
category_name,
total_sales  
FROM
  ranking 
WHERE
  rank_1 = 1 
ORDER BY
  state ASC;
```
### **Query Breakdown and Notes**

**1. Common Table Expression (CTE):**

- `WITH ranking AS (...)`: This defines a CTE called `ranking`, which is a temporary named result set.

This query calculates the total sales for each product category within each state and assigns a rank based on the total sales in ascending order.

`ROUND(sum(total_sale), 2)`: 
- Calculates the sum of `total_sale` and rounds it to 2 decimal places.
 `RANK() OVER (PARTITION BY state ORDER BY sum(total_sale) ASC)` 
 - This is a window function that partitions the data by `state` (meaning it ranks categories independently within each state) and orders them by `sum(total_sale)` in ascending order (lowest sales first). It assigns a rank to each category within each state based on this order.
`GROUP BY category_name, state`
- This groups the results by `category_name` and `state` to get the total sales for each category in each state.
`ORDER BY total_sales`: 
- This orders the results of the CTE by `total_sales` in ascending order (not essential for the final result, but might be for analysis).


**3. Main Query:**

This query retrieves the `state`, `category_name`, and `total_sales` from the `ranking` CTE where the `rank_1` is equal to 1 (meaning the category with the lowest sales in each state). It then orders the results by `state` in ascending order.

**In essence, the code:**

1. **Calculates total sales:** Determines the total sales for each product category in each state.
2. **Ranks categories:** Ranks the categories within each state based on their total sales, with the lowest sales ranked first.
3. **Filters lowest-selling categories:** Selects only the categories with the lowest total sales in each state (rank = 1).
4. **Presents results:** Displays the state, category name, and total sales for these lowest-selling categories.

## 7. Customer Lifetime Value (CLTV)

Calculate the total value of orders placed by each customer over their lifetime.
Challenge: Rank customers based on their CLTV.

```sql
/*
7. Customer Lifetime Value (CLTV)
Calculate the total value of orders placed by each customer over their lifetime.
Challenge: Rank customers based on their CLTV.
*/ 

SELECT
CONCAT(c.first_name, ' ', c.last_name) AS full_name,
state,
order_status,
SUM(quantity * price_per_unit) AS CLTV,
DENSE_RANK() OVER (ORDER BY SUM(quantity * price_per_unit) DESC) AS ranking 
FROM
  customers c
  JOIN orders o ON c.customer_id = o.customer_id
  JOIN order_items oi ON oi.order_id = o.order_id 
WHERE
  order_status LIKE '%omp%' -- completed
GROUP BY
  1,
  2,
  3

```
## 8. Inventory Stock Alerts
Query products with stock levels below a certain threshold (e.g., less than 10 units).
Challenge: Include last restock date and warehouse information.

```sql
/*
8. Inventory Stock Alerts
Query products with stock levels below a certain threshold (e.g., less than 10 units).
Challenge: Include last restock date and warehouse information.
*/

SELECT
inventory_id,
product_name,
stock as current_stock,
warehouse_id,
last_stock_date

from inventory i 
JOIN products p ON p.product_id = i.product_id
where stock < 10
ORDER BY stock ASC

```


## 9. Shipping Delays
Identify orders where the shipping date is later than 3 days after the order date.
What is the percentage of delayed orders based on shopping provider
```sql
/*
9. Shipping Delays
Identify orders where the shipping date is later than 3 days after the order date.
What is the percentage of delayed orders based on shopping provider
*/ 

SELECT 
shipping_providers,
ROUND((delayed_orders *100/(on_time_orders+delayed_orders)),2) as perc_delayed_orders

FROM
(SELECT 
    shipping_providers,
    SUM(CASE WHEN DATEDIFF(shipping_date, order_date) <= 3 AND payment_date = order_date THEN 1 ELSE 0 END) AS on_time_orders,
    SUM(CASE WHEN DATEDIFF(shipping_date, order_date) > 3 AND payment_date = order_date THEN 1 ELSE 0 END) AS delayed_orders
  FROM
    orders o
JOIN shipping s ON o.order_id = s.order_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY
    shipping_providers) as t1
ORDER BY  perc_delayed_orders DESC
```

#### Result

<table>
<tr><th>shipping_providers</th><th>perc_delayed_orders</th></tr>
<tr><td>bluedart</td><td>40.47</td></tr>
<tr><td>fedex</td><td>40.28</td></tr>
<tr><td>dhl</td><td>38.72</td></tr>
</table>

### **Query Breakdown and Notes**

`SUM(CASE WHEN DATEDIFF(shipping_date, order_date) <= 3 AND payment_date = order_date THEN 1 ELSE 0 END) AS on_time_orders`:

- `DATEDIFF(shipping_date, order_date) <=3`: 
	- Calculates the difference in days between `shipping_date` and `order_date` and checks if it's less than or equal to 3.
- `payment_date = order_date`: 
	- Checks if the `payment_date` is the same as the `order_date`.
- `CASE WHEN ... THEN 1 ELSE 0 END`: 
	-  Assigns 1 if both conditions above are true (meaning the order was shipped within 3 days and paid on the same day as the order date), otherwise 0.
- `SUM(...)`: 
	- Adds up all the 1s, effectively counting the "on-time orders".

**In Summary:** This code analyzes order data to determine the percentage of delayed orders for each shipping provider, specifically focusing on orders paid for on the same day they were placed. This allows you to identify which shipping providers have the highest delay rates, which can be useful for evaluating their performance and making informed decisions about shipping strategies.


## 10. Payment Success Rate
Calculate the percentage of successful payments across all orders.
Challenge: Include breakdowns by payment status (e.g., failed, pending).

```sql
/*
10. Payment Success Rate 
Calculate the percentage of successful payments across all orders.
Challenge: Include breakdowns by payment status (e.g., failed, pending).
*/

SELECT
ROUND((completed_payments *100/(completed_payments+failed_payments)),2) as perc_completed_payments,
failed_payments,
pending_payments
FROM
(SELECT 
SUM(CASE WHEN payment_status LIKE '%ucce%'THEN 1 ELSE 0 END) as completed_payments,
SUM(CASE WHEN payment_status LIKE '%Faile%'THEN 1 ELSE 0 END) as failed_payments,
SUM(CASE WHEN order_status = 'Inprogress' THEN 1 ELSE 0 END) as pending_payments
FROM orders o 
JOIN payments p on o.order_id = p.order_id) as order_sta

```

#### Result

<table>
<tr><th>perc_completed_payments</th><th>failed_payments</th><th>pending_payments</th></tr>
<tr><td>97.4</td><td>488</td><td>499</td></tr>
</table>

### **Query Breakdown and Notes**

`SUM(CASE WHEN payment_status LIKE '%ucce%' THEN 1 ELSE 0 END) as completed_payments`:

- `payment_status LIKE '%ucce%'`: 
	- Checks if the `payment_status` contains the string "ucce" (likely to capture variations like "Success" or "Successful").
- `CASE WHEN ... THEN 1 ELSE 0 END`: 
	- Assigns 1 if the `payment_status` matches the condition (indicating a completed payment), otherwise 0.
- `SUM(...)`: 
	- Calculates the total number of completed payments by adding all the 1s.


**In Summary:** This code analyzes order and payment data to calculate the overall payment success rate (`perc_completed_payments`) and provides the counts of `failed_payments` and `pending_payments`. This information can be used to monitor payment processing efficiency, identify potential issues, and track outstanding payments.
