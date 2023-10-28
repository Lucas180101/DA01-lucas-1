-- bài tập 1
WITH cte AS 
(SELECT *,
COUNT(customer_id) OVER (PARTITION BY customer_id ORDER BY CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) AS first_delivery_id
FROM Delivery)

SELECT ROUND(100*first_delivery_id/COUNT(DISTINCT customer_id),2) AS  immediate_percentage
FROM cte
-- bài tập 2 
WITH PlayerActivity AS 
(SELECT PLAYER_ID,
ABS(MIN(EVENT_DATE) - MAX(EVENT_DATE)) AS DateDifference
FROM ACTIVITY
GROUP BY PLAYER_ID)

SELECT ROUND(COUNT(DISTINCT PLAYER_ID) / (SELECT COUNT(DISTINCT PLAYER_ID) 
FROM ACTIVITY), 2) AS FRACTION
FROM PlayerActivity
WHERE DateDifference = 1;
-- bài tập 3 
SELECT 
CASE
WHEN (id = (SELECT MAX(id) FROM Seat) AND id MOD 2 = 1) THEN id
WHEN (id MOD 2 = 1) THEN id+1
WHEN (id MOD 2 = 0) THEN id-1
END AS id, student
FROM Seat
ORDER BY id;
-- bài tập 4
