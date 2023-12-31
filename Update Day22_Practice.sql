WITH cte AS (
  SELECT 
    EXTRACT(YEAR FROM a.created_at) AS Year, 
    EXTRACT(MONTH FROM a.created_at) AS Month,
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
    CONCAT(year, '-', LPAD(CAST(month AS STRING), 2, '0')) as Month,  -- Ensure zero-padding for single-digit months
    year AS Year,
    Product_category,
    SUM(Sale) AS TPV,
    SUM(Cost) AS Total_Cost,
    COUNT(DISTINCT order_id) AS TPO
  FROM main_data cte
  GROUP BY Month, Product_category, Year
),

Ecommerce_index AS (
  SELECT 
    TPO,
    TPV,
    PARSE_DATE(Month, '%Y-%m') as Month,  -- Use PARSE_DATE to convert string to date
    FORMAT_DATE('%Y-%m', PARSE_DATE(Month, '%Y-%m')) as cohort_date,
    (EXTRACT(YEAR FROM PARSE_DATE(Month, '%Y-%m')) - EXTRACT(YEAR FROM first_purchase_date)) * 12
      + EXTRACT(MONTH FROM PARSE_DATE(Month, '%Y-%m')) - EXTRACT(MONTH FROM first_purchase_date) + 1 as index
  FROM (
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
      ROUND((TPV - LEAD(TPV) OVER (PARTITION BY Month ORDER BY TPV)) / TPV * 100, 2) AS Revenue_growth,
      LEAD(TPO) OVER (PARTITION BY Month ORDER BY TPO) AS Next_Order,
      ROUND((TPO - LEAD(TPO) OVER (PARTITION BY Month ORDER BY TPO)) / TPO * 100, 2) AS Order_growth,
      MIN(PARSE_DATE(Month, '%Y-%m')) OVER (PARTITION BY Year) AS first_purchase_date
    FROM cte2
  ) AS subquery
),

xxx AS (
  SELECT 
    TPV,
    TPO,
    cohort_date,
    index
  FROM Ecommerce_index
  GROUP BY cohort_date, index, TPV, TPO
),

customer_cohort AS (
  SELECT 
    cohort_date,
    SUM(CASE WHEN index = 1 THEN TPO ELSE 0 END) AS m1,
    SUM(CASE WHEN index = 2 THEN TPO ELSE 0 END) AS m2,
    SUM(CASE WHEN index = 3 THEN TPO ELSE 0 END) AS m3,
    SUM(CASE WHEN index = 4 THEN TPO ELSE 0 END) AS m4
  FROM xxx
  GROUP BY cohort_date
  ORDER BY cohort_date
)

-- retention cohort
SELECT
  cohort_date,
  (100 - ROUND(100.00 * m1 / m1, 2)) || '%' AS m1,
  (100 - ROUND(100.00 * m2 / m1, 2)) || '%' AS m2,
  (100 - ROUND(100.00 * m3 / m1, 2)) || '%' AS m3,
  ROUND(100.00 * m4 / m1, 2) || '%' AS m4
FROM customer_cohort;
