/* bước 1: Tính các giá trị R-F-M */

WITH customer_rfm AS(SELECT a.customer_id,
current_date - MAX(b.order_date) AS R,
COUNT(DISTINCT order_id) AS F,
SUM(sales) AS M
FROM public.customer AS a
INNER JOIN public.sales AS b ON a.customer_id=b.customer_id
GROUP BY a.customer_id),

/* bước 2: Tính các giá trị trên khoảng từ 1-5 */
R_F_M_score AS(SELECT customer_id,
ntile(5) OVER (ORDER BY R DESC) AS R_score,
ntile(5) OVER (ORDER BY F ) AS F_score,
ntile(5) OVER (ORDER BY M ) AS M_score
FROM customer_rfm),

/* Bước 3: Phân nhóm theo tổ hợp 125 R_F_M*/
rfm_final AS(SELECT customer_id,
CAST(R_score AS VARCHAR)||CAST(F_score AS VARCHAR)||CAST(M_score AS VARCHAR) AS rfm_score
FROM R_F_M_score)

SELECT segment, COUNT(*) FROM(SELECT a.customer_id, b.segment FROM rfm_final AS a
JOIN public.segment_score AS b ON a.rfm_score=b.scores) AS a
GROUP BY segment
ORDER BY COUNT(*)
/* Bước 4: Trực quan phân nhóm RFM */
