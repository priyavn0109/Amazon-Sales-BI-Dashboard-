USE amazon_india_sales;

SET GLOBAL max_allowed_packet = 1073741824;
SET GLOBAL net_read_timeout = 600;
SET GLOBAL net_write_timeout = 600;
SET GLOBAL wait_timeout = 600;
SET SESSION net_read_timeout = 600;
SET SESSION net_write_timeout = 600;
SET SESSION wait_timeout = 600;
SET SESSION interactive_timeout = 600;

#Data loading and validation procedures
-- Row count validation
SELECT COUNT(*) FROM transactions;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM time_dimension;

-- Check NULLs in critical columns
SELECT
    SUM(customer_id IS NULL) AS null_customers,
    SUM(product_id IS NULL) AS null_products,
    SUM(ordered_date IS NULL) AS null_dates
FROM transactions;

-- Duplicate primary key check
SELECT product_id, COUNT(*) FROM products GROUP BY product_id HAVING COUNT(*) > 1;

#2.Aggregation queries for dashboard KPIs

-- Total Revenue
SELECT SUM(final_amount_inr) AS total_revenue FROM transactions;

-- Total Orders
SELECT COUNT(*) AS total_orders FROM transactions;

-- Average Order value
SELECT AVG(final_amount_inr) AS avg_order_value FROM transactions;

-- Festival vs Non-festival sales
SELECT is_festival_sale, SUM(final_amount_inr) AS revenue FROM transactions
GROUP BY is_festival_sale;

-- Category-wise Revenue

SELECT COUNT(*) FROM transactions t join products p on t.product_id = p.product_id;

SELECT p.category, SUM(t.final_amount_inr) AS revenue FROM transactions t JOIN products p 
ON t.product_id = p.product_id WHERE t.transaction_id <= 200000 GROUP BY p.category ORDER BY revenue DESC;

CREATE TABLE category_rev AS SELECT p.category, SUM(t.final_amount_inr) AS revenue FROM transactions t JOIN products p 
ON t.product_id = p.product_id GROUP BY p.category;
    
SELECT * FROM category_revenue ORDER BY revenue DESC;
    
CREATE INDEX idx_transactions_product
ON transactions(product_id);

CREATE INDEX idx_products_product
ON products(product_id);

-- Monthly Sales Trend
SELECT td.year, td.month, SUM(t.final_amount_inr) AS monthly_sales
FROM transactions t JOIN time_dimension td ON t.ordered_date = td.date
GROUP BY td.year, td.month
ORDER BY td.year, td.month;

-- City-wise Sales

SELECT * FROM city_revenue LIMIT 10;

# 4. PERFORMANCE OPTIMIZATION FOR LARGE DATASETS

CREATE INDEX idx_transactions_date ON transactions(ordered_date);
CREATE INDEX idx_transactions_product ON transactions(product_id);
CREATE INDEX idx_transactions_customer ON transactions(customer_id);

CREATE INDEX idx_products_category ON products(category);

EXPLAIN
SELECT
    p.category,
    SUM(t.final_amount_inr)
FROM transactions t
JOIN products p
    ON t.product_id = p.product_id
GROUP BY p.category;

#Tool: Power BI Desktop
#Connector: MySQL ODBC 8.0 (64-bit)
#Mode: Import
#Authentication: Username + Password
#Schema: amazon_sales

-- to test database connection, validate ODBC / POWER BI 
SELECT 1;