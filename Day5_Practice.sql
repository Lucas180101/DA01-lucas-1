-- bài tập 1
SELECT DISTINCT CITY FROM STATION 
WHERE ID%2=0
-- bài tập 2
SELECT COUNT(CITY) - COUNT(DISTINCT CITY) FROM STATION
-- bài tập 4
SELECT ROUND(CAST(SUM(order_occurrences*item_count)/SUM(order_occurrences)AS
DECIMAL),1) AS MEAN
FROM items_per_order;
-- bài tập 5
SELECT candidate_id
FROM candidates
WHERE skill in ('Python', 'Tableau','PostgreSQL')
GROUP BY candidate_id
having count (Skill) = 3
-- bài tập 6
SELECT user_id,
DATE(MAX(post_date))-DATE(Min(post_date))AS DAYS_BETWEEN
FROM posts
WHERE post_date>= '2021-01-01' AND post_date< '2022-01-01'
GROUP BY user_id 
HAVING COUNT(post_id)>=2;
-- bài tập 7 
SELECT card_name,
MAX(issued_amount)-Min(issued_amount) AS Difference
FROM monthly_cards_issued
GROUP BY(card_name)
ORDER BY Difference DESC;
-- bài tập 8 

