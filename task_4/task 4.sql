CREATE DATABASE IF NOT EXISTS task4_sql;
USE task4_sql;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    region VARCHAR(50)
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers VALUES
(1,'Amit','amit@gmail.com','North'),
(2,'Riya','riya@gmail.com','South'),
(3,'John','john@gmail.com','West'),
(4,'Neha','neha@gmail.com','East');

INSERT INTO categories VALUES
(1,'Electronics'),
(2,'Clothing');

INSERT INTO products VALUES
(1,'Laptop',1,50000),
(2,'Mobile',1,20000),
(3,'T-Shirt',2,800);

INSERT INTO orders VALUES
(101,1,'2024-01-10',5000),
(102,2,'2024-01-12',3000),
(103,1,'2024-01-15',7000);

SELECT 
    o.order_id,
    c.customer_name,
    c.region,
    o.order_date,
    o.total_amount
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id;

SELECT 
    c.customer_id,
    c.customer_name
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

SELECT 
    c.customer_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

SELECT 
    cat.category_name,
    COUNT(p.product_id) AS total_products
FROM categories cat
LEFT JOIN products p
ON cat.category_id = p.category_id
GROUP BY cat.category_name;

SELECT 
    o.order_id,
    c.customer_name,
    o.order_date,
    o.total_amount
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.region = 'North'
AND o.order_date BETWEEN '2024-01-01' AND '2024-01-31';

SELECT 
    c.customer_name,
    c.region,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id;
