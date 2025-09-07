
-- Create tables in proper order with all dependencies
CREATE TABLE user_roles (
    role_id NUMBER PRIMARY KEY,
    role_name VARCHAR2(50) NOT NULL,
    description VARCHAR2(200)
);

CREATE TABLE users (
    user_id NUMBER PRIMARY KEY,
    username VARCHAR2(50) NOT NULL UNIQUE,
    email VARCHAR2(100) NOT NULL UNIQUE,
    password_hash VARCHAR2(200) NOT NULL,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    address VARCHAR2(200),
    phone VARCHAR2(20),
    role_id NUMBER DEFAULT 2 REFERENCES user_roles(role_id),
    created_at DATE DEFAULT SYSDATE,
    last_login DATE,
    is_active NUMBER(1) DEFAULT 1,
    CONSTRAINT chk_user_active CHECK (is_active IN (0, 1))
);

CREATE TABLE categories (
    category_id NUMBER PRIMARY KEY,
    category_name VARCHAR2(100) NOT NULL,
    description VARCHAR2(200),
    parent_category_id NUMBER REFERENCES categories(category_id)
);

CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(100) NOT NULL,
    description VARCHAR2(500),
    category_id NUMBER REFERENCES categories(category_id),
    price NUMBER(10,2) NOT NULL,
    stock_quantity NUMBER NOT NULL,
    image_url VARCHAR2(200),
    created_at DATE DEFAULT SYSDATE,
    updated_at DATE,
    is_active NUMBER(1) DEFAULT 1,
    rating NUMBER(3,2),
    CONSTRAINT chk_stock CHECK (stock_quantity >= 0),
    CONSTRAINT chk_active CHECK (is_active IN (0, 1)),
    CONSTRAINT chk_rating CHECK (rating BETWEEN 0 AND 5)
);

CREATE TABLE discounts (
    discount_id NUMBER PRIMARY KEY,
    product_id NUMBER REFERENCES products(product_id),
    discount_percent NUMBER(5,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active NUMBER(1) DEFAULT 1,
    CONSTRAINT chk_discount_percent CHECK (discount_percent BETWEEN 0 AND 100),
    CONSTRAINT chk_discount_dates CHECK (end_date > start_date),
    CONSTRAINT chk_discount_active CHECK (is_active IN (0, 1))
);

CREATE TABLE payment_methods (
    payment_method_id NUMBER PRIMARY KEY,
    method_name VARCHAR2(50) NOT NULL,
    description VARCHAR2(200)
);

CREATE TABLE shopping_cart (
    cart_id NUMBER PRIMARY KEY,
    user_id NUMBER REFERENCES users(user_id),
    product_id NUMBER REFERENCES products(product_id),
    quantity NUMBER NOT NULL,
    added_at DATE DEFAULT SYSDATE,
    CONSTRAINT chk_cart_quantity CHECK (quantity > 0)
);

CREATE TABLE orders (
    order_id NUMBER PRIMARY KEY,
    user_id NUMBER REFERENCES users(user_id),
    order_date DATE DEFAULT SYSDATE,
    total_amount NUMBER(10,2) NOT NULL,
    shipping_address VARCHAR2(200) NOT NULL,
    payment_method_id NUMBER REFERENCES payment_methods(payment_method_id),
    order_status VARCHAR2(20) DEFAULT 'Processing',
    tracking_number VARCHAR2(50),
    CONSTRAINT chk_order_status CHECK (order_status IN ('Processing', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE order_items (
    order_item_id NUMBER PRIMARY KEY,
    order_id NUMBER REFERENCES orders(order_id),
    product_id NUMBER REFERENCES products(product_id),
    quantity NUMBER NOT NULL,
    unit_price NUMBER(10,2) NOT NULL,
    discount_amount NUMBER(10,2) DEFAULT 0,
    CONSTRAINT chk_order_quantity CHECK (quantity > 0)
);

CREATE TABLE product_reviews (
    review_id NUMBER PRIMARY KEY,
    product_id NUMBER REFERENCES products(product_id),
    user_id NUMBER REFERENCES users(user_id),
    order_id NUMBER REFERENCES orders(order_id),
    rating NUMBER(1) NOT NULL,
    review_text VARCHAR2(1000),
    review_date DATE DEFAULT SYSDATE,
    CONSTRAINT chk_review_rating CHECK (rating BETWEEN 1 AND 5)
);

CREATE TABLE order_status_log (
    log_id NUMBER PRIMARY KEY,
    order_id NUMBER REFERENCES orders(order_id),
    old_status VARCHAR2(20),
    new_status VARCHAR2(20),
    changed_by VARCHAR2(50),
    change_date DATE DEFAULT SYSDATE
);

-- Create sequences
CREATE SEQUENCE seq_user_id START WITH 6 INCREMENT BY 1;
CREATE SEQUENCE seq_product_id START WITH 6 INCREMENT BY 1;
CREATE SEQUENCE seq_category_id START WITH 6 INCREMENT BY 1;
CREATE SEQUENCE seq_discount_id START WITH 6 INCREMENT BY 1;
CREATE SEQUENCE seq_cart_id START WITH 6 INCREMENT BY 1;
CREATE SEQUENCE seq_order_id START WITH 6 INCREMENT BY 1;
CREATE SEQUENCE seq_order_item_id START WITH 6 INCREMENT BY 1;
CREATE SEQUENCE seq_review_id START WITH 6 INCREMENT BY 1;
CREATE SEQUENCE seq_order_log_id START WITH 6 INCREMENT BY 1;
