-- bài tập 1
SELECT NAME FROM CITY
WHERE COUNTRYCODE = 'USA' AND POPULATION >120000
-- Bài tập 2
SELECT * FROM CITY
WHERE COUNTRYCODE = 'JPN'
-- bài tập 3 
SELECT CITY,STATE FROM STATION
-- bài tập 4 
SELECT DISTINCT city FROM station WHERE city LIKE 'A%'OR city LIKE 'E%'
OR city LIKE 'I%'
OR city LIKE 'O%'
OR city LIKE 'U%'
OR city LIKE 'a%'
OR city LIKE 'e%'
OR city LIKE 'i%'
OR city LIKE 'o%'
OR city LIKE 'u%';
-- bài tập 5 
SELECT DISTINCT city FROM station WHERE city LIKE '%A'OR city LIKE '%E'
OR city LIKE '%I'
OR city LIKE '%O'
OR city LIKE '%U'
OR city LIKE '%a'
OR city LIKE '%e'
OR city LIKE '%i'
OR city LIKE '%o'
OR city LIKE '%u';
-- bài tập 6 
SELECT DISTINCT CITY FROM STATION
WHERE CITY NOT LIKE 'A%' AND CITY NOT LIKE 'E%' AND CITY NOT LIKE 'I%' 
AND CITY NOT LIKE 'O%' AND CITY NOT LIKE 'U%';
-- bài tập 7 
SELECT name FROM Employee
ORDER BY name 
-- bài tập 8 
SELECT name FROM Employee
WHERE salary >2000 AND months <10
ORDER BY employee_id 
-- bài tập 9 
SELECT product_id FROM Products
WHERE Low_fats = 'Y' AND recyclable = 'Y'
-- bài tập 10 
SELECT name FROM Customer
WHERE NOT referee_id = 2 OR referee_id IS NULL
-- bài tập 11 

