use sakila;

-- Q1: List the first name and last name of all customers who live in Canada.
select c.first_name, c.last_name
from customer c
join address a on a.address_id = c.address_id
join city ci on ci.city_id = a.city_id
join country co on co.country_id = ci.country_id
where co.country = 'Canada';


-- Q2: Find the top 5 most rented films by rental count.
select f.title, count(r.rental_id) as rental_count
from rental r 
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
group by f.title
order by rental_count desc
limit 5;


-- Q3: Show the average rental duration per film category.
select c.name as category_name, round(avg(f.rental_duration),2) as avg_rental_duration
from film f
join film_category fc on fc.film_id = f.film_id
join category c on c.category_id = fc.category_id
group by c.name
order by avg_rental_duration desc;


-- Q4: Find the total amount paid by each customer (customer_id, name, total_paid).
select c.customer_id, c.first_name, c.last_name, round(sum(p.amount),2) as total_paid
from customer c 
join payment p on p.customer_id = c.customer_id
group by c.customer_id, c.first_name, c.last_name
order by total_paid desc;


-- Q5: List all customers who have never rented a film.
select c.customer_id, c.first_name, c.last_name
from customer c
left join rental r on r.customer_id = c.customer_id
where r.rental_id is null;


-- Q6: For each customer, calculate the running total of payments ordered by payment_date.
select c.customer_id,
    c.first_name,
    c.last_name,
    date(p.payment_date),
    p.amount,
    sum(p.amount) over(partition by c.customer_id order by date(p.payment_date)) as running_total
from customer c 
join payment p on p.customer_id = c.customer_id
order by c.customer_id, p.payment_date;


-- Q7: Use ROW_NUMBER() to list the most recent rental per customer.
with cte as (
select rental_id, customer_id, rental_date, 
row_number() over(partition by customer_id order by rental_date desc) as rn
from rental
)
select c.customer_id,
    c.first_name,
    c.last_name,
    ct.rental_id,
    ct.rental_date
    from cte ct 
    join customer c on c.customer_id = ct.customer_id
    where ct.rn = 1
    order by ct.rental_date desc;
    
    
-- Q8: Find the top 3 most rented films per store using ROW_NUMBER() with PARTITION BY.
with cte as (
select i.store_id, f.title, count(r.rental_id) as rental_count,
row_number() over(partition by i.store_id order by count(r.rental_id) desc) as rn
from rental r
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
group by i.store_id, f.title
)
select 	store_id, title, rental_count
from cte 
where rn <= 3
order by store_id, rental_count desc;


-- Q9: Calculate the difference between each film’s rental rate and the average rental rate using AVG() OVER().
select film_id, title, rental_rate, round(rental_rate - avg(rental_rate) over(), 2) as diff_from_avg
from film
order by diff_from_avg desc;


-- Q10: Show cumulative rental amount per customer ordered by payment date using SUM() OVER().
select c.customer_id,
    c.first_name,
    c.last_name,
    date(p.payment_date) as payment_date,
    p.amount,
    sum(p.amount) over(partition by c.customer_id order by date(p.payment_date) ) as cum_amount
from customer c 
join payment p on c.customer_id = p.customer_id
order by c.customer_id, p.payment_date;

