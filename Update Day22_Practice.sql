WITH cte AS
(SELECT 
EXTRACT(YEAR FROM a.created_at) AS year, 
EXTRACT(MONTH FROM a.created_at) AS month,
c.category AS Product_category,
b.sale_price AS Sale,
CAST(b.order_id AS STRING) AS order_id,
c.cost AS Cost
FROM bigquery-public-data.thelook_ecommerce.orders AS a
INNER JOIN bigquery-public-data.thelook_ecommerce.order_items AS b 
ON a.order_id = b.order_id
INNER JOIN bigquery-public-data.thelook_ecommerce.products AS c 
ON b.id = c.id
WHERE b.order_id IS NOT NULL AND b.sale_price > 0 AND Cost > 0)

, main_data AS 
(SELECT *
FROM (SELECT *,
ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY order_id) AS STT 
FROM cte) AS t
WHERE STT = 1)

SELECT 
  year || '-' || month AS year_month,   
  Product_category,
  SUM(Sale) AS TPV,
  COUNT(DISTINCT order_id) AS TPO
FROM main_data
GROUP BY year_month, Product_category;
