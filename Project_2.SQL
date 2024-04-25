
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
