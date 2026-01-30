/* =========================================================
   TASK 9 – SQL DATA MODELING (STAR SCHEMA)
   Dataset included directly in SQL
   ========================================================= */

-- =========================================================
-- STEP 1: CREATE DATABASE
-- =========================================================
CREATE DATABASE IF NOT EXISTS task9_star_schema;
USE task9_star_schema;

-- =========================================================
-- STEP 2: DROP TABLES (FOR SAFE RE-RUN)
-- =========================================================
DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_region;

-- =========================================================
-- STEP 3: CREATE DIMENSION TABLES
-- =========================================================

-- CUSTOMER DIMENSION
CREATE TABLE dim_customer (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50)
);

-- PRODUCT DIMENSION
CREATE TABLE dim_product (
    product_key INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(20),
    product_name VARCHAR(100),
    category VARCHAR(50),
    sub_category VARCHAR(50)
);

-- DATE DIMENSION
CREATE TABLE dim_date (
    date_key INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE,
    year INT,
    month INT,
    day INT
);

-- REGION DIMENSION
CREATE TABLE dim_region (
    region_key INT AUTO_INCREMENT PRIMARY KEY,
    region VARCHAR(50),
    country VARCHAR(50),
    state VARCHAR(50),
    city VARCHAR(50)
);

-- =========================================================
-- STEP 4: CREATE FACT TABLE
-- =========================================================
CREATE TABLE fact_sales (
    sales_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_key INT,
    product_key INT,
    date_key INT,
    region_key INT,
    sales DECIMAL(10,2),
    profit DECIMAL(10,2),
    quantity INT,
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (region_key) REFERENCES dim_region(region_key)
);

-- =========================================================
-- STEP 5: INSERT DATA INTO DIMENSION TABLES
-- =========================================================

-- INSERT CUSTOMERS
INSERT INTO dim_customer (customer_id, customer_name, segment) VALUES
('C001','Alice Johnson','Consumer'),
('C002','Bob Smith','Corporate'),
('C003','Charlie Brown','Home Office');

-- INSERT PRODUCTS
INSERT INTO dim_product (product_id, product_name, category, sub_category) VALUES
('P001','Office Chair','Furniture','Chairs'),
('P002','Laptop','Technology','Computers'),
('P003','Printer','Technology','Office Machines');

-- INSERT DATES
INSERT INTO dim_date (order_date, year, month, day) VALUES
('2023-01-10',2023,1,10),
('2023-02-15',2023,2,15),
('2023-03-20',2023,3,20);

-- INSERT REGIONS
INSERT INTO dim_region (region, country, state, city) VALUES
('West','USA','California','Los Angeles'),
('East','USA','New York','New York'),
('South','USA','Texas','Houston');

-- =========================================================
-- STEP 6: INSERT DATA INTO FACT TABLE
-- =========================================================
INSERT INTO fact_sales
(customer_key, product_key, date_key, region_key, sales, profit, quantity)
VALUES
(1,1,1,1,500.00,120.00,2),
(2,2,2,2,1200.00,300.00,1),
(3,3,3,3,800.00,150.00,3),
(1,2,2,1,950.00,220.00,1),
(2,1,3,2,400.00,80.00,1);

-- =========================================================
-- STEP 7: CREATE INDEXES (PERFORMANCE)
-- =========================================================
CREATE INDEX idx_customer ON fact_sales(customer_key);
CREATE INDEX idx_product ON fact_sales(product_key);
CREATE INDEX idx_date ON fact_sales(date_key);
CREATE INDEX idx_region ON fact_sales(region_key);

-- =========================================================
-- STEP 8: ANALYTICAL QUERIES (STAR SCHEMA USAGE)
-- =========================================================

-- 1. TOTAL SALES BY REGION
SELECT
    r.region,
    SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_region r ON f.region_key = r.region_key
GROUP BY r.region;

-- 2. TOTAL PROFIT BY CATEGORY
SELECT
    p.category,
    SUM(f.profit) AS total_profit
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.category;

-- 3. YEARLY SALES TREND
SELECT
    d.year,
    SUM(f.sales) AS yearly_sales
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year;

-- 4. CUSTOMER-WISE SALES
SELECT
    c.customer_name,
    SUM(f.sales) AS customer_sales
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.customer_name;

-- =========================================================
-- STEP 9: DATA INTEGRITY CHECK
-- =========================================================
SELECT *
FROM fact_sales
WHERE customer_key IS NULL
   OR product_key IS NULL
   OR date_key IS NULL
   OR region_key IS NULL;
