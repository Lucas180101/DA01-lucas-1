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

