-- Show all data with relationships
PROMPT ============ COMPLETE DATA OVERVIEW ============

PROMPT 1. Users with their roles:
SELECT u.user_id, u.username, u.first_name, u.last_name, r.role_name
FROM users u
JOIN user_roles r ON u.role_id = r.role_id
ORDER BY u.user_id;

PROMPT 2. Products with categories and discounts:
SELECT p.product_id, p.product_name, c.category_name, p.price, 
       d.discount_percent || '%' as discount, p.stock_quantity
FROM products p
JOIN categories c ON p.category_id = c.category_id
LEFT JOIN discounts d ON p.product_id = d.product_id
ORDER BY p.product_id;

PROMPT 3. Shopping cart details:
SELECT c.cart_id, u.username, p.product_name, c.quantity, p.price
FROM shopping_cart c
JOIN users u ON c.user_id = u.user_id
JOIN products p ON c.product_id = p.product_id
ORDER BY c.cart_id;

PROMPT 4. Order details with items:
SELECT o.order_id, u.username, o.order_status, o.total_amount,
       p.product_name, oi.quantity, oi.unit_price, oi.discount_amount
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id, oi.order_item_id;

PROMPT 5. Product reviews with user info:
SELECT r.review_id, p.product_name, u.username, r.rating, 
       CASE r.rating
           WHEN 1 THEN '★☆☆☆☆'
           WHEN 2 THEN '★★☆☆☆'
           WHEN 3 THEN '★★★☆☆'
           WHEN 4 THEN '★★★★☆'
           WHEN 5 THEN '★★★★★'
       END as rating_stars
FROM product_reviews r
JOIN products p ON r.product_id = p.product_id
JOIN users u ON r.user_id = u.user_id
ORDER BY r.review_id;

PROMPT 6. Order status history:
SELECT l.log_id, l.order_id, u.username, l.old_status, l.new_status, 
       l.changed_by, TO_CHAR(l.change_date, 'YYYY-MM-DD HH24:MI:SS') as change_date
FROM order_status_log l
JOIN orders o ON l.order_id = o.order_id
JOIN users u ON o.user_id = u.user_id
ORDER BY l.log_id;

PROMPT ============ FINAL RECORD COUNT PER TABLE ============
SELECT 'user_roles' as table_name, COUNT(*) as records FROM user_roles
UNION ALL SELECT 'users', COUNT(*) FROM users
UNION ALL SELECT 'categories', COUNT(*) FROM categories
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'discounts', COUNT(*) FROM discounts
UNION ALL SELECT 'payment_methods', COUNT(*) FROM payment_methods
UNION ALL SELECT 'shopping_cart', COUNT(*) FROM shopping_cart
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'product_reviews', COUNT(*) FROM product_reviews
UNION ALL SELECT 'order_status_log', COUNT(*) FROM order_status_log;

COMMIT;

PROMPT ============ DATABASE SETUP COMPLETED SUCCESSFULLY! ============
PROMPT ============ 5 RECORDS INSERTED IN EVERY TABLE ============