
# 🛒 Retail Sales Analysis — SQL Case Study

A hands-on SQL project analyzing a retail store’s performance using a structured database with customers, products, and orders.

This case study demonstrates the use of SQL for real-world data analysis — including joins, aggregations, KPIs, and advanced queries like subqueries and CTEs.

---

## 🗂️ Database: `RetailSalesAnalysis`

### 📌 Tables Used:

#### 👤 customers
| Column        | Type     | Description                     |
|---------------|----------|---------------------------------|
| customer_id   | INT      | Unique ID of the customer       |
| customer_name | VARCHAR  | Name of the customer            |
| region        | VARCHAR  | Region the customer belongs to  |

#### 📦 products
| Column       | Type     | Description                     |
|--------------|----------|---------------------------------|
| product_id   | INT      | Unique ID of the product         |
| product_name | VARCHAR  | Product name                     |
| category     | VARCHAR  | Product category                 |
| price        | INT      | Price of the product             |

#### 🧾 orders
| Column        | Type     | Description                      |
|---------------|----------|----------------------------------|
| order_id      | INT      | Unique order ID                  |
| customer_id   | INT      | FK referencing customers         |
| product_id    | INT      | FK referencing products          |
| quantity      | INT      | Number of units ordered          |
| order_date    | DATE     | Date the order was placed        |
| order_amount  | INT      | Total amount = quantity × price  |

---

## 🎯 Project Objectives

Answer key business questions like:

- Which products generate the most revenue?
- What is the monthly revenue trend?
- Who are the most active customers?
- How much revenue comes from each category?

---

## ✅ Part 1: Joins + Basic Analysis

### 🔹 1. Show customer name, product name, and order amount

```sql
SELECT 
    c.customer_name,
    p.product_name,
    o.order_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id;
```

---

### 🔹 2. Show all products and their order count (include those never ordered)

```sql
SELECT 
    p.product_name,
    COUNT(o.order_id) AS total_orders
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_name;
```

---

## ✅ Part 2: Aggregations + KPIs

### 🔹 3. Top 3 products by total revenue

```sql
SELECT TOP 3 
    p.product_id,
    SUM(o.order_amount) AS total_revenue
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id
ORDER BY total_revenue DESC;
```

---

### 🔹 4. Total products sold and revenue by category

```sql
SELECT 
    p.category,
    SUM(o.quantity) AS total_products_sold,
    SUM(o.order_amount) AS total_revenue
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;
```

---

### 🔹 5. Monthly revenue trend

```sql
SELECT 
    FORMAT(order_date, 'yyyy-MM') AS month,
    SUM(order_amount) AS monthly_revenue
FROM orders
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY month;
```

---

## ✅ Part 3: Subqueries + CTEs

### 🔹 6. Product(s) with the highest total revenue (handles ties)

```sql
SELECT 
    product_id,
    SUM(order_amount) AS total_revenue
FROM orders
GROUP BY product_id
HAVING SUM(order_amount) = (
    SELECT MAX(total_rev)
    FROM (
        SELECT product_id, SUM(order_amount) AS total_rev
        FROM orders
        GROUP BY product_id
    ) AS sub
);
```

---

### 🔹 7. Most active customer (most orders placed)

```sql
SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) = (
    SELECT MAX(order_count)
    FROM (
        SELECT customer_id, COUNT(order_id) AS order_count
        FROM orders
        GROUP BY customer_id
    ) AS sub
);
```

---

### 🔹 8. Product revenue ranking using CTE + RANK

```sql
WITH product_revenue AS (
    SELECT 
        p.product_id,
        p.product_name,
        SUM(o.order_amount) AS total_revenue
    FROM products p
    JOIN orders o ON p.product_id = o.product_id
    GROUP BY p.product_id, p.product_name
)
SELECT *,
       RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM product_revenue;
```

---

## 📈 Sample Insights

- 📦 Product 101 generated the highest revenue
- 🧑‍💼 Most orders came from Customer 3
- 📊 November 2023 had the highest total revenue
- 💰 Electronics category had the highest sales

---

## 🧠 Skills Demonstrated

- SQL Joins (INNER, LEFT)
- Aggregation functions: SUM(), COUNT()
- GROUP BY, HAVING
- Subqueries (scalar & inline)
- Window Functions (RANK)
- CTEs (Common Table Expressions)
- Date formatting with FORMAT()

---

## 🛠️ How to Run This Project

1. Create a new database: `RetailSalesAnalysis`
2. Create 3 tables: `customers`, `products`, `orders`
3. Insert sample data (you can expand or customize)
4. Run the SQL queries in SQL Server Management Studio (SSMS)
5. Optional: Export results or build visualizations in Power BI or Excel

---

## 👤 Author

**Ram Guru**  
Aspiring Data Analyst | SQL • Excel • Python  
[🔗 LinkedIn](https://www.linkedin.com/in/ramachandrudu6815)  
[🐱 GitHub](https://github.com/Rammsd007)
