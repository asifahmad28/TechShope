---------------------------------------------------------------------------------------------
--basic query

-- 1. Select all users
SELECT * FROM users;

-- 2. Select specific columns
SELECT user_id, username, email FROM users;

-- 3. Select with WHERE clause
SELECT * FROM products WHERE price > 100;

-- 4. Select with ORDER BY
SELECT * FROM products ORDER BY price DESC;

-- 5. Select with LIMIT (TOP N rows)
SELECT * FROM products WHERE ROWNUM <= 3 ORDER BY price DESC;

--------------------------------------------------------------------------------------------
--Filtering and Sorting

-- 6. Products in specific category
SELECT * FROM products WHERE category_id = 1;

-- 7. Active products only
SELECT * FROM products WHERE is_active = 1 AND stock_quantity > 0;

-- 8. Products with discounts
SELECT p.* FROM products p 
JOIN discounts d ON p.product_id = d.product_id 
WHERE d.is_active = 1;

-- 9. Users by role
SELECT u.*, r.role_name FROM users u 
JOIN user_roles r ON u.role_id = r.role_id 
WHERE r.role_name = 'Admin';

-- 10. Orders by status
SELECT * FROM orders WHERE order_status = 'Processing';

--------------------------------------------------------------------------------------------
--INTERMEDIATE QUERIES (JOINS)

--(basic)
-- 11. Products with category names
SELECT p.product_id, p.product_name, c.category_name, p.price
FROM products p 
JOIN categories c ON p.category_id = c.category_id;

-- 12. User orders with payment methods
SELECT o.order_id, u.username, o.total_amount, pm.method_name, o.order_status
FROM orders o 
JOIN users u ON o.user_id = u.user_id
JOIN payment_methods pm ON o.payment_method_id = pm.payment_method_id;

-- 13. Shopping cart details
SELECT c.cart_id, u.username, p.product_name, c.quantity, p.price
FROM shopping_cart c
JOIN users u ON c.user_id = u.user_id
JOIN products p ON c.product_id = p.product_id;

-- 14. Order items with product details
SELECT oi.order_item_id, o.order_id, p.product_name, oi.quantity, oi.unit_price
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id;

-- 15. Product reviews with user info
SELECT r.review_id, p.product_name, u.username, r.rating, r.review_text
FROM product_reviews r
JOIN products p ON r.product_id = p.product_id
JOIN users u ON r.user_id = u.user_id;

--(Aggregation Queries)
-- 16. Count products per category
SELECT c.category_name, COUNT(p.product_id) as product_count
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY product_count DESC;

-- 17. Total sales by user
SELECT u.user_id, u.username, COUNT(o.order_id) as order_count, 
       SUM(o.total_amount) as total_spent
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username
ORDER BY total_spent DESC;

-- 18. Average product rating
SELECT p.product_id, p.product_name, 
       ROUND(AVG(r.rating), 2) as avg_rating,
       COUNT(r.review_id) as review_count
FROM products p
LEFT JOIN product_reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
HAVING AVG(r.rating) IS NOT NULL
ORDER BY avg_rating DESC;

-- 19. Total quantity sold per product
SELECT p.product_id, p.product_name, 
       SUM(oi.quantity) as total_sold,
       SUM(oi.quantity * (oi.unit_price - oi.discount_amount)) as total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;

-- 20. Monthly sales summary
SELECT TO_CHAR(order_date, 'YYYY-MM') as month,
       COUNT(order_id) as order_count,
       SUM(total_amount) as total_sales,
       AVG(total_amount) as avg_order_value
FROM orders
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;

----------------------------------------------------------------------------------------------------------------
--ADVANCED QUERIES
-- 21. Users who spent more than average
WITH user_spending AS (
    SELECT u.user_id, u.username, SUM(o.total_amount) as total_spent
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    GROUP BY u.user_id, u.username
)
SELECT * FROM user_spending 
WHERE total_spent > (SELECT AVG(total_spent) FROM user_spending);

-- 22. Products never ordered
SELECT p.* 
FROM products p
WHERE p.product_id NOT IN (SELECT DISTINCT product_id FROM order_items);

-- 23. Most reviewed products
SELECT p.product_id, p.product_name, 
       (SELECT COUNT(*) FROM product_reviews pr WHERE pr.product_id = p.product_id) as review_count,
       (SELECT AVG(rating) FROM product_reviews pr WHERE pr.product_id = p.product_id) as avg_rating
FROM products p
ORDER BY review_count DESC;

-- 24. Users with their last order date
SELECT u.user_id, u.username, 
       (SELECT MAX(order_date) FROM orders o WHERE o.user_id = u.user_id) as last_order_date,
       (SELECT COUNT(*) FROM orders o WHERE o.user_id = u.user_id) as total_orders
