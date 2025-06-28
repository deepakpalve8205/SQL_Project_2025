  # Final Project 
 
 -- creating database--
 
create database project;

-- using database--
use  project;

-- view csv files--
select * from sales;
select * from customers;
select * from products;
select * from returns;

--  Scenario-- 
# Q1 )  Total Revenue by Category                      -- revenue = quantity * price--


select category, SUM(price * quantity) as revenue from sales 
join products using (product_id)
group by  category;

# Q2)  Top 5 Products by Sales Volume

SELECT p.name, SUM(s.quantity) AS total_sold
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.name
ORDER BY total_sold DESC
LIMIT 5;


# Q3) Monthly Sales Trend

SELECT DATE_FORMAT(sale_date, '%Y-%m') AS month, SUM(p.price * s.quantity) AS revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY month
ORDER BY month;

# Q4) Customer Purchase Frequency

SELECT c.customer_id, c.name, COUNT(s.sale_id) AS num_orders
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.name
ORDER BY num_orders DESC;

# Q5)  Inactive Customers (last 3 months)

SELECT c.customer_id, c.name
FROM customers c
WHERE c.customer_id NOT IN (
  SELECT DISTINCT customer_id
  FROM sales
  WHERE sale_date >= CURDATE() - INTERVAL 3 MONTH
);

# Q6) Most Returned Products

SELECT p.name, COUNT(r.return_id) AS returns
FROM returns r
JOIN sales s ON r.sale_id = s.sale_id
JOIN products p ON s.product_id = p.product_id
GROUP BY p.name
ORDER BY returns DESC;

# Q7) Return Rate by Category


SELECT p.category, 
       COUNT(r.return_id)*1.0 / COUNT(s.sale_id) AS return_rate
FROM sales s
LEFT JOIN returns r ON s.sale_id = r.sale_id
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category;
