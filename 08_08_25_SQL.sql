-- Q1: List the first 10 customers showing first_name, last_name, and email.
select first_name, last_name, email
from customer
limit 10;


-- Q2: Find the total number of films available in the inventory.
select count(distinct film_id) as total_films
from inventory;


-- Q3: List all distinct movie ratings from the film table.
select distinct rating
from film;


-- Q4: Get the total amount paid by each customer (use payment table) and order by highest total.
select customer_id, sum(amount) as total_amount_paid
from payment
group by customer_id
order by total_amount_paid desc;


-- Q5: Find all films released in 2006 with a rental duration greater than 5 days.
select film_id, title
from film
where release_year = 2006 and rental_duration > 5;


-- Q6: Rank customers based on their total payment amount using RANK() (highest spender gets rank 1).
with cte as (
select customer_id, sum(amount) as total_amount_spent
from payment
group by customer_id
)
select customer_id, total_amount_spent, 
rank() over(order by total_amount_spent desc) as spender_rank
from cte;


-- Q7: Find the top 3 most rented films per store using ROW_NUMBER() (partition by store).
with cte as (
select i.store_id, f.film_id, f.title, count(r.rental_id) as rental_count,
row_number() over(partition by i.store_id order by count(r.rental_id) desc) as rn
from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on f.film_id = i.film_id
group by i.store_id, f.film_id, f.title
)
select store_id, title, rental_count
from cte 
where rn <= 3;


-- Q8: Calculate the difference between each film’s rental rate and the average rental rate using AVG() OVER().
select film_id, title, rental_rate, 
round(avg(rental_rate) over(),2) as avg_rental_rate,
round(rental_rate - avg(rental_rate) over(),2) as rate_difference
from film;


-- Q9: Show cumulative rental amount per customer ordered by payment date using SUM() OVER(ORDER BY payment_date).
select customer_id, payment_date, amount, sum(amount) over(partition by customer_id order by payment_date) as cumulative_amount
from payment
order by customer_id, payment_date;


-- Q10: For each customer, show their most recent rental date alongside their name using MAX() OVER(PARTITION BY customer_id).
with cte as (
select c.customer_id, c.first_name, c.last_name, r.rental_date,
max(r.rental_date) over(partition by c.customer_id) as most_recent_rental
from customer c 
join rental r on r.customer_id = c.customer_id
order by c.customer_id, r.rental_date desc
)
select distinct customer_id, first_name, last_name, most_recent_rental
from cte ;
