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
WITH Longest_film AS
(SELECT a.title, a.length, c.name AS category_film
FROM film AS a
INNER JOIN film_category AS b ON a.film_id = b.film_id
INNER JOIN category AS c ON b.category_id = c.category_id
WHERE c.name IN ('Drama', 'Sports'))

SELECT title, length, category_film
FROM Longest_film
WHERE length = (SELECT MAX(length) FROM Longest_film)
AND category_film = 'Sports';
-- câu 4 
WITH Tong_hop AS 
(SELECT a.title, a.length, c.name AS category_film
FROM film AS a
INNER JOIN film_category AS b ON a.film_id = b.film_id
INNER JOIN category AS c ON b.category_id = c.category_id)

SELECT category_film, COUNT(category_film)||' '|| 'title' AS So_Luong 
FROM Tong_hop
GROUP BY category_film
-- câu 5
WITH Actor_Film_Count AS    
(SELECT a.first_name || ' ' || a.last_name AS Actor_name,
COUNT(b.film_id) AS FILM
FROM actor AS a
INNER JOIN film_actor AS b 
ON a.actor_id = b.actor_id
GROUP BY Actor_name)

SELECT Actor_name, FILM
FROM Actor_Film_Count
WHERE FILM = (SELECT MAX(FILM) FROM Actor_Film_Count);
-- câu 6 
SELECT a.address_id
FROM address AS a
LEFT JOIN customer AS b
ON a.address_id = b.address_id
WHERE b.address_id IS NULL;
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



