--Bài tập 1 
SELECT Name
FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT(Name, 3), ID ASC;
--Bài tập 2
SELECT user_id, 
CONCAT(UPPER(LEFT(name,1)),LOWER(SUBSTRING(name,2))) AS name
FROM Users 
ORDER BY user_id
--Bài tập 3 
SELECT manufacturer, 
'$'||CEILING(SUM(total_sales)/1000000)|| ' '||'million' AS Sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer ASC
-- Bài Tập 4
SELECT product_id,
ROUND(AVG(stars), 2) AS average_stars,
EXTRACT(month FROM submit_date) AS mth
FROM reviews
GROUP BY product_id, mth
ORDER BY mth, product_id;
-- bài tập 5
SELECT sender_id, 
COUNT(message_id) AS message_count
FROM messages
WHERE EXTRACT(MONTH FROM sent_date) = '8'
AND EXTRACT(YEAR FROM sent_date) = '2022'
GROUP BY sender_id 
ORDER BY message_count DESC
LIMIT 2;
--bài tập 6
SELECT tweet_id
FROM Tweets 
WHERE(LENGTH(content))>15
--bài tập 7 
select activity_date as day, count(distinct user_id) as active_users 
from Activity
where activity_date between date_add('2019-07-27', interval -29 day) and '2019-07-27'
group by  activity_date
--bài tập 8
SELECT id, COUNT(id) AS id_count
FROM employees
WHERE joining_date BETWEEN '2022-01-01' AND '2022-08-01'
GROUP BY id;
-- bài tập 9 
SELECT first_name, POSITION('a' IN first_name)
FROM worker
WHERE first_name = 'Amitah';
-- bài tập 10
SELECT SUBSTRING(title FROM LENGTH(winery)+2 FOR 4) AS YEAR_WINE
FROM winemag_p2
WHERE country = 'Macedonia';
