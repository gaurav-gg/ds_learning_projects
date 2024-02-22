use sakila;

select concat(first_name,' ',last_name) as Actor_name
from Film_actor fa
inner join actor a using(actor_id)
group by actor_id
order by count(film_id) desc
limit 1 offset 2;

select title from film
inner join inventory i using(film_id)
inner join rental r using(inventory_id)
inner join payment p using(rental_id)
group by title
order by sum(p.amount) desc;

select city from city
inner join address using(city_id)
inner join customer using(address_id)
inner join payment using(customer_id)
group by city
order by sum(amount) desc
limit 1;

select cat.Name, count(r.rental_id) as Rental_count from category cat
inner join film_category using(category_id)
inner join film using(film_id)
inner join inventory i using(film_id)
inner join rental r using(inventory_id)
group by cat.name
order by count(r.rental_id) desc;

select concat(First_Name,' ',Last_Name) as Customer_Name from category cat
inner join film_category using(category_id)
inner join film using(film_id)
inner join inventory i using(film_id)
inner join rental r using(inventory_id)
inner join customer using(customer_id)
where cat.Name='Sci-Fi'
group by Customer_Name
having count(rental_id)>2
order by Customer_Name;

select concat(First_Name,' ',Last_Name) as Customer_name from rental
inner join customer using(customer_id)
inner join address using(address_id)
inner join city using(city_id)
where city = 'Arlington';

select country, count(rental_id) as Rental_count from rental
inner join customer using(customer_id)
inner join address using(address_id)
inner join city using(city_id)
inner join country using(country_id)
group by country
order by country;
