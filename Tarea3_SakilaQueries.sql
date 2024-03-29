----TAREA 3 - BASES DE DATOS


----PREGUNTA 1: C�mo obtenemos todos los nombres y correos de nuestros clientes canadienses para una campa�a?
select * from customer c4;
select * from address a;
select * from city c;
select * from country c;

select c.last_name || ' ' || c.first_name as nombre , c.email as correo_electronico
from customer c join address a using(address_id) join city c2 using(city_id) join country c3 using(country_id)
where country like('Canada')
order by nombre asc;


----PREGUNTA 2: Qu� cliente ha rentado m�s de nuestra secci�n de adultos?
select * from customer c;
select * from rental r;
select * from inventory i;
select * from film f;

select c.last_name || ' ' || c.first_name as nombre, count(*) as numero_peliculas
from film f join inventory i using (film_id) join rental r using (inventory_id) join customer c using (customer_id)
where f.rating = 'NC-17'
group by f.rating, c.customer_id
order by numero_peliculas desc 
limit 2;---SE DEJO EL LIMITE EN 2 YA QUE, AL HACER EL QUERY, NOTE QUE HABIA DOS PERSONAS CON LA MAXIMA CANTIDAD DE PELICULAS VISTAS


----PREGUNTA 3: Qu� pel�culas son las m�s rentadas en todas nuestras stores?
select * from film f;
select * from inventory i;
select * from rental r;

select f.title as nombre_pelicula, count(r.rental_id) as numero_rentas
from film f join inventory i using (film_id) join rental r using(inventory_id)
group by nombre_pelicula
having count(r.rental_id)>30
order by numero_rentas desc;


----PREGUNTA 4: Cu�l es nuestro revenue por store?
select * from address a;
select * from inventory i;
select * from rental r;
select * from payment p;
select * from store s;

select a.address as store,sum(p.amount) as revenue
from address a join store s using (address_id) join inventory i using(store_id) join rental r using(inventory_id) join payment p using(rental_id)
group by store
order by revenue desc;