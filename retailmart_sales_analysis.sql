-- Q1. Calculate total revenue

SELECT SUM(quantity * unit_price) AS total_revenue
FROM order_items;

-- Q2. Count total customers

SELECT COUNT(*) AS total_customers
FROM customers;

-- Q3. Identify product categories

SELECT DISTINCT category
FROM products;

-- Q4. Find the top 10 expensive products

SELECT product_name, price
FROM products
ORDER BY price DESC
LIMIT 10;

-- Q5. Count total orders

SELECT COUNT(*) AS total_orders
FROM orders;

-- Q6. Find best-selling products

SELECT
    p.product_name,
    SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC;

-- Q7. Calculate city-wise revenue

SELECT
    c.city,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.city
ORDER BY total_revenue DESC;

-- Q8. Identify repeat customers

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 1;

-- Q9. Calculate category-wise revenue

SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Q10. Calculate average order value

SELECT
    AVG(order_revenue) AS average_order_value
FROM (
    SELECT
        order_id,
        SUM(quantity * unit_price) AS order_revenue
    FROM order_items
    GROUP BY order_id
) AS order_summary;

-- Q11. Monthly revenue analysis

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
    SUM(oi.quantity * oi.unit_price) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY monthly_revenue DESC;

-- Q12. Identify highest-spending customers

SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 10;

-- Q13. Find products with no sales

SELECT
    p.product_id,
    p.product_name
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- Q14. Find customers spending above average

WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT *
FROM customer_spending
WHERE total_spent > (
    SELECT AVG(total_spent)
    FROM customer_spending
);

-- Q15. Complete category performance analysis

SELECT
    p.category,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;