CREATE OR REPLACE VIEW  vw_ecommerce_analyst AS(
WITH cte AS (
  SELECT 
    EXTRACT(YEAR FROM a.created_at) AS year, 
    EXTRACT(month FROM a.created_at) AS month,
    c.category AS Product_category,
    b.sale_price AS Sale,
    CAST(b.order_id AS STRING) AS order_id,
    c.cost AS Cost
  FROM bigquery-public-data.thelook_ecommerce.orders AS a
  INNER JOIN bigquery-public-data.thelook_ecommerce.order_items AS b 
    ON a.order_id = b.order_id
  INNER JOIN bigquery-public-data.thelook_ecommerce.products AS c 
    ON b.id = c.id
  WHERE b.order_id IS NOT NULL AND b.sale_price > 0 AND Cost > 0
), 
main_data AS (
  SELECT *
  FROM (
    SELECT *,
    ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY order_id) AS dup_flag
    FROM cte
  ) AS t
  WHERE dup_flag = 1
),

cte2 AS (
  SELECT 
    year || '-' || month AS Month,   
    year AS Year,
    Product_category,
    SUM(Sale) AS TPV,
    SUM(Cost) AS Total_Cost,
    COUNT(DISTINCT order_id) AS TPO
  FROM main_data cte
  GROUP BY Month, Product_category, Year
)

SELECT 
  Month,
  Year,
  Product_category,
  TPV,
  TPO,
  Total_Cost,
  TPV - Total_Cost AS Total_profit,
  (TPV - Total_Cost) / Total_Cost AS Profit_to_cost_ratio,
  LEAD(TPV) OVER (PARTITION BY Month ORDER BY TPV) AS Next_Sale,
  ROUND((TPV - LEAD(TPV) OVER (PARTITION BY Month ORDER BY TPV)) / TPV * 100, 2)||'%' AS Revenue_growth,
  LEAD(TPO) OVER (PARTITION BY Month ORDER BY TPO) AS Next_Order,
  ROUND((TPO - LEAD(TPO) OVER (PARTITION BY Month ORDER BY TPO)) / TPO * 100, 2)||'%' AS Order_growth
FROM cte2);
