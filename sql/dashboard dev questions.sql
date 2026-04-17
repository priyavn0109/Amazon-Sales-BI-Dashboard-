USE amazon_india_sales;

SET GLOBAL net_read_timeout = 600;
SET GLOBAL net_write_timeout = 600;

-- Q1 Executive summary dashboard
SELECT SUM(final_amount_inr) AS total_revenue FROM transactions;

SELECT COUNT(DISTINCT customer_id) AS active_customers FROM transactions;

SELECT SUM(final_amount_inr)/COUNT(transaction_id) AS avg_order_value FROM transactions;

SELECT p.category , SUM(t.final_amount_inr) AS revenue
FROM transactions t JOIN products p ON t.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

SELECT category , COUNT(*) FROM products GROUP BY category;

SELECT 1;
select count(*) from transactions;

-- Q2 Real time performance monitor
SELECT SUM(final_amount_inr) 
FROM transactions
WHERE ordered_date >= (SELECT DATE_FORMAT(MAX(ordered_date),'%Y-%m-01')
FROM transactions );

-- Q3 Strategic Overview Dashboard