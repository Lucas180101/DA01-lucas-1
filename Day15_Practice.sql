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
SELECT    
user_id,    
tweet_date,   
ROUND(AVG(tweet_count) OVER (PARTITION BY user_id ORDER BY tweet_date     
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_avg_3d
FROM tweets;
-- bài tập 6
with cte as (select*,
lag(transaction_timestamp) over (partition by merchant_id, credit_card_id, amount 
order by transaction_timestamp) as prev_transaction_time 
from transactions)

select count(transaction_id) as payment_count from cte 
where extract(epoch from transaction_timestamp - prev_transaction_time)/60 <= 10;
-- bài tập 7
SELECT category, product, total_spend
FROM (SELECT *,
RANK() OVER (PARTITION BY category ORDER BY total_spend DESC) AS rnk
FROM (SELECT category, product, SUM(spend) AS total_spend
FROM product_spend
WHERE transaction_date >= '2022-01-01' AND transaction_date < '2023-01-01'
GROUP BY category, product) AS subquery) AS ranked_data
WHERE rnk < 3;
-- bài tập 8 
WITH top_10_cte AS 
(SELECT artists.artist_name,
DENSE_RANK() OVER (ORDER BY COUNT(songs.song_id) DESC) AS artist_rank
FROM artists
INNER JOIN songs
ON artists.artist_id = songs.artist_id
INNER JOIN global_song_rank AS ranking
ON songs.song_id = ranking.song_id
WHERE ranking.rank <= 10
GROUP BY artists.artist_name)

SELECT artist_name, artist_rank
FROM top_10_cte
WHERE artist_rank <= 5;
