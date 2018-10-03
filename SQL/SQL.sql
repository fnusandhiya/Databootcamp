-- use sakila database and tables
use sakila;
show Tables;

-- 1a: show first and last name of actors
SELECT first_name, last_name
FROM actor;

-- 1b: Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name' FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'joe';

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT * FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT * FROM actor
WHERE last_name LIKE '%LI%';
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. create a column in the table actor named description and use the data type BLOB
ALTER TABLE actor
ADD description BLOB;

-- 3b. Delete the description column 
ALTER TABLE actor
DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) as 'Count'
FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) as 'Count'
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS.
UPDATE actor
SET first_name='HARPO'
WHERE first_name='GROUCHO' and last_name = 'WILLIAMS';

-- 4D. if the first name of the actor is currently HARPO, change it to GROUCHO
UPDATE actor
SET first_name='GROUCHO'
WHERE first_name='HARPO' and last_name = 'WILLIAMS';

-- 5a. Re-create and locate the schema of address table
SHOW CREATE TABLE address

-- 6a. display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT staff.staff_id, first_name, last_name, address
FROM staff
INNER JOIN address ON staff.address_id = address.address_id;

-- 6b. display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT staff.staff_id, first_name, last_name, sum(amount) as 'Total Payment'
FROM staff
INNER JOIN payment ON staff.staff_id = payment.staff_id
-- WHERE payment_date LIKE '%2005-08%'
GROUP BY staff.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT film.film_id, title, count(actor_id) as 'Actor Count'
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film.film_id;

-- 6d. 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film.film_id, title, count(inventory_id) as 'No: of Copies'
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
GROUP BY film.film_id
HAVING title = 'Hunchback Impossible';

-- 6e. list the total paid by each customer. List the customers alphabetically by last name:
SELECT first_name, last_name, sum(amount) as 'Total Amount Paid'
FROM customer
INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY last_name ASC;

-- 7a. display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
	FROM film
    WHERE language_id
    IN (
      SELECT language_id
        FROM language
        WHERE name = 'English'
        )
		AND (title LIKE 'K%') OR (title LIKE 'Q%')
        
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
	FROM actor
    WHERE actor_id
    IN (
      SELECT actor_id
        FROM film_actor
        WHERE film_id
        IN (
          SELECT film_id
            FROM film
            WHERE title = 'Alone Trip'
            )
		);
	
-- 7c. Find names and email addresses of all Canadian customers.
SELECT fisrt_name, last_name, email, country
FROM (((customer
LEFT JOIN address ON customer.address_id = address.address_id)
LEFT JOIN city ON city.city_id = address.city_id)
LEFT JOIN country ON country.country_id = city.country_id)
WHERE country = 'Canada';

-- 7d. Identify all movies categorized as family films.
SELECT title FROM film
WHERE film_id IN
		(
        SELECT film_id
        FROM film_category
        WHERE category_id IN
			(
            SELECT category_id
            FROM category
            WHERE name = 'Family'
            )
		);
        
-- 7e. Display the most frequently rented movies in descending order.
SELECT title, count(rental_id) AS 'Rental Count'
FROM film
RIGHT JOIN inventory
ON film.film_id = inventory.film_id
INNER JOIN rental
ON rental.inventory_id = inventory.inventory_id
GROUP BY film.title
ORDER BY count(rental_id) DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, sum(amount) AS 'Revenue'
FROM store
LEFT JOIN staff ON store.store_id = staff.store_id
LEFT JOIN payment ON payment.staff_id = staff.staff_id
GROUP BY store.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN address ON store.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id;

-- 7h. List the top five genres in gross revenue in descending order.
SELECT category.name, sum(amount) AS 'Gross Revenue' FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN inventory ON film_category.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY sum(amount) DESC
LIMIT 5;

-- 8a. Create a view for Top five genres by gross revenue.
CREATE VIEW Top_five_Genres AS
SELECT category.name, sum(amount) AS 'Gross Revenue' FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN inventory ON film_category.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY sum(amount) DESC
LIMIT 5;

-- 8b. display the view that you created in 8a?
SELECT * FROM Top_five_Genres;

-- 8c. Delete the top_five_genres view.
DROP VIEW Top_five_Genres;




























