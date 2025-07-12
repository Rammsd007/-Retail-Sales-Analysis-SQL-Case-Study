CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    region VARCHAR(50)
);

INSERT INTO customers VALUES 
(1, 'Ravi Kumar', 'South'),
(2, 'Anjali Verma', 'North'),
(3, 'Kiran Rao', 'West');

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price INT
);

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 50000),
(102, 'Headphones', 'Electronics', 2000),
(103, 'Office Chair', 'Furniture', 7000);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    order_amount INT
);

INSERT INTO orders VALUES
(1001, 1, 101, 1, '2023-11-01', 50000),
(1002, 2, 102, 2, '2023-11-03', 4000),
(1003, 1, 103, 1, '2023-11-05', 7000),
(1004, 3, 101, 1, '2023-11-07', 50000);
select * from products
select* from orders
select * from customers
-------------✅ Part 1: Joins + Basic Analysis----

------1.Show customer name,product name,order amount,and order date
select c.customer_name,
p.product_name,
o.order_amount,
o.order_date 
from orders o
join customers c on o.customer_id=c.customer_id
join products p on o.product_id = p.product_id

--2. ✅ 2. Show total revenue by region
select c.region, sum(o.order_amount)as total_revenue  from 
customers c 
join orders o on c.customer_id =o.customer_id 
group by region
order by total_revenue desc

--3.✅ 3. Show top 3 products by total revenue
select top 3 
p.product_id,sum(o.order_amount) as total_revenue
from
products p
join
orders o on p.product_id=o.product_id 
group by p.product_id
order by total_revenue desc



--4.Show total quantity sold and revenue by category

Select
      p.category,
	  sum(o.quantity)as total_products_sold ,
	  sum(o.order_amount) as total_revenue from products p left join 
orders o on p.product_id=o.product_id 
group by p.category
order by total_revenue desc
---------✅ Part 2: Aggregations + KPIs----

---✅ 5. Total Revenue, Total Orders, Avg Order Value (Company-wide KPIs)
SELECT 
    COUNT(order_id) AS total_orders,
    SUM(order_amount) AS total_revenue,
    AVG(order_amount) AS avg_order_value
FROM orders;

---✅ 6. Category-wise KPIs: Total Quantity Sold, Total Revenue, Avg Order Size

SELECT 
    p.category,
    SUM(o.quantity) AS total_quantity_sold,
    SUM(o.order_amount) AS total_revenue,
    AVG(o.order_amount) AS avg_order_value
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

---✅ 7. High Revenue Categories (Using HAVING)

SELECT 
    p.category,
    SUM(o.order_amount) AS total_revenue
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.category
HAVING SUM(o.order_amount) > 10000;

-----✅ 8. Monthly Revenue Trend
select 
 format(order_date,'yyyy-MM') AS MONTH,
 SUM(ORDER_AMOUNT) AS Monthly_revenue
 from orders
 group by format(order_date,'yyyy-MM')
 ORDER BY Month 
 SELECT order_id, order_date, order_amount FROM orders;

 --✅ Part 3: Subqueries + CTEs--

 --9.Top selling product by revenue
 select top 1 p.product_id, sum(o.order_amount) as total_revenue 
 from products p left join orders o on p.product_id = o.product_id 
 group by p.product_id

 --with sub query:
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

--✅ Query 10: Most Active Customer (placed the most orders)
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

--✅ Query 11: Rank Products by Revenue (Using CTE + RANK)

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

