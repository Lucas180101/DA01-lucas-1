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
select visited_on, amount, round(amount/7,2) as average_amount
from 
(select distinct visited_on, sum(amount) over(order by visited_on range between interval 6 day preceding and current row) as amount,
min(visited_on) over() as min_date
from customer) q
where visited_on >= min_date+6
-- bài tập 5
SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE tiv_2015 IN 
(SELECT tiv_2015
FROM Insurance
GROUP BY tiv_2015
HAVING COUNT(*) > 1)
  
AND (lat, lon) IN 
(SELECT lat, lon
FROM Insurance
GROUP BY lat, lon
HAVING COUNT(*) = 1);

-- bài tập 6 
WITH employee_department AS
(SELECT d.id, 
d.name AS Department, 
salary AS Salary, 
e.name AS Employee, 
DENSE_RANK()OVER(PARTITION BY d.id ORDER BY salary DESC) AS rnk
FROM Department AS d
JOIN Employee AS e
ON d.id = e.departmentId)

SELECT Department, Employee, Salary
FROM employee_department
WHERE rnk <= 3
-- bài tập 7
SELECT 
a.person_name
FROM Queue as a 
JOIN Queue as b ON a.turn >= b.turn
GROUP BY a.turn
HAVING SUM(b.weight) <= 1000
ORDER BY SUM(b.weight) DESC
LIMIT 1
-- bài tập 8 
WITH cte AS
(SELECT *, RANK() OVER (PARTITION BY product_id ORDER BY change_date DESC) AS r 
FROM Products
WHERE change_date<= '2019-08-16')

SELECT product_id, new_price AS price
FROM cte
WHERE r = 1
UNION
SELECT product_id, 10 AS price
FROM Products
WHERE product_id NOT IN (SELECT product_id FROM cte)
