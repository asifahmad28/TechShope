--INSERT Operations

-- 33. Add new user
INSERT INTO users (user_id, username, email, password_hash, first_name, last_name, role_id)
VALUES (seq_user_id.NEXTVAL, 'new_user', 'new@example.com', 'hashed_password', 'New', 'User', 2);

-- 34. Add product to shopping cart
INSERT INTO shopping_cart (cart_id, user_id, product_id, quantity)
VALUES (seq_cart_id.NEXTVAL, 2, 3, 1);

-- 35. Place new order
INSERT INTO orders (order_id, user_id, total_amount, shipping_address, payment_method_id)
VALUES (seq_order_id.NEXTVAL, 2, 199.99, '123 Main St', 1);

-------------------------------------------------------------------------------------------------------
--UPDATE Operations

-- 36. Update product price
UPDATE products SET price = 109.99 WHERE product_id = 1;

-- 37. Update order status
UPDATE orders SET order_status = 'Shipped', tracking_number = 'TRK123' WHERE order_id = 1;

-- 38. Update user information
UPDATE users SET phone = '555-1234', address = 'New Address' WHERE user_id = 2;

-- 39. Apply discount to product
UPDATE discounts SET discount_percent = 15.00 WHERE product_id = 1;

-- 40. Update product stock after purchase
UPDATE products SET stock_quantity = stock_quantity - 1 WHERE product_id = 3;

-------------------------------------------------------------------------------------------------------
--DELETE Operations

-- 41. Remove item from shopping cart
DELETE FROM shopping_cart WHERE cart_id = 1;

-- 42. Cancel order
DELETE FROM order_items WHERE order_id = 5;
DELETE FROM orders WHERE order_id = 5;

-- 43. Remove inactive product
DELETE FROM products WHERE is_active = 0;

-- 44. Remove expired discounts
DELETE FROM discounts WHERE end_date < SYSDATE;