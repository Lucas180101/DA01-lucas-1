-- TASK Ad_HOC
-- bài tập 1
SELECT EXTRACT(year FROM shipped_at) || '-' || EXTRACT(month FROM shipped_at) AS month_year,
       COUNT(DISTINCT user_id) AS total_user,
       COUNT(order_id) AS total_order
       
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE shipped_at BETWEEN '2019-01-01'AND '2022-04-30'
GROUP BY month_year
ORDER BY total_order DESC
-- bài tập 2 
SELECT
  EXTRACT(year FROM a.shipped_at) || '-' || EXTRACT(month FROM a.shipped_at) AS month_year,
  COUNT(DISTINCT a.user_id) AS distinct_user,
  AVG(b.sale_price) OVER (PARTITION BY EXTRACT(year FROM a.shipped_at)) AS avg_sale_price
FROM
  bigquery-public-data.thelook_ecommerce.orders AS a
INNER JOIN
  bigquery-public-data.thelook_ecommerce.order_items AS b 
  ON a.order_id = b.order_id
WHERE
  a.shipped_at BETWEEN '2019-01-01' AND '2022-04-30'
