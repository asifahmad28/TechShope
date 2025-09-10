-- Using subquery with MAX
SELECT product_id, product_name, price
FROM products
WHERE price = (
    SELECT MAX(price)
    FROM products
    WHERE price < (SELECT MAX(price) FROM products)
);

-- Using ROW_NUMBER() window function
SELECT product_id, product_name, price
FROM (
    SELECT product_id, product_name, price,
           ROW_NUMBER() OVER (ORDER BY price DESC) as rn
    FROM products
    WHERE price IS NOT NULL
)
WHERE rn = 2;

-- Using DENSE_RANK() to handle ties
SELECT product_id, product_name, price
FROM (
    SELECT product_id, product_name, price,
           DENSE_RANK() OVER (ORDER BY price DESC) as dr
    FROM products
    WHERE price IS NOT NULL
)
WHERE dr = 2;

-----------------------------------------------------------------
-- Second highest order total
SELECT order_id, user_id, total_amount, order_date
FROM orders
WHERE total_amount = (
    SELECT MAX(total_amount)
    FROM orders
    WHERE total_amount < (SELECT MAX(total_amount) FROM orders)
);

-- Second highest order for each user
SELECT user_id, order_id, total_amount
FROM (
    SELECT user_id, order_id, total_amount,
           DENSE_RANK() OVER (PARTITION BY user_id ORDER BY total_amount DESC) as dr
    FROM orders
)
WHERE dr = 2;
----------------------------------------------------------------------
-- Second highest average rating
SELECT product_id, product_name, rating
FROM products
WHERE rating = (
    SELECT MAX(rating)
    FROM products
    WHERE rating < (SELECT MAX(rating) FROM products WHERE rating IS NOT NULL)
    AND rating IS NOT NULL
);

-- Using window function
SELECT product_id, product_name, rating
FROM (
    SELECT product_id, product_name, rating,
           DENSE_RANK() OVER (ORDER BY rating DESC NULLS LAST) as dr
    FROM products
    WHERE rating IS NOT NULL
)
WHERE dr = 2;
-------------------------------------------------------------------
-- Second highest quantity of any item in cart
SELECT cart_id, user_id, product_id, quantity
FROM shopping_cart
WHERE quantity = (
    SELECT MAX(quantity)
    FROM shopping_cart
    WHERE quantity < (SELECT MAX(quantity) FROM shopping_cart)
);

-- Second highest quantity for each product
SELECT product_id, user_id, quantity
FROM (
    SELECT product_id, user_id, quantity,
           DENSE_RANK() OVER (PARTITION BY product_id ORDER BY quantity DESC) as dr
    FROM shopping_cart
)
WHERE dr = 2;
---------------------------------------------------------------------
-- Second highest active discount
SELECT discount_id, product_id, discount_percent, start_date, end_date
FROM discounts
WHERE discount_percent = (
    SELECT MAX(discount_percent)
    FROM discounts
    WHERE discount_percent < (SELECT MAX(discount_percent) FROM discounts WHERE is_active = 1)
    AND is_active = 1
)
AND is_active = 1;

-- Using window function
SELECT discount_id, product_id, discount_percent
FROM (
    SELECT discount_id, product_id, discount_percent,
           DENSE_RANK() OVER (ORDER BY discount_percent DESC) as dr
    FROM discounts
    WHERE is_active = 1
)
WHERE dr = 2;
----------------------------------------------------------------------------
-- User with second highest total spending
SELECT user_id, username, total_spent
FROM (
    SELECT u.user_id, u.username,
           COALESCE(SUM(o.total_amount), 0) as total_spent,
           DENSE_RANK() OVER (ORDER BY COALESCE(SUM(o.total_amount), 0) DESC) as dr
    FROM users u
    LEFT JOIN orders o ON u.user_id = o.user_id
    GROUP BY u.user_id, u.username
)
WHERE dr = 2;

-- Alternative using subquery
SELECT u.user_id, u.username, SUM(o.total_amount) as total_spent
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username
HAVING SUM(o.total_amount) = (
    SELECT MAX(total_spent)
    FROM (
        SELECT SUM(total_amount) as total_spent
        FROM orders
        GROUP BY user_id
    )
    WHERE total_spent < (SELECT MAX(SUM(total_amount)) FROM orders GROUP BY user_id)
);
---------------------------------------------------------------------------
-- Product with second highest number of orders
SELECT product_id, product_name, order_count
FROM (
    SELECT p.product_id, p.product_name,
           COUNT(oi.order_item_id) as order_count,
           DENSE_RANK() OVER (ORDER BY COUNT(oi.order_item_id) DESC) as dr
    FROM products p
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name
)
WHERE dr = 2;

-- Alternative method
SELECT p.product_id, p.product_name, COUNT(oi.order_item_id) as order_count
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING COUNT(oi.order_item_id) = (
    SELECT MAX(order_count)
    FROM (
        SELECT COUNT(order_item_id) as order_count
        FROM order_items
        GROUP BY product_id
    )
    WHERE order_count < (SELECT MAX(COUNT(order_item_id)) FROM order_items GROUP BY product_id)
);
--------------------------------------------------------------
-- Second highest review rating given
SELECT review_id, product_id, user_id, rating, review_text
FROM product_reviews
WHERE rating = (
    SELECT MAX(rating)
    FROM product_reviews
    WHERE rating < (SELECT MAX(rating) FROM product_reviews)
);

-- Second highest rating for each product
SELECT product_id, review_id, rating
FROM (
    SELECT product_id, review_id, rating,
           DENSE_RANK() OVER (PARTITION BY product_id ORDER BY rating DESC) as dr
    FROM product_reviews
)
WHERE dr = 2;
--------------------------------------------------------------------------
-- Second highest priced product with category info
SELECT p.product_id, p.product_name, p.price, c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.price = (
    SELECT MAX(price)
    FROM products
    WHERE price < (SELECT MAX(price) FROM products)
);

-- Second highest order with user details
SELECT o.order_id, o.total_amount, u.username, u.email
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE o.total_amount = (
    SELECT MAX(total_amount)
    FROM orders
    WHERE total_amount < (SELECT MAX(total_amount) FROM orders)
);