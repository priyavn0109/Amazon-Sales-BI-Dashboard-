CREATE DATABASE amazon_india_sales;
SHOW DATABASES;
USE amazon_india_sales;
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(100),
    subcategory VARCHAR(100),
    brand VARCHAR(100),
    base_price_2015 DECIMAL(10,2),
    product_rating DECIMAL(3,2),
    product_weight_kg DECIMAL(5,2),
    is_prime_eligible BOOLEAN,
    launch_year INT
);
ALTER TABLE PRODUCTS MODIFY COLUMN is_prime_eligible varchar(10);
DESC products;

CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_city VARCHAR(100),
    customer_state VARCHAR(100),
    customer_tier VARCHAR(50),
    customer_spending_tier VARCHAR(50),
    customer_age_group VARCHAR(50)
);

DESC customers;

CREATE TABLE time_dimension (
    date DATE PRIMARY KEY,
    year INT,
    month INT,
    quarter INT,
    month_name VARCHAR(10),
    is_festival_season BOOLEAN
);

ALTER TABLE time_dimension ADD COLUMN day_name VARCHAR(20) AFTER quarter;
ALTER TABLE time_dimension ADD COLUMN weak_of_year INT ;
ALTER TABLE time_dimension ADD COLUMN is_weekend BOOLEAN ;
ALTER TABLE time_dimension ADD COLUMN is_festival BOOLEAN ;
ALTER TABLE time_dimension ADD COLUMN festival_name VARCHAR(50);
ALTER TABLE time_dimension ADD COLUMN day INT;
ALTER TABLE time_dimension DROP COLUMN is_festival_season;

DELETE FROM time_dimension;
SHOW COLUMNS FROM time_dimension;

ALTER TABLE transactions
ADD CONSTRAINT fk_order_date
FOREIGN KEY (order_date_cleaned)
REFERENCES time_dimension(date);

DESC time_dimension;

ALTER TABLE time_dimension MODIFY year SMALLINT;
ALTER TABLE time_dimension MODIFY month TINYINT;
ALTER TABLE time_dimension MODIFY quarter TINYINT;

SELECT COUNT(*) FROM time_dimension;

CREATE TABLE transactions (
    transaction_id VARCHAR(50) PRIMARY KEY,
    order_date DATE,
    customer_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity INT,
    final_amount_inr DECIMAL(10,2),
    discount_percent DECIMAL(5,2),
    delivery_days INT,
    return_status VARCHAR(20),
    payment_method VARCHAR(50),
    is_prime_member VARCHAR(10),
    is_festival_sale BOOLEAN,
    festival_name VARCHAR(100),
    customer_rating DECIMAL(3,2),

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (order_date_cleaned) REFERENCES time_dimension(date)
);
ALTER TABLE transactions MODIFY COLUMN is_prime_member varchar(10);
ALTER TABLE transactions MODIFY COLUMN is_festival_sale varchar(10);
#ALTER TABLE transactions MODIFY COLUMN is_prime_member TINYINT(1);
#DESCRIBE transactions;

ALTER TABLE transactions
MODIFY COLUMN is_prime_member TINYINT(1),
MODIFY COLUMN is_festival_sale TINYINT(1),
MODIFY COLUMN original_price_inr_cleaned DECIMAL(10,2);

ALTER TABLE transactions
MODIFY COLUMN is_prime_member TINYINT,
MODIFY COLUMN is_festival_sale TINYINT;

DESC transactions;

SELECT COUNT(DISTINCT product_id) FROM transactions;
ALTER TABLE transactions RENAME COLUMN orders_date TO ordered_date;
ALTER TABLE transactions RENAME COLUMN delivery_charges TO delivery_charges_cleaned;
ALTER TABLE transactions RENAME COLUMN delivery_charges_cleaned TO delivery_charges;
ALTER TABLE transactions ADD COLUMN original_price_inr_cleaned DECIMAL(10,2) AFTER quantity;

ALTER TABLE transactions MODIFY COLUMN original_price_inr_cleaned VARCHAR(50);

#ALTER TABLE transactions ADD COLUMN delivery_charges DECIMAL(10,2);
ALTER TABLE transactions ADD COLUMN discounted_price_inr DECIMAL(10,2) AFTER discount_percent;
DESCRIBE transactions;

DELETE FROM transactions;

SHOW TABLES;

SELECT COUNT(*) FROM transactions;

USE amazon_india_sales;
SELECT * from transactions;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data.csv'
INTO TABLE transactions 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW VARIABLES LIKE 'secure_file_priv';

CREATE INDEX idx_ordered_date ON transactions(ordered_date);
CREATE INDEX idx_customer_id ON transactions(customer_id);
CREATE INDEX idx_product_id ON transactions(product_id);
CREATE INDEX idx_txn_rating ON transactions(customer_rating);

SET GLOBAL net_read_timeout = 600;
SET GLOBAL net_write_timeout = 600;

SHOW INDEX FROM transactions;
SELECT COUNT(*) FROM PRODUCTS;
SELECT is_prime_eligible, COUNT(*) FROM products GROUP BY is_prime_eligible;

SELECT COUNT(*) FROM customers;
SELECT customer_id, COUNT(*) FROM customers GROUP BY customer_id;

#SHOW VARIABLES LIKE 'secure_file_priv';
#SHOW VARIABLES LIKE 'local_infile';
#SET GLOBAL local_infile = 1;

DELETE FROM customers;