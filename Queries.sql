/*Query1-query used for first insight */
SELECT c.name AS category_name, COUNT(r.inventory_id) AS rental_count
FROM film_category fc 
JOIN category c 
ON fc.category_id = c.category_id
JOIN film f 
ON fc.film_id = f.film_id
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r 
ON i.inventory_id = r.inventory_id
WHERE c.name IN ('Animation','Children','Classics',
'Comedy','Family','Music')
GROUP BY 1
ORDER BY 2 ASC, 1 ASC;

/*Query2 - query used for second insight */
 WITH f1 AS (SELECT f.title AS film_title,c.name cat_name,
 NTILE(3) OVER ( ORDER BY f.rental_duration DESC) AS rental_duration
FROM film_category fc 
JOIN category c 
ON fc.category_id = c.category_id
JOIN film f 
ON fc.film_id = f.film_id
WHERE c.name IN ('Animation','Children','Classics',
'Comedy','Family','Music')),

 f2 AS (
  SELECT f.title AS titlemov, c.name cat_name,
  f.rental_duration
FROM film_category fc 
JOIN category c 
ON fc.category_id = c.category_id
JOIN film f 
ON fc.film_id = f.film_id)

SELECT f1.*, 
NTILE(4) OVER (ORDER BY f2.rental_duration) AS standard_quartile
FROM f2 
JOIN f1 
ON f2.titlemov = f1.film_title
ORDER BY f1.rental_duration DESC

/*Query3 - query used for second insight */
WITH f1 AS (SELECT c.name cat_name,
 NTILE(4) OVER ( ORDER BY f.rental_duration ) AS rental_duration
FROM film_category fc 
JOIN category c 
ON fc.category_id = c.category_id
JOIN film f 
ON fc.film_id = f.film_id
WHERE c.name IN ('Animation','Children','Classics',
'Comedy','Family','Music'))

SELECT f1.*, COUNT(f1.*) 
FROM f1
GROUP BY f1.cat_name,f1.rental_duration
ORDER BY f1.cat_name, f1.rental_duration

/*Query4 - query used for second insight */
WITH f1 AS(SELECT i.store_id AS Store_ID, COUNT(r.rental_id) AS Count_rentals,
DATE_TRUNC('month',r.rental_date) AS date
FROM inventory i 
JOIN rental r 
ON i.inventory_id = r.inventory_id
GROUP BY 1,3
ORDER BY 2 DESC)

SELECT EXTRACT(MONTH FROM f1.date) AS Rental_month,
EXTRACT(YEAR FROM f1.date) AS Rental_year,
f1.Store_ID, f1.Count_rentals
FROM f1