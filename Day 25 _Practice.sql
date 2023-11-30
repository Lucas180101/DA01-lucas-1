-- bài tập 1
SELECT 
  PRODUCTLINE,
  YEAR_ID,
  DEALSIZE,
  SUM(sales) AS REVENUE
FROM public.sales_dataset_rfm_prj_clean
GROUP BY PRODUCTLINE, YEAR_ID, DEALSIZE
ORDER BY REVENUE DESC;
-- bài tập 2 
WITH MonthlyRevenueRank AS (
SELECT
    YEAR_ID,
    MONTH_ID,
    SUM(sales) AS REVENUE,
    COUNT(DISTINCT ORDERNUMBER) AS ORDER_NUMBER,
    RANK() OVER (PARTITION BY YEAR_ID ORDER BY SUM(sales) DESC) AS ranks
  FROM public.sales_dataset_rfm_prj_clean
  GROUP BY YEAR_ID, MONTH_ID)

SELECT
  YEAR_ID,
  MONTH_ID,
  REVENUE,
  ORDER_NUMBER
FROM MonthlyRevenueRank
WHERE ranks = 1;
-- bài tập 3
WITH NovemberSales AS (
  SELECT
    MONTH_ID,
    PRODUCTLINE,
    SUM(sales) AS REVENUE,
    COUNT(DISTINCT ORDER_NUMBER) AS ORDER_NUMBER
  FROM public.sales_dataset_rfm_prj_clean
  WHERE MONTH_ID = 11
  GROUP BY MONTH_ID, PRODUCTLINE)

SELECT
  MONTH_ID,
  PRODUCTLINE,
  REVENUE,
  ORDER_NUMBER
FROM NovemberSales
ORDER BY REVENUE DESC;
-- bai tập 4 
WITH UKYearlyProductRank AS (
  SELECT
    YEAR_ID,
    PRODUCTLINE,
    SUM(sales) AS REVENUE,
    RANK() OVER (PARTITION BY YEAR_ID ORDER BY SUM(sales) DESC) AS RANK
  FROM public.sales_dataset_rfm_prj_clean
  WHERE COUNTRY = 'UK'
  GROUP BY YEAR_ID, PRODUCTLINE
)

SELECT
  YEAR_ID,
  PRODUCTLINE,
  REVENUE,
  RANK
FROM UKYearlyProductRank
WHERE RANK = 1;
-- bài tập 5 
WITH customer_rfm AS (
SELECT
a.customer_id,
CURRENT_DATE - MAX(order_date) AS R,
COUNT(DISTINCT order_id) AS F,
SUM(sales) AS M
FROM
customer a
JOIN
sales b ON a.customer_id = b.customer_id
GROUP BY
a.customer_id),

rfm_score AS (
SELECT
customer_id,
NTILE(5) OVER (ORDER BY R DESC) AS R_score,
NTILE(5) OVER (ORDER BY F) AS F_score,
NTILE(5) OVER (ORDER BY M) AS M_score
FROM
customer_rfm),

rfm_final AS (
SELECT
customer_id,
CAST(R_score AS VARCHAR) || CAST(F_score AS VARCHAR) || CAST(M_score AS VARCHAR) AS rfm_score
FROM
rfm_score),

ranked_customers AS (
SELECT customer_id,
RANK() OVER (ORDER BY CAST(rfm_score AS INT) DESC) AS rfm_rank
FROM
rfm_final)

SELECT
  a.customer_id,
  b.segment,
  c.rfm_rank
FROM
  rfm_final a
JOIN
  segment_score b ON a.rfm_score = b.scores
JOIN
  ranked_customers c ON a.customer_id = c.customer_id
WHERE
  c.rfm_rank = 1;  


