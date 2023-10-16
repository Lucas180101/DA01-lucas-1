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
