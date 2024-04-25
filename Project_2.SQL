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

-- Câu 4

