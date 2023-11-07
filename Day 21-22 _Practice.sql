-- TASK Ad_HOC
-- bài tập 1
SELECT EXTRACT(year FROM delivered_at) || '-' || EXTRACT(month FROM delivered_at) AS month_year,
       COUNT(DISTINCT user_id) AS total_user,
       COUNT(order_id) AS total_order
       
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE delivered_at BETWEEN '2019-01-01'AND '2022-04-30'
GROUP BY month_year
ORDER BY total_order DESC
-- bài tập 2 
SELECT EXTRACT(year FROM delivered_at) || '-' || EXTRACT(month FROM delivered_at) AS month_year,
       COUNT(DISTINCT user_id) AS total_user,
       COUNT(order_id) AS total_order
       
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE delivered_at BETWEEN '2019-01-01'AND '2022-04-30'
GROUP BY month_year
ORDER BY total_order DESC

       cte_1 AS(SELECT * FROM bigquery-public-data.thelook_ecommerce.orders AS a 
INNER JOIN bigquery-public-data.thelook_ecommerce.order_items AS b 
ON a.order_id=b.order_id)

SELECT 
FROM cte_1

WITH monthly_summary AS (
  SELECT
    FORMAT_TIMESTAMP('%Y-%m', oi.delivered_at) AS month_year,
    COUNT(DISTINCT o.user_id) AS distinct_users,
    SUM(oi.sale_price) AS total_sale_price,
    COUNT(DISTINCT o.order_id) AS total_orders
  FROM
    bigquery-public-data.thelook_ecommerce.orders AS o
  INNER JOIN
    bigquery-public-data.thelook_ecommerce.order_items AS oi
  ON
    o.order_id = oi.order_id
  WHERE
    oi.delivered_at BETWEEN '2019-01-01' AND '2022-04-30'
  GROUP BY
    month_year
)
SELECT
  month_year,
  distinct_users,
  total_sale_price / total_orders AS average_order_value
FROM
  monthly_summary
ORDER BY
  month_year;
