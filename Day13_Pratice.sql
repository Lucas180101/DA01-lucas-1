--bài tập 1
SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM 
(SELECT company_id, title, description, 
COUNT(job_id) AS job_count
FROM job_listings
GROUP BY company_id, title, description) AS job_count_cte
WHERE job_count > 1;
-- bài tập 2
SELECT category, product,total_spend FROM
(SELECT category, product, SUM(spend) AS total_spend
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date)='2022'
GROUP BY  category, product
ORDER BY total_spend DESC)AS RANKED_SPENDING
ORDER BY category,total_spend LIMIT 4
--bài tập 3
SELECT COUNT(policy_holder_id) AS member_count
FROM 
(SELECT policy_holder_id,
COUNT(case_id) AS call_count
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3) AS call_records;
--bài tập 4
SELECT A.page_id
FROM pages AS A 
LEFT JOIN page_likes AS B 
ON A.page_id=B.page_id
WHERE B.page_id IS NULL
-- bài tập 5 
