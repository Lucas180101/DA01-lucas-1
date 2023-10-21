-- bài tập 1
SELECT COUNTRY.Continent, FLOOR(AVG(CITY.POPULATION)) 
FROM CITY INNER JOIN COUNTRY on CITY.CountryCode = COUNTRY.Code  
GROUP BY country.continent
-- bài tập 2
SELECT 
ROUND(CAST(COUNT(texts.email_id) AS DECIMAL) / COUNT(DISTINCT emails.email_id), 2) AS activation_rate
FROM emails
LEFT JOIN texts
ON emails.email_id = texts.email_id
AND texts.signup_action = 'Confirmed';
-- bài tập 3
SELECT age.age_bucket, 
  ROUND(100 * SUM(CASE WHEN activities.activity_type = 'send' THEN activities.time_spent ELSE 0 END) / SUM(activities.time_spent), 2) AS send_timespent, 
  ROUND(100 * SUM(CASE WHEN activities.activity_type = 'open' THEN activities.time_spent ELSE 0 END) / SUM(activities.time_spent), 2) AS open_timespent 
FROM activities
INNER JOIN age_breakdown AS age ON activities.user_id = age.user_id 
WHERE activities.activity_type IN ('send', 'open') 
GROUP BY age.age_bucket;
-- bài tập 4 
SELECT customer_id 
FROM customer_contracts 
LEFT JOIN products ON customer_contracts.product_id = products.product_id
GROUP BY customer_id
HAVING COUNT(DISTINCT product_category)>=(SELECT COUNT(DISTINCT product_category) FROM products);
-- bài tập 5
SELECT mng.employee_id, mng.name,
COUNT(emp.reports_to) AS reports_count, 
ROUND(AVG(emp.age)) AS average_age
FROM Employees AS emp
INNER JOIN Employees AS mng ON mng.employee_id = emp. reports_to
GROUP BY  mng.employee_id;
-- bài tập 6
SELECT P.product_name, SUM(O.unit) AS unit
FROM Products AS P
JOIN Orders AS O ON P.product_id = O.product_id
WHERE O.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY O.product_id
HAVING unit >= 100
ORDER BY O.product_id DESC;
-- bài tập 7
SELECT PS.page_id
FROM pages AS PS
FUll JOIN page_likes AS PL
ON PS.page_id=PL.page_id
WHERE user_id IS NULL
ORDER BY page_id ASC;
