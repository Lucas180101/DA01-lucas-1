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
SELECT a.title,a.length, c.name AS category_name
FROM film AS a
INNER JOIN film_category AS b ON a.film_id=b.film_id
INNER JOIN category AS C ON b.category_id=c.category_id
WHERE c.name='Drama' OR c.name='Sports'
ORDER BY length(c.name) DESC, a.length DESC
  
-- câu 4 
SELECT c.name AS category_name, COUNT(c.name)
FROM film AS a
INNER JOIN film_category AS b ON a.film_id=b.film_id
INNER JOIN category AS C ON b.category_id=c.category_id
GROUP BY category_name
ORDER BY COUNT(c.name) DESC

-- câu 5
SELECT c.first_name, c.last_name, Count(a.film_id) AS movies_count
FROM film_actor AS a 
INNER JOIN film AS b ON a.film_id=b.film_id
INNER JOIN actor AS c ON c.actor_id=a.actor_id
GROUP BY c.first_name, c.last_name
ORDER BY movies_count DESC 
-- câu 6 
SELECT COUNT(a.address_id)
FROM address AS a
LEFT JOIN customer AS b
ON a.address_id = b.address_id
WHERE b.address_id IS NULL

-- câu 7 
SELECT b.city, SUM(d.amount) AS total_amount
FROM address AS a
INNER JOIN city AS b ON a.city_id = b.city_id
INNER JOIN customer AS c ON a.address_id = c.address_id
INNER JOIN payment AS d ON c.customer_id = d.customer_id
GROUP BY b.city
ORDER BY total_amount DESC;
-- câu 8
SELECT e.country || ', ' || b.city AS country_city, SUM(d.amount) AS total_amount
FROM address AS a
INNER JOIN city AS b ON a.city_id = b.city_id
INNER JOIN customer AS c ON a.address_id = c.address_id
INNER JOIN payment AS d ON c.customer_id = d.customer_id
INNER JOIN country AS e ON b.country_id = e.country_id
GROUP BY e.country, b.city
ORDER BY total_amount DESC;
-- thành phố của đất nước nào đat doanh thu cao nhất ( câu này thành phố có doanh thu thấp nhất mới đúng ạ ?)
----Answer: United States, Tallahassee : 50.85.



