/* ARWA ALFALIJ */

/*Q1: We would like to know who were our top 10 paying customers, how many payments they made on a monthly
 basis during 2007, and what was the amount of the monthly payments. Can you write a query to capture the
 customer name, month and year of payment, and total payment amount for each month by these top 10 paying customers? */
 

select date_trunc('month',p.payment_date) as pay_mon,
      concat(c.first_name,'',c.last_name)as fulLName,COUNT(p.payment_id) AS pay_countpermon, SUM(p.amount) AS pay_amount
      FROM payment p
JOIN customer c
ON p.customer_id = c.customer_id

 WHERE p.customer_id IN(select customer_id
  
    from (SELECT customer_id, SUM(amount)
	FROM payment
	WHERE date_part('year',payment_date)='2007'
	GROUP BY 1
	ORDER BY 2 desc
	LIMIT 10)t1)
GROUP BY 1, 2
ORDER BY 2,1

/* -------------------------------------------------------------------------------------------------------------- */

/*Q2: Finally, provide a table with the family-friendly film category, each of the quartiles, and the corresponding
 count of movies within each combination of film category for each corresponding rental duration category. The resulting 
 table should have three columns: Category, Rental length category, Count */

SELECT name, 
       standard_quartile, 
       COUNT(film_title)  
FROM ( SELECT f.title AS film_title, 
	      c.name AS name, 
	      f.rental_duration, 
	      NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile 
        FROM film_category fc 
      JOIN category c  ON fc.category_id=c.category_id
      JOIN  film f  ON
       fc.film_id=f.film_id
         WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music') ) t1 
GROUP BY 1, 2
ORDER BY 1, 2;

 /* ------------------------------------------------------------------------------------------------------------ */
 
 
 /* Q3: We want to find out how the two stores compare in their count of rental orders during every month for 
 all the years we have data for. Write a query that returns the store ID for the store, the year and month and
 the number of rental orders each store has fulfilled for that month. Your table should include a column for 
 each of the following: year, month, store ID and count of rental orders fulfilled during that month. */
 
 
 
SELECT 
DATE_PART ('month',r.rental_date)AS Rental_month,
DATE_PART ('year',r.rental_date) AS Rental_year,s2.store_id,
  COUNT(*) AS Count_rental
FROM  staff AS s1
       JOIN store AS s2
        ON s2.store_id = s1.store_id
		
       JOIN rental r
        ON s1.staff_id = r.staff_id
GROUP BY 1,2,3
order by 4 desc

/* ------------------------------------------------------------------------------------------------------------ */


/*Q4: We want to understand more about the movies that families are watching. The following categories are considered family movies:
 Animation, Children, Classics, Comedy, Family and Music.

Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.*/



SELECT  f.title AS film_title, c.name AS Category_name,
COUNT(r.rental_id)AS rental_out
from category c
JOIN film_category fc 
ON fc.category_id = c.category_id 
JOIN film f
ON f.film_id = fc.film_id
JOIN inventory i
ON i.film_id = f.film_id
JOIN rental r 
ON r.inventory_id = i.inventory_id
GROUP BY 1, 2
HAVING c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
ORDER BY 2, 1
