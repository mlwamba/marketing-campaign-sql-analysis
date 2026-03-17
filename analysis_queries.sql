-- Dataset: Google BigQuery Public Dataset - thelook_ecommerce
-- Project: E-Commerce SQL Analysis
-- Author: Moiya Fatuma L


-- ------------------------------------------------------------
-- Query 1: Top 10 Customers by Total Spend
-- ------------------------------------------------------------
SELECT
  oi.user_id,
  ROUND(SUM(oi.sale_price), 2) AS total_spent
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
GROUP BY oi.user_id
ORDER BY total_spent DESC
LIMIT 10;



-- ------------------------------------------------------------
-- Query 2: Top 10 Products by Revenue
-- ------------------------------------------------------------
SELECT
  p.name AS product_name,
  SUM(oi.sale_price) AS revenue
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.products` p
  ON oi.product_id = p.id
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 10;



-- ------------------------------------------------------------
-- Query 3: Monthly Revenue Trend
-- ------------------------------------------------------------
SELECT
  EXTRACT(YEAR FROM oi.created_at) AS year,
  EXTRACT(MONTH FROM oi.created_at) AS month,
  ROUND(SUM(oi.sale_price), 2) AS total_revenue
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
GROUP BY year, month
ORDER BY year, month;



-- ------------------------------------------------------------
-- Query 4: Revenue by Category + Ranking
-- ------------------------------------------------------------
SELECT
  p.category,
  ROUND(SUM(oi.sale_price), 2) AS total_revenue,
  RANK() OVER (ORDER BY SUM(oi.sale_price) DESC) AS revenue_rank
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.products` p
  ON oi.product_id = p.id
GROUP BY p.category
ORDER BY revenue_rank;



-- ------------------------------------------------------------
-- Query 5: Average Order Value
-- ------------------------------------------------------------
SELECT
  ROUND(AVG(order_total), 2) AS avg_order_value
FROM (
  SELECT
    order_id,
    SUM(sale_price) AS order_total
  FROM `bigquery-public-data.thelook_ecommerce.order_items`
  GROUP BY order_id
);
