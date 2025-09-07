-- Insert exactly 5 records in each table

-- 1. USER_ROLES
INSERT INTO user_roles VALUES (1, 'Admin', 'Administrator with full access');
INSERT INTO user_roles VALUES (2, 'User', 'Regular customer');
INSERT INTO user_roles VALUES (3, 'Manager', 'Store manager with limited admin access');
INSERT INTO user_roles VALUES (4, 'Vendor', 'Product vendor');
INSERT INTO user_roles VALUES (5, 'Guest', 'Temporary guest user');

PROMPT ============ USER_ROLES (5 records) ============
SELECT * FROM user_roles ORDER BY role_id;

-- 2. USERS
INSERT INTO users VALUES (1, 'admin_john', 'john.admin@example.com', 
    '$2a$10$xJwLH5XrWrWOBnFZ3YdQe.XY3zIgXmKfE3nXH.wJNQO6Z7qLd7Q0K',
    'John', 'Smith', '123 Admin St, Tech City', '555-0101', 1, SYSDATE, NULL, 1);
    
INSERT INTO users VALUES (2, 'regular_sara', 'sara.customer@example.com',
    '$2a$10$yH8eJwW9rX9R3d2V1c2U3u4v5w6x7y8z9A0B1C2D3E4F5G6H7I8J9K0L',
    'Sara', 'Johnson', '456 Customer Ave, Shopping Town', '555-0202', 2, SYSDATE, NULL, 1);
    
INSERT INTO users VALUES (3, 'mike_shopper', 'mike.buyer@example.com',
    '$2a$10$zI9J8H7G6F5E4D3C2B1A0u9v8w7x6y5z4A3B2C1D0E9F8G7H6I5J4K3L',
    'Mike', 'Brown', '789 Buyer Blvd, Market City', '555-0303', 2, SYSDATE, NULL, 1);

INSERT INTO users VALUES (4, 'lisa_manager', 'lisa.manager@example.com',
    '$2a$10$lM1N2O3P4Q5R6S7T8U9V0W1X2Y3Z4A5B6C7D8E9F0G1H2I3J4K5L6M',
    'Lisa', 'Wilson', '321 Manager St, Office City', '555-0404', 3, SYSDATE, NULL, 1);
    
INSERT INTO users VALUES (5, 'david_vendor', 'david.vendor@example.com',
    '$2a$10$nO1P2Q3R4S5T6U7V8W9X0Y1Z2A3B4C5D6E7F8G9H0I1J2K3L4M5N6O',
    'David', 'Chen', '654 Vendor Rd, Supply Town', '555-0505', 4, SYSDATE, NULL, 1);

PROMPT ============ USERS (5 records) ============
SELECT user_id, username, email, first_name, last_name, role_id FROM users ORDER BY user_id;

-- 3. CATEGORIES
INSERT INTO categories VALUES (1, 'Electronics', 'Electronic devices and accessories', NULL);
INSERT INTO categories VALUES (2, 'Clothing', 'Clothing and apparel', NULL);
INSERT INTO categories VALUES (3, 'Books', 'Books and magazines', NULL);
INSERT INTO categories VALUES (4, 'Headphones', 'Audio headphones', 1);
INSERT INTO categories VALUES (5, 'Wearables', 'Wearable devices', 1);

PROMPT ============ CATEGORIES (5 records) ============
SELECT * FROM categories ORDER BY category_id;

-- 4. PRODUCTS
INSERT INTO products VALUES (1, 'Wireless Headphones', 'Premium wireless headphones with noise cancellation', 4, 99.99, 25, 'headphones.jpg', SYSDATE, NULL, 1, NULL);
INSERT INTO products VALUES (2, 'Smart Watch', 'Advanced smart watch with health monitoring', 5, 199.99, 15, 'smartwatch.jpg', SYSDATE, NULL, 1, NULL);
INSERT INTO products VALUES (3, 'Running Shoes', 'Comfortable running shoes', 2, 89.99, 50, 'shoes.jpg', SYSDATE, NULL, 1, NULL);
INSERT INTO products VALUES (4, 'Java Programming Book', 'Complete Java guide', 3, 39.99, 25, 'javabook.jpg', SYSDATE, NULL, 1, NULL);
INSERT INTO products VALUES (5, 'Bluetooth Speaker', 'Portable wireless speaker', 1, 49.99, 30, 'speaker.jpg', SYSDATE, NULL, 1, NULL);

PROMPT ============ PRODUCTS (5 records) ============
SELECT product_id, product_name, category_id, price, stock_quantity FROM products ORDER BY product_id;

-- 5. DISCOUNTS
INSERT INTO discounts VALUES (1, 1, 10.00, SYSDATE, ADD_MONTHS(SYSDATE, 1), 1);
INSERT INTO discounts VALUES (2, 2, 5.00, SYSDATE, ADD_MONTHS(SYSDATE, 1), 1);
INSERT INTO discounts VALUES (3, 3, 15.00, SYSDATE, ADD_MONTHS(SYSDATE, 1), 1);
INSERT INTO discounts VALUES (4, 4, 10.00, SYSDATE, ADD_MONTHS(SYSDATE, 2), 1);
INSERT INTO discounts VALUES (5, 5, 20.00, SYSDATE, ADD_MONTHS(SYSDATE, 1), 1);

