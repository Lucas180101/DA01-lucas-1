-- bài tập 1 
SELECT
    PRODUCTLINE,
    YEAR_ID,
    DEALSIZE,
    SUM(Sales) AS REVENUE
FROM
  public.sales_dataset_rfm_prj_clean
GROUP BY
    PRODUCTLINE,
    YEAR_ID,
    DEALSIZE;
-- bài tập 2 
WITH MonthlyRevenue AS (
SELECT
EXTRACT(MONTH FROM ORDERDATE) AS MONTH_ID,
EXTRACT(YEAR FROM ORDERDATE) AS YEAR_ID,
SUM(Sales) AS REVENUE,
COUNT(DISTINCT ORDERNUMBER) AS ORDER_NUMBER,
ROW_NUMBER() OVER (PARTITION BY EXTRACT(YEAR FROM ORDERDATE) ORDER BY SUM(Sales) DESC) AS ranking
FROM
public.sales_dataset_rfm_prj_clean
GROUP BY
EXTRACT(MONTH FROM ORDERDATE),
EXTRACT(YEAR FROM ORDERDATE))

SELECT MONTH_ID, YEAR_ID, REVENUE, ORDER_NUMBER
FROM MonthlyRevenue
WHERE ranking = 1;
-- bài tập 3 
WITH MonthlyProductLineRevenue AS (
SELECT
EXTRACT(MONTH FROM ORDERDATE) AS MONTH_ID,
PRODUCTLINE,
SUM(Sales) AS REVENUE,
COUNT(DISTINCT ORDERNUMBER) AS ORDER_NUMBER,
ROW_NUMBER() OVER (PARTITION BY EXTRACT(MONTH FROM ORDERDATE) ORDER BY SUM(Sales) DESC) AS ranking
FROM public.sales_dataset_rfm_prj_clean
WHERE EXTRACT(MONTH FROM ORDERDATE) = 11 -- Filter for November
GROUP BY EXTRACT(MONTH FROM ORDERDATE), PRODUCTLINE)

SELECT MONTH_ID, PRODUCTLINE, REVENUE, ORDER_NUMBER
FROM MonthlyProductLineRevenue
WHERE ranking = 1;
-- bài tập 4 
WITH UKProductRevenue AS (
SELECT
EXTRACT(YEAR FROM ORDERDATE) AS YEAR_ID,PRODUCTLINE,
SUM(Sales) AS REVENUE,
ROW_NUMBER() OVER (PARTITION BY EXTRACT(YEAR FROM ORDERDATE) ORDER BY SUM(Sales) DESC) AS RANK
FROM public.sales_dataset_rfm_prj_clean
WHERE COUNTRY = 'UK'
GROUP BY EXTRACT(YEAR FROM ORDERDATE),PRODUCTLINE)

SELECT YEAR_ID, PRODUCTLINE,REVENUE,RANK
FROM UKProductRevenue
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