FROM users u;

-- 25. Rank products by sales
SELECT p.product_id, p.product_name,
       SUM(oi.quantity) as total_sold,
       RANK() OVER (ORDER BY SUM(oi.quantity) DESC) as sales_rank
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

-- 26. Monthly sales growth
WITH monthly_sales AS (
    SELECT TO_CHAR(order_date, 'YYYY-MM') as month,
           SUM(total_amount) as monthly_sales
    FROM orders
    GROUP BY TO_CHAR(order_date, 'YYYY-MM')
)
SELECT month, monthly_sales,
       LAG(monthly_sales) OVER (ORDER BY month) as prev_month_sales,
       ROUND(((monthly_sales - LAG(monthly_sales) OVER (ORDER BY month)) / 
        LAG(monthly_sales) OVER (ORDER BY month)) * 100, 2) as growth_percent
FROM monthly_sales;

-- 27. Running total of sales by user
SELECT u.user_id, u.username, o.order_date, o.total_amount,
       SUM(o.total_amount) OVER (PARTITION BY u.user_id ORDER BY o.order_date) as running_total
FROM users u
JOIN orders o ON u.user_id = o.user_id
ORDER BY u.user_id, o.order_date;

-- 28. Top 3 products per category by price
SELECT category_name, product_name, price,
       RANK() OVER (PARTITION BY category_id ORDER BY price DESC) as price_rank
FROM products p
JOIN categories c ON p.category_id = c.category_id
QUALIFY RANK() OVER (PARTITION BY category_id ORDER BY price DESC) <= 3;

-----------------------------------------------------------------------------------------------------
--complex

-- 29. Customer lifetime value (CLV)
WITH customer_orders AS (
    SELECT u.user_id, u.username,
           COUNT(o.order_id) as order_count,
           SUM(o.total_amount) as total_spent,
           MIN(o.order_date) as first_order,
           MAX(o.order_date) as last_order
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    GROUP BY u.user_id, u.username
)
SELECT user_id, username, order_count, total_spent,
       total_spent / NULLIF(order_count, 0) as avg_order_value,
       ROUND(total_spent / NULLIF(MONTHS_BETWEEN(last_order, first_order), 0), 2) as monthly_value
FROM customer_orders;

-- 30. Product performance matrix
SELECT p.product_id, p.product_name,
       SUM(oi.quantity) as total_sold,
       SUM(oi.quantity * (oi.unit_price - oi.discount_amount)) as total_revenue,
       (SELECT COUNT(*) FROM product_reviews pr WHERE pr.product_id = p.product_id) as review_count,
       (SELECT AVG(rating) FROM product_reviews pr WHERE pr.product_id = p.product_id) as avg_rating,
       p.stock_quantity,
       CASE 
           WHEN p.stock_quantity < 10 THEN 'Low Stock'
           WHEN p.stock_quantity < 25 THEN 'Medium Stock'
           ELSE 'High Stock'
       END as stock_status
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.stock_quantity
ORDER BY total_revenue DESC;

-- 31. Shopping cart abandonment analysis
WITH cart_analysis AS (
    SELECT u.user_id, u.username,
           COUNT(c.cart_id) as cart_items,
           (SELECT COUNT(*) FROM orders o WHERE o.user_id = u.user_id) as orders_count,
           CASE 
               WHEN (SELECT COUNT(*) FROM orders o WHERE o.user_id = u.user_id) = 0 THEN 'No Orders'
               WHEN COUNT(c.cart_id) > (SELECT COUNT(*) FROM orders o WHERE o.user_id = u.user_id) THEN 'High Abandonment'
               ELSE 'Low Abandonment'
           END as abandonment_status
    FROM users u
    LEFT JOIN shopping_cart c ON u.user_id = c.user_id
    GROUP BY u.user_id, u.username
)
SELECT * FROM cart_analysis ORDER BY cart_items DESC;

-- 32. Customer segmentation by spending
SELECT u.user_id, u.username,
       SUM(o.total_amount) as total_spent,
       COUNT(o.order_id) as order_count,
       CASE 
           WHEN SUM(o.total_amount) > 500 THEN 'VIP Customer'
           WHEN SUM(o.total_amount) > 200 THEN 'Regular Customer'
           WHEN SUM(o.total_amount) > 0 THEN 'New Customer'
           ELSE 'Prospect'
       END as customer_segment,
       CASE 
           WHEN COUNT(o.order_id) >= 3 THEN 'Frequent Buyer'
           WHEN COUNT(o.order_id) >= 1 THEN 'Occasional Buyer'
           ELSE 'Non-Buyer'
       END as buying_frequency
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username
ORDER BY total_spent DESC;

---------------------------------------------------------------------------------------------------------------