PROMPT ============ DISCOUNTS (5 records) ============
SELECT discount_id, product_id, discount_percent, TO_CHAR(start_date, 'YYYY-MM-DD') as start_date FROM discounts ORDER BY discount_id;

-- 6. PAYMENT_METHODS
INSERT INTO payment_methods VALUES (1, 'Credit Card', 'Visa, MasterCard, etc.');
INSERT INTO payment_methods VALUES (2, 'PayPal', 'PayPal payment');
INSERT INTO payment_methods VALUES (3, 'Cash on Delivery', 'Pay when product is delivered');
INSERT INTO payment_methods VALUES (4, 'Bank Transfer', 'Direct bank transfer');
INSERT INTO payment_methods VALUES (5, 'Gift Card', 'Store gift card payment');

PROMPT ============ PAYMENT_METHODS (5 records) ============
SELECT * FROM payment_methods ORDER BY payment_method_id;

-- 7. SHOPPING_CART
INSERT INTO shopping_cart VALUES (1, 2, 1, 2, SYSDATE);
INSERT INTO shopping_cart VALUES (2, 2, 3, 1, SYSDATE);
INSERT INTO shopping_cart VALUES (3, 3, 2, 1, SYSDATE);
INSERT INTO shopping_cart VALUES (4, 4, 5, 3, SYSDATE);
INSERT INTO shopping_cart VALUES (5, 5, 4, 2, SYSDATE);

PROMPT ============ SHOPPING_CART (5 records) ============
SELECT cart_id, user_id, product_id, quantity FROM shopping_cart ORDER BY cart_id;

-- 8. ORDERS
INSERT INTO orders VALUES (1, 2, SYSDATE, 179.98, '456 Customer Ave, Shopping Town', 1, 'Processing', 'TRK001');
INSERT INTO orders VALUES (2, 3, SYSDATE, 199.99, '789 Buyer Blvd, Market City', 2, 'Shipped', 'TRK002');
INSERT INTO orders VALUES (3, 4, SYSDATE, 134.97, '321 Manager St, Office City', 3, 'Delivered', 'TRK003');
INSERT INTO orders VALUES (4, 5, SYSDATE, 79.98, '654 Vendor Rd, Supply Town', 4, 'Processing', 'TRK004');
INSERT INTO orders VALUES (5, 2, SYSDATE, 89.99, '456 Customer Ave, Shopping Town', 5, 'Cancelled', 'TRK005');

PROMPT ============ ORDERS (5 records) ============
SELECT order_id, user_id, total_amount, order_status FROM orders ORDER BY order_id;

-- 9. ORDER_ITEMS
INSERT INTO order_items VALUES (1, 1, 1, 2, 99.99, 9.99);
INSERT INTO order_items VALUES (2, 2, 2, 1, 199.99, 0);
INSERT INTO order_items VALUES (3, 3, 5, 3, 49.99, 4.99);
INSERT INTO order_items VALUES (4, 4, 4, 2, 39.99, 0);
INSERT INTO order_items VALUES (5, 5, 3, 1, 89.99, 0);

PROMPT ============ ORDER_ITEMS (5 records) ============
SELECT order_item_id, order_id, product_id, quantity, unit_price, discount_amount FROM order_items ORDER BY order_item_id;

-- 10. PRODUCT_REVIEWS
INSERT INTO product_reviews VALUES (1, 1, 2, 1, 5, 'Excellent sound quality!', SYSDATE);
INSERT INTO product_reviews VALUES (2, 2, 3, 2, 4, 'Great features!', SYSDATE);
INSERT INTO product_reviews VALUES (3, 3, 4, 3, 5, 'Very comfortable shoes', SYSDATE);
INSERT INTO product_reviews VALUES (4, 4, 5, 4, 4, 'Good programming book', SYSDATE);
INSERT INTO product_reviews VALUES (5, 5, 2, 5, 5, 'Amazing speaker quality', SYSDATE);

PROMPT ============ PRODUCT_REVIEWS (5 records) ============
SELECT review_id, product_id, user_id, rating, order_id FROM product_reviews ORDER BY review_id;

-- 11. ORDER_STATUS_LOG
INSERT INTO order_status_log VALUES (1, 1, NULL, 'Processing', 'system', SYSDATE);
INSERT INTO order_status_log VALUES (2, 2, 'Processing', 'Shipped', 'admin_john', SYSDATE);
INSERT INTO order_status_log VALUES (3, 3, 'Processing', 'Shipped', 'admin_john', SYSDATE);
INSERT INTO order_status_log VALUES (4, 3, 'Shipped', 'Delivered', 'system', SYSDATE);
INSERT INTO order_status_log VALUES (5, 5, 'Processing', 'Cancelled', 'regular_sara', SYSDATE);

PROMPT ============ ORDER_STATUS_LOG (5 records) ============
SELECT log_id, order_id, old_status, new_status, changed_by FROM order_status_log ORDER BY log_id;
