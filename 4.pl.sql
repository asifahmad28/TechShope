
-- Create triggers
CREATE OR REPLACE TRIGGER trg_update_product_stock
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity - :NEW.quantity
    WHERE product_id = :NEW.product_id;
END;
/

CREATE OR REPLACE TRIGGER trg_update_product_rating
AFTER INSERT OR UPDATE OR DELETE ON product_reviews
DECLARE
    CURSOR c_products IS
        SELECT product_id FROM products;
BEGIN
    FOR product_rec IN c_products LOOP
        UPDATE products
        SET rating = (
            SELECT AVG(rating) 
            FROM product_reviews 
            WHERE product_id = product_rec.product_id
        )
        WHERE product_id = product_rec.product_id;
    END LOOP;
END;
/

CREATE OR REPLACE TRIGGER trg_order_status_change
AFTER UPDATE OF order_status ON orders
FOR EACH ROW
BEGIN
    INSERT INTO order_status_log (
        log_id, order_id, old_status, 
        new_status, changed_by
    ) VALUES (
        seq_order_log_id.NEXTVAL, :NEW.order_id, 
        :OLD.order_status, :NEW.order_status,
        USER
    );
END;
/
