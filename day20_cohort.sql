/* Bước 1: Khám phá và làm sạch dữ liệu
-Chúng ta đang quan tâm đến trường nào ?
-Check null 
-Chuyển đổi kiểu dữ liệu 
-Check tiền và số lượng lớn hơn 0 
-Check dupl*/
--có 541909 bản ghi, có 135080 bị null 

--SELECT * FROM public.online_retail
WITH online_retail_convert AS(SELECT invoiceno,
stockcode,
description,
CAST(quantity AS INT) quantity,
CAST(invoicedate AS timestamp) invoicedate ,
CAST(unitprice AS numeric) unitprice,
customerid,
country
FROM public.online_retail
WHERE customerid <>''
AND CAST(quantity AS INT) >0 AND CAST(unitprice AS numeric) >0),

online_retail_main AS(SELECT * FROM (SELECT *,
ROW_NUMBER () OVER (PARTITION BY invoiceno,stockcode,quantity ORDER BY invoicedate) AS STT 
FROM online_retail_convert) AS t
WHERE STT=1),


/*Bước 2:
- Tìm ngày mua hàng đầu tiên của mỗi KH => cohort_date
- Tìm index=tháng ( ngày mua hàng-ngày đầu tiên) +1
- Count số lượng KH hoặc tổng doanh thu tại mỗi cohort_ date và index tương ứng
- Pivot tablex */

online_retail_index AS(SELECT customerid,amount,
TO_CHAR(First_purchase_date,'yyyy-mm') AS cohort_date,
invoicedate,
((EXTRACT('year' FROM invoicedate) - EXTRACT('year' FROM First_purchase_date))*12)
+(EXTRACT('month' FROM invoicedate) - EXTRACT('month' FROM First_purchase_date))+1 AS index
FROM
(SELECT customerid,
unitprice*quantity AS amount,
MIN(invoicedate) OVER (PARTITION BY customerid) AS First_purchase_date,
invoicedate
FROM online_retail_main) AS a),

XXX AS(SELECT cohort_date,index,
COUNT(DISTINCT customerid) AS cnt,
SUM(amount) AS revenue
FROM online_retail_index
GROUP BY cohort_date,index),

/* Bước 3: pivot table => cohort chart */

customer_cohort AS(SELECT cohort_date,
SUM(CASE WHEN index=1 then cnt else 0 end) AS "m1",
SUM(CASE WHEN index=2 then cnt else 0 end) AS "m2",
SUM(CASE WHEN index=3 then cnt else 0 end) AS "m3",
SUM(CASE WHEN index=4 then cnt else 0 end) AS "m4",
SUM(CASE WHEN index=5 then cnt else 0 end) AS "m5",
SUM(CASE WHEN index=6 then cnt else 0 end) AS "m6",
SUM(CASE WHEN index=7 then cnt else 0 end) AS "m7",
SUM(CASE WHEN index=8 then cnt else 0 end) AS "m8",
SUM(CASE WHEN index=9 then cnt else 0 end) AS "m9",
SUM(CASE WHEN index=10 then cnt else 0 end) AS "m10",
SUM(CASE WHEN index=11 then cnt else 0 end) AS "m11",
SUM(CASE WHEN index=12 then cnt else 0 end) AS "m12",
SUM(CASE WHEN index=13 then cnt else 0 end) AS "m13"
FROM XXX
GROUP BY cohort_date
ORDER BY cohort_date),

-- retention_cohort
SELECT customer_cohort,
ROUND(100.00*m1/m1,2)||'%' AS m1,
ROUND(100.00*m2/m1,2)||'%' AS m2,
ROUND(100.00*m3/m1,2)||'%' AS m3,
ROUND(100.00*m4/m1,2)||'%' AS m4,
ROUND(100.00*m5/m1,2)||'%' AS m5,
ROUND(100.00*m6/m1,2)||'%' AS m6,
ROUND(100.00*m7/m1,2)||'%' AS m7,
ROUND(100.00*m8/m1,2)||'%' AS m8,
ROUND(100.00*m9/m1,2)||'%' AS m9,
ROUND(100.00*m10/m1,2)||'%' AS m10,
ROUND(100.00*m11/m1,2)||'%' AS m11,
ROUND(100.00*m12/m1,2)||'%' AS m12,
ROUND(100.00*m13/m1,2)||'%' AS m13
FROM customer_cohort

--churn cohort
-- 100 - giá trị ở retention_cohort
