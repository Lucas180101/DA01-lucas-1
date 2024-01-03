-- bài tập 1
SELECT
SUM(CASE WHEN DEVICE_TYPE = 'tablet' OR DEVICE_TYPE = 'phone' THEN 1 ELSE 0 END) AS MOBILE_VIEWS,
SUM(CASE WHEN DEVICE_TYPE = 'laptop'THEN 1 ELSE 0 END) AS LAPTOP_VIEWS
FROM VIEWERSHIP;
-- bài tập 2
SELECT *,
IF(x + y > z AND x + z > y AND y + z > x, 'Yes', 'No') AS triangle
FROM Triangle;
--bài tập 3
SELECT
ROUND(100.0 * 
SUM(CASE WHEN call_category IS NULL OR call_category = 'n/a'
THEN 1 ELSE 0 END)/COUNT(call_category), 1) AS call_percentage
FROM callers;
-- bài tập 4 
SELECT name
FROM customer
WHERE COALESCE(referee_id, 0) <> 2;
-- bài 5
SELECT survived,
SUM(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
SUM(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
SUM(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
FROM titanic
GROUP BY survived;
