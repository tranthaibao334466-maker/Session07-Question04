CREATE TABLE Customer (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100), 
    region VARCHAR(50)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customer(customer_id),
    total_amount DECIMAL(10, 2),
    order_date DATE,
    status VARCHAR(20)
);

CREATE TABLE product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
); 

CREATE TABLE order_detail ( 
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES product(product_id),
    quantity INT
);

INSERT INTO Customer (full_name, region) VALUES
('Nguyen Van A', 'Hanoi'),
('Tran Thi B', 'Ho Chi Minh City'),
('Le Van C', 'Da Nang');

INSERT INTO orders (customer_id, total_amount, order_date, status) VALUES
(1, 300.50, '2024-04-10', 'Completed'),
(2, 150.00, '2024-04-12', 'Pending'),
(3, 450.75, '2024-04-15', 'Shipped');

INSERT INTO product (name, category, price) VALUES
('Laptop Dell', 'Electronics', 1200.00),
('Smartphone Samsung', 'Electronics', 800.00),
('Headphones Sony', 'Accessories', 150.00);

INSERT INTO order_detail (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 3, 2),
(2, 2, 1),
(3, 1, 1),
(3, 2, 1);

CREATE VIEW v_revenue_by_region AS
(
    SELECT c.region AS region, SUM(o.total_amount) AS total_revenue
    FROM Customer AS c
    JOIN orders AS o ON c.customer_id = o.customer_id
    GROUP BY c.region
);

SELECT * FROM v_revenue_by_region ORDER BY total_revenue DESC LIMIT 3; 

-- Tạo view chi tiết đơn hàng có thể cập nhật được 
CREATE MATERIALIZED VIEW mv_monthly_sales AS 
SELECT DATE_TRUNC('month', order_date) AS sales_month, 
       SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY DATE_TRUNC('month', order_date);

CREATE VIEW v_revenue_above_avg AS 
(
    SELECT region , total_revenue
    FROM v_revenue_by_region
    WHERE total_revenue > (SELECT AVG(total_revenue) FROM v_revenue_by_region GROUP BY region)
); 

