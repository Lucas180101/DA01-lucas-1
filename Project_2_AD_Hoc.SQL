--Câu 1

WITH CTE AS(SELECT EXTRACT(YEAR FROM created_at) AS Year, EXTRACT(MONTH FROM created_at) AS Month,
status,
COUNT(user_id) AS total_user,
COUNT(order_id) AS total_order
FROM bigquery-public-data.thelook_ecommerce.orders
GROUP BY 1,2,3
ORDER BY 1,2,3)

SELECT Year||'-'||Month AS Year_Month,total_user,total_order
FROM CTE 
WHERE (Year||Month BETWEEN '2019-01-01'AND '2022-05-01') AND status='Shipped'
/* số lượng đơn hàng tăng theo thời gian từ 1/2019-12/2021 và khoảng thời gian từ 1/2022-4/2022 không phát sinh đơn hàng*/

-- câu 2
WITH CTE AS(SELECT FORMAT_TIMESTAMP('%Y-%m', created_at) AS MONTH_YEAR,
COUNT(distinct user_id) AS DISTINCT_USERS,
COUNT(order_id) AS TOTAL_ORDERS,
SUM(sale_price) AS SALES
FROM bigquery-public-data.thelook_ecommerce.order_items
GROUP BY 1)

SELECT MONTH_YEAR,DISTINCT_USERS, ROUND(SALES/TOTAL_ORDERS,2) AS AOV
FROM CTE 
WHERE MONTH_YEAR BETWEEN '2019-01'AND '2022-04'
/* doanh thu mỗi tháng trong năm có sự dao động từ 54 đến 68 và không có nhìu sự chênh lệch lớn ở mỗi tháng liền kề, số lượng khách hàng tăng mạnh vào tháng 3,4,12 và tháng 1 */

-- Câu 3
WITH CTE AS (SELECT first_name,last_name,gender,age
FROM bigquery-public-data.thelook_ecommerce.users
WHERE created_at BETWEEN '2019-01-01' AND '2022-05-01'),

CTE_2 AS(SELECT first_name,last_name,gender, MIN(age)AS age ,'youngest 'AS TAG 
FROM CTE 
WHERE age IN (SELECT MIN(age) FROM CTE)
GROUP BY 1,2,3

UNION ALL

SELECT first_name,last_name,gender, Max(age) age ,'oldest'AS TAG 
FROM CTE 
WHERE age IN (SELECT MAX(age) FROM CTE)
GROUP BY 1,2,3) 

SELECT TAG, age , COUNT(*)
FROM CTE_2
GROUP BY 1,2

/* Người trẻ nhất thuộc độ tuổi 12 tuổi có 981 người 
Người già nhất có độ tuổi 70 tuổi có 1054 người */

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

SELECT
  month_year,
  SUM(sales) AS total_sales,
  SUM(cost) AS total_cost,
  SUM(profit) AS total_profit
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
GROUP BY
  month_year
ORDER BY
  month_year;

-- bài tập 5 

WITH ThreeMonthsAgo AS (
  SELECT TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH)) AS start_date,
         TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) AS end_date)

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

