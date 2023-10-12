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
-- bài tập 8 
SELECT manufacturer,
COUNT(drug) as Drug_count,
ABS(Sum(cogs-total_sales)) AS Total_loss
FROM pharmacy_sales
WHERE Total_sales<cogs
GROUP BY manufacturer
ORDER BY Total_loss DESC;
FROM monthly_cards_issued
GROUP BY(card_name)
ORDER BY Difference DESC;
-- bài tập 9
SELECT * FROM CINEMA
WHERE id%2=1 and description<>'boring'
order by rating DESC;
-- bài tập 10 
SELECT teacher_id, COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id;
-- bài tập 11
SELECT  user_id, COUNT(follower_id) AS followers_count 
FROM Followers
GROUP BY user_id
ORDER BY user_id;
-- bài tập 12
SELECT CLASS FROM Courses
GROUP BY CLASS 
HAVING COUNT(student)>=5;

