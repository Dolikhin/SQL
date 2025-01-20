use public;

SELECT *
FROM public.sales_by_film_category sbfc;

SELECT
  amount,
  round(amount / 2, 1),
  ceil(amount / 2),
  floor(amount / 2)
FROM payment;

SELECT
  first_name,
  last_name,
  first_name || ' ' || last_name,
  length(first_name || ' ' || last_name),
  substring(first_name, 1, 3),
  upper(first_name),
  lower(first_name),
  trim('ope' from first_name)
FROM actor;

SELECT 
  email,
  strpos(email,'@'),
  substring(email, 1, strpos(email,'@') - 1)
FROM staff;

SELECT
	payment_id as "№ плажтежа",
	customer_id AS "№ покупателя",
	amount AS "Сумма платежа"
FROM
	public.payment;

SELECT
	amount AS "Сумма в долларах",
	amount * 105 AS "Сумма в рублях"
FROM
	public.payment;

SELECT *
FROM film
WHERE rental_rate = 4.99
LIMIT 10;

SELECT *
FROM rental
WHERE rental_date BETWEEN '2005-05-25' AND '2005-06-25'
LIMIT 10;

SELECT *
FROM film
WHERE title LIKE '%Airport%';

SELECT *
FROM film
WHERE rental_duration IN (6, 7)
	  AND rental_rate > 3
	  AND title LIKE 'A%';

SELECT *
FROM public.payment p 
WHERE amount > 7
	  AND payment_date BETWEEN '2007-03-01' AND '2007-03-31'
LIMIT 7;


SELECT *
FROM public.payment p 
WHERE amount != 7
	  AND NOT (amount BETWEEN 3.5 AND 5.5)
LIMIT 8;

SELECT *
FROM actor
WHERE first_name NOT LIKE '%A%';


SELECT *
FROM actor
ORDER BY first_name, last_name;

SELECT 
  last_name,
  first_name,
  actor_id
FROM actor
ORDER BY 1, 2;

SELECT *
FROM public.address a 
ORDER BY address2 NULLS FIRST;

SELECT DISTINCT -- уникальные значения
  rental_rate
  FROM film;

SELECT DISTINCT 
last_name,
first_name
FROM actor;

SELECT DISTINCT ON (rental_rate) -- уникальное значение только в Postgres, далее поля не уникальные
  rental_rate,
  title
FROM film;

SELECT DISTINCT ON (inventory_id)
	rental_id,
	rental_date,
	inventory_id,
	customer_id,
	return_date,
	staff_id,
	last_update
FROM
	public.rental
ORDER BY inventory_id, rental_date desc;

SELECT DISTINCT ON (staff_id)
  staff_id ,
  amount
FROM payment
ORDER BY staff_id, amount desc;

SELECT trim ('1234567890' FROM '13243556731 Some sting09876434567');


SELECT *
FROM film;

SELECT *
FROM public."language" l;

SELECT 
f.title,
l."name" AS language_namme
FROM film f
  INNER JOIN "language" l
   ON f.language_id = l.language_id;

SELECT 
actor.last_name,
actor.first_name,
f.title
FROM film_actor fa
  INNER JOIN actor
 	 ON fa.actor_id = actor.actor_id
  INNER JOIN film f
  	USING (film_id);

SELECT 
film.title
FROM film
  LEFT OUTER JOIN inventory
    using(film_id)
WHERE inventory_id IS null;


SELECT 
  film.title,
  actor.last_name,
  actor.first_name
FROM film
  INNER JOIN film_actor fa
    ON fa.film_id = film.film_id
  INNER JOIN actor
    ON actor.actor_id = fa.actor_id
WHERE film.title = 'Chamber Italian';


SELECT 
  film.title,
  actor.last_name,
  actor.first_name
FROM film
  JOIN film_actor fa
   USING(film_id)
  JOIN actor
    USING(actor_id)
WHERE film.title = 'Chamber Italian';

SELECT 
  film.title,
  c.name
FROM category c
  JOIN film_category
  USING(category_id)
  JOIN film
  using(film_id)
  WHERE c.name = 'Comedy';

SELECT 
  film.title
FROM film
  LEFT JOIN inventory i
  using(film_id)
WHERE i.film_id IS NULL;

SELECT 
  rating,
  count(*) AS film_count,
  string_agg(title, '; ')
FROM film
GROUP BY rating;


SELECT 
  film.title,
  count(*)
FROM public.inventory i 
JOIN film
  using(film_id)
GROUP BY title 
ORDER BY count;

SELECT   
  f.title,
  count(*) AS payment_count
FROM 
  film f
  JOIN inventory i ON f.film_id = f.film_id 
  JOIN rental r ON r.inventory_id = i.inventory_id 
  JOIN payment p ON p.rental_id = r.rental_id 
WHERE f.rental_rate > 2
GROUP BY
  f.title
HAVING 
  count(*) > 10
ORDER BY 
  payment_count;