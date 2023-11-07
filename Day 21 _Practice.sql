-- TASK Ad_HOC
-- bài tập 1
SELECT EXTRACT(year FROM delivered_at) || '-' || EXTRACT(month FROM delivered_at) AS month_year,
       COUNT(user_id) AS total_user,
       COUNT(order_id) AS total_order
       
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE delivered_at BETWEEN '2019-01-01'AND '2022-04-30'
GROUP BY month_year
ORDER BY total_order DESC
       
-- bài tập 2 
WITH monthly_summary AS (
SELECT FORMAT_TIMESTAMP('%Y-%m', b.delivered_at) AS month_year,
COUNT(DISTINCT a.user_id) AS distinct_users,
SUM(b.sale_price) AS total_sale_price,
COUNT(DISTINCT a.order_id) AS total_orders
FROM
bigquery-public-data.thelook_ecommerce.orders AS a
INNER JOIN
bigquery-public-data.thelook_ecommerce.order_items AS b
ON
a.order_id = b.order_id
WHERE
b.delivered_at BETWEEN '2019-01-01' AND '2022-04-30'
GROUP BY
month_year)
SELECT
  month_year,
  distinct_users,
  total_sale_price / total_orders AS average_order_value
FROM
  monthly_summary
ORDER BY
  month_year;

-- bài tập 3 
-- Tìm các khách hàng trẻ nhất và gán tag 'youngest'
WITH YoungestCustomers AS (
SELECT first_name,last_name,gender,age,
'youngest' AS tag
FROM bigquery-public-data.thelook_ecommerce.users
WHERE DATE(created_at) BETWEEN '2019-01-01' AND '2022-04-30'
AND age = (SELECT MIN(age) FROM bigquery-public-data.thelook_ecommerce.users)),

-- Tìm các khách hàng lớn tuổi nhất và gán tag 'oldest'
OldestCustomers AS (
SELECT
first_name,last_name,gender,age,'oldest' AS tag
FROM bigquery-public-data.thelook_ecommerce.users
WHERE DATE(created_at) BETWEEN '2019-01-01' AND '2022-04-30'
AND age = (SELECT MAX(age) FROM bigquery-public-data.thelook_ecommerce.users))

-- Kết hợp kết quả của hai truy vấn bằng UNION
SELECT * FROM YoungestCustomers
UNION ALL
SELECT * FROM OldestCustomers;
-- bài tập 4
WITH MonthlyProfit AS 
(
  SELECT
    FORMAT_TIMESTAMP('%Y-%m', sold_at) AS month_year,
    product_id,
    product_name,
    product_retail_price AS sales,
    cost,
    (product_retail_price - cost) AS profit
  FROM bigquery-public-data.thelook_ecommerce.inventory_items
)

SELECT *
FROM (
  SELECT
    month_year,
    product_id,
    product_name,
    sales,
    cost,
    profit,
    DENSE_RANK() OVER (PARTITION BY month_year ORDER BY profit DESC) AS ranks_per_month
  FROM
    MonthlyProfit
) AS ranked_data
WHERE ranks_per_month <= 5 
ORDER BY
  month_year,
  ranks_per_month;
-- bài tập 5 

WITH ThreeMonthsAgo AS (
  SELECT TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH)) AS start_date,
         TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) AS end_date
)

SELECT
  FORMAT_DATE('%Y-%m-%d', DATE_TRUNC(sold_at, DAY)) AS dates,
  product_category AS product_categories,
  SUM(product_retail_price) AS revenue
FROM
  bigquery-public-data.thelook_ecommerce.inventory_items
WHERE
  sold_at BETWEEN (SELECT start_date FROM ThreeMonthsAgo) AND (SELECT end_date FROM ThreeMonthsAgo)
GROUP BY
  dates,
  product_category
ORDER BY
  dates,
  product_category;


