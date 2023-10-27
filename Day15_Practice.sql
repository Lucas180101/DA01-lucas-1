-- bài tập 1
SELECT
EXTRACT(YEAR FROM transaction_date) AS year,
product_id,
spend AS curr_year_spend,
LAG(spend) OVER (PARTITION BY product_id ORDER BY EXTRACT(YEAR FROM transaction_date)) AS prev_year_spend,
ROUND
(100*(spend - LAG(spend) OVER (PARTITION BY product_id ORDER BY EXTRACT(YEAR FROM transaction_date)))
/LAG(spend) OVER (PARTITION BY product_id ORDER BY EXTRACT(YEAR FROM transaction_date)),2) AS yoy_rate
FROM user_transactions;
-- bài tập 2 
with cte as 
(select *,rank() over(partition by card_name order by issue_year, issue_month) as rnk 
from monthly_cards_issued )

select card_name, issued_amount 
from cte
where rnk = 1
order by issued_amount desc;
-- bài tập 3
WITH cte AS
(SELECT *, RANK() OVER (PARTITION BY user_id ORDER BY transaction_date) AS RANKING_ID
FROM transactions)

SELECT user_id,	spend,	transaction_date
FROM cte
WHERE RANKING_ID = 3;
-- bài tập 4 
WITH cte AS 
(SELECT transaction_date, user_id,product_id,
    RANK() OVER (PARTITION BY user_id ORDER BY transaction_date DESC) AS transaction_rank
    FROM user_transactions)

SELECT transaction_date, user_id, COUNT(product_id) AS purchase_count
FROM cte
WHERE transaction_rank = 1
GROUP BY transaction_date, user_id
ORDER BY transaction_date;
-- bài tập 5 
