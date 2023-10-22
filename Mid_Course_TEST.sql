--câu 1
SELECT MIN(replacement_cost) FROM film
-- câu 2 
WITH SUM_low AS (SELECT replacement_cost, 
COUNT(CASE WHEN replacement_cost BETWEEN 9.99 AND 19.99 
THEN 'low'END) AS Low,
COUNT(CASE WHEN replacement_cost BETWEEN 20.00 AND 24.99 
THEN 'medium'END) AS Medium,
COUNT(CASE WHEN replacement_cost BETWEEN 25.00 AND 29.99 
THEN 'high'END) AS High
FROM film
GROUP BY replacement_cost
ORDER BY replacement_cost DESC)
SELECT SUM(Low) FROM SUM_low
-- câu 3 
