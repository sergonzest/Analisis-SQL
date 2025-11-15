
--Muestra los nombres de todas las películas con una clasificación por
edades de ‘R’.

select title , rating 
from film f 
where rating = 'R'

--. Encuentra los nombres de los actores que tengan un “actor_id” entre 30
y 40.
select actor_id , first_name , last_name  
from actor a 
where ACTOR_ID between 30 and 40

--Obtén las películas cuyo idioma coincide con el idioma original.
select title , language_id , original_language_id 
from film f 
where language_id = original_language_id 

--Ordena las películas por duración de forma ascendente.
select title , length 
from film f 
order by length asc

--Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su
apellido.

SELECT first_name, last_name
FROM actor
WHERE UPPER(last_name) LIKE '%ALLEN%';
--Encuentra la cantidad total de películas en cada clasificación de la tabla
“film” y muestra la clasificación junto con el recuento.

SELECT rating AS clasificacion, COUNT(*) AS total_peliculas
FROM film
GROUP BY rating;

--Encuentra el título de todas las películas que son ‘PG-13’ o tienen una
duración mayor a 3 horas en la tabla film.

SELECT title
FROM film
WHERE rating = 'PG-13'
   OR length > 180;

--Encuentra la variabilidad de lo que costaría reemplazar las películas
SELECT VARIANCE(replacement_cost) AS Coste_reemplazo
FROM film;

--Encuentra la mayor y menor duración de una película de nuestra BBDD.

select 
    MIN(length) AS duracion_minima,
    MAX(length) AS duracion_maxima
FROM film;

--Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

SELECT amount
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
ORDER BY r.rental_date DESC, r.rental_id DESC
OFFSET 2 LIMIT 1;

--Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC17’ ni ‘G’ en cuanto a su clasificación.

select title , rating 
from film f 
where rating not in ('NC-17', 'G')

--Encuentra el promedio de duración de las películas para cada
clasificación de la tabla film y muestra la clasificación junto con el
promedio de duración.

SELECT rating AS clasificacion, AVG(length) AS promedio_duracion
FROM film
GROUP BY rating;

--Encuentra el título de todas las películas que tengan una duración mayor
a 180 minutos.
select title , length 
from film f 
where length  >= 180

--. ¿Cuánto dinero ha generado en total la empresa?
select SUM(amount) as Ingresos_totales
from payment p 

--. Muestra los 10 clientes con mayor valor de id.

SELECT *
FROM customer
ORDER BY customer_id DESC
LIMIT 10;

--Encuentra el nombre y apellido de los actores que aparecen en la
película con título ‘Egg Igby’.
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON f.film_id = fa.film_id
WHERE f.title = 'EGG IGBY';

--Selecciona todos los nombres de las películas únicos.
SELECT DISTINCT title
FROM film
ORDER BY title;

--Encuentra el título de las películas que son comedias y tienen una
duración mayor a 180 minutos en la tabla “film”.

SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy'
  AND f.length > 180;

--Encuentra las categorías de películas que tienen un promedio de
duración superior a 110 minutos y muestra el nombre de la categoría
junto con el promedio de duración.

SELECT c.name AS categoria, AVG(f.length) AS promedio_duracion
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.length) > 110
ORDER BY promedio_duracion DESC;

--¿Cuál es la media de duración del alquiler de las películas?
select AVG(rental_duration) as duración_alquiler
from film f 

--Crea una columna con el nombre y apellidos de todos los actores y
actrices.

select concat(first_name,' ', last_name ) as nombre_actor
from actor a 

--Números de alquiler por día, ordenados por cantidad de alquiler de
forma descendente.

select
		rental_date::DATE as dia_alquiler,
		COUNT(*) as cantidad_alquileres
from rental r 
group by rental_date::DATE
order by cantidad_alquileres desc

--Encuentra las películas con una duración superior al promedio
select title , length 
from film f  
where length > (
	select AVG(length)
	from film)
	;

--Averigua el número de alquileres registrados por mes.
SELECT
    EXTRACT(MONTH FROM rental_date) as mes,
    EXTRACT(YEAR FROM rental_date) as año,
    COUNT(*) AS cantidad_alquileres
FROM rental
GROUP BY mes,año
ORDER BY mes, año desc;

--Encuentra el promedio, la desviación estándar y varianza del total
pagado.

SELECT 
    SUM(amount) AS gasto_total,
    AVG(amount) AS promedio,
    STDDEV(amount) AS desviacion_estandar,
    VARIANCE(amount) AS varianza
from payment;

--¿Qué películas se alquilan por encima del precio medio?
select title , rental_rate 
from film f 
where rental_rate > (
	select avg(rental_rate)
	from film);

--Muestra el id de los actores que hayan participado en más de 40
películas.

SELECT actor_id
FROM film_actor fa 
GROUP BY actor_id
HAVING COUNT(film_id) >40;

--Obtener todas las películas y, si están disponibles en el inventario,
mostrar la cantidad disponible.

SELECT 
    f.film_id,
    f.title,
    COUNT(i.inventory_id) AS cantidad_disponible
FROM film f
LEFT JOIN inventory i 
    ON f.film_id = i.film_id
LEFT JOIN rental r 
    ON i.inventory_id = r.inventory_id 
    AND r.return_date IS NULL
WHERE r.rental_id IS NULL 
GROUP BY f.film_id, f.title
ORDER BY f.title;

--Obtener los actores y el número de películas en las que ha actuado.

SELECT 
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS numero_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name

--Obtener todas las películas y mostrar los actores que han actuado en
ellas, incluso si algunas películas no tienen actores asociados.
SELECT 
    f.film_id,
    f.title,
    COALESCE(STRING_AGG(a.first_name || ' ' || a.last_name, ', ' ORDER BY a.last_name, a.first_name), 'Sin actores asociados') AS actores
FROM film f
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.film_id, f.title
ORDER BY f.title;

--Obtener todos los actores y mostrar las películas en las que han
actuado, incluso si algunos actores no han actuado en ninguna película.
SELECT 
    a.actor_id,
    a.first_name,
    a.last_name,
    COALESCE(STRING_AGG(f.title, ', ' ORDER BY f.title), 'Sin películas asociadas') AS peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film f ON fa.film_id = f.film_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY a.last_name, a.first_name;

--Obtener todas las películas que tenemos y todos los registros de
alquiler
SELECT f.title, r.*
FROM film f
LEFT JOIN inventory i 
    ON f.film_id = i.film_id
LEFT JOIN rental r
    ON i.inventory_id = r.inventory_id
       AND r.return_date IS NOT NULL;

--Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(p.amount) AS total_gastado
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC
LIMIT 5;

--Selecciona todos los actores cuyo primer nombre es 'Johnny'.
SELECT 
    actor_id,
    first_name,
    last_name
FROM actor
WHERE first_name = 'Johnny';

--Renombra la columna “first_name” como Nombre y “last_name” como
Apellido.
SELECT 
    actor_id,
    first_name AS "Nombre",
    last_name AS "Apellido"
FROM actor;

--Encuentra el ID del actor más bajo y más alto en la tabla actor.
select MIN(actor_id ) as actor_id_mas_bajo,
MAX(actor_id ) as actor_id_mas_alto
from actor a ;

--Cuenta cuántos actores hay en la tabla “actor”.

select COUNT(actor_id ) as actores_totales
from actor a ;

--Selecciona todos los actores y ordénalos por apellido en orden
ascendente.
select first_name , last_name 
from actor a 
order by a.last_name asc ;

--Selecciona las primeras 5 películas de la tabla “film
select title 
from film f 
limit 5;

--Agrupa los actores por su nombre y cuenta cuántos actores tienen el
mismo nombre. ¿Cuál es el nombre más repetido?

SELECT 
    first_name AS nombre,
    COUNT(*) AS cantidad
FROM actor
GROUP BY first_name
ORDER BY cantidad DESC
LIMIT 1;

--Encuentra todos los alquileres y los nombres de los clientes que los
realizaron.

SELECT 
    r.rental_id,
    r.rental_date,
    r.return_date,
    c.customer_id,
    c.first_name,
    c.last_name
FROM rental r
INNER JOIN customer c ON r.customer_id = c.customer_id
ORDER BY r.rental_date;

--Muestra todos los clientes y sus alquileres si existen, incluyendo
aquellos que no tienen alquileres.

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    r.rental_id,
    r.rental_date,
    r.return_date
FROM customer c
LEFT JOIN rental r 
    ON c.customer_id = r.customer_id
ORDER BY c.customer_id, r.rental_date;

--Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor
esta consulta? ¿Por qué? Deja después de la consulta la contestación.
SELECT 
    f.film_id,
    f.title,
    c.category_id,
    c.name AS category_name
FROM film f
CROSS JOIN category c;
--No aporta valor ya que no existe relación directa entre todas las peliculas y tosas las categorias

--Encuentra los actores que han participado en películas de la categoría
'Action'.

SELECT DISTINCT 
    a.actor_id,
    a.first_name,
    a.last_name
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
INNER JOIN film_category fc ON fa.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action'
ORDER BY a.last_name, a.first_name;

--Encuentra todos los actores que no han participado en películas.
SELECT 
    a.actor_id,
    a.first_name,
    a.last_name
FROM actor a
LEFT JOIN film_actor fa 
    ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL
ORDER BY a.last_name, a.first_name;

--Selecciona el nombre de los actores y la cantidad de películas en las
que han participado.

SELECT 
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS total_peliculas
FROM actor a
LEFT JOIN film_actor fa 
    ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY total_peliculas DESC, a.last_name, a.first_name;

--Crea una vista llamada “actor_num_peliculas” que muestre los nombres
de los actores y el número de películas en las que han participado.

CREATE VIEW actor_num_peliculas AS
SELECT 
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS total_peliculas
FROM actor a
LEFT JOIN film_actor fa 
    ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

--
SELECT * FROM actor_num_peliculas ORDER BY total_peliculas DESC;

--Calcula el número total de alquileres realizados por cada cliente.
SELECT customer_id, COUNT(*) AS total_alquileres
FROM rental
GROUP BY customer_id;

--Calcula la duración total de las películas en la categoría 'Action'.
SELECT 
    c.name AS categoria,
    SUM(f.length) AS duracion_total
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action'
GROUP BY c.name;

--Crea una tabla temporal llamada “cliente_rentas_temporal” para
almacenar el total de alquileres por cliente.

CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_alquileres
FROM customer c
LEFT JOIN rental r 
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquileres DESC;

SELECT * FROM cliente_rentas_temporal;

--Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las
películas que han sido alquiladas al menos 10 veces.
CREATE TEMP TABLE peliculas_alquiladas AS
SELECT 
    f.film_id,
    f.title,
    COUNT(r.rental_id) AS total_alquileres
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
GROUP BY 
    f.film_id, f.title
HAVING 
    COUNT(r.rental_id) >= 10
ORDER BY 
    total_alquileres DESC;

--Encuentra el título de las películas que han sido alquiladas por el cliente
con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena
los resultados alfabéticamente por título de película.

SELECT 
    f.title
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
JOIN 
    customer c ON r.customer_id = c.customer_id
WHERE 
    c.first_name = 'TAMMY'
    AND c.last_name = 'SANDERS'
    AND r.return_date IS NULL
ORDER BY 
    f.title ASC;

--Encuentra los nombres de los actores que han actuado en al menos una
película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados
alfabéticamente por apellido.
SELECT DISTINCT 
    a.first_name,
    a.last_name
FROM 
    actor a
JOIN 
    film_actor fa ON a.actor_id = fa.actor_id
JOIN 
    film_category fc ON fa.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
WHERE 
    c.name = 'Sci-Fi'
ORDER BY 
    a.last_name ASC, a.first_name ASC;

--Encuentra el nombre y apellido de los actores que han actuado en
películas que se alquilaron después de que la película ‘Spartacus
Cheaper’ se alquilara por primera vez. Ordena los resultados
alfabéticamente por apellido.
--
SELECT DISTINCT 
    a.first_name,
    a.last_name
FROM 
    actor a
JOIN 
    film_actor fa ON a.actor_id = fa.actor_id
JOIN 
    film f ON fa.film_id = f.film_id
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
WHERE 
    r.rental_date > (
        SELECT MIN(r2.rental_date)
        FROM rental r2
        JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
        JOIN film f2 ON i2.film_id = f2.film_id
        WHERE f2.title = 'SPARTACUS CHEAPER'
    )
ORDER BY 
    a.last_name ASC, a.first_name ASC;

--. Encuentra el nombre y apellido de los actores que no han actuado en
ninguna película de la categoría ‘Music’.

SELECT 
    a.first_name,
    a.last_name
FROM 
    actor a
WHERE 
    a.actor_id NOT IN (
        SELECT DISTINCT fa.actor_id
        FROM film_actor fa
        JOIN film_category fc ON fa.film_id = fc.film_id
        JOIN category c ON fc.category_id = c.category_id
        WHERE c.name = 'Music'
    )
ORDER BY 
    a.last_name ASC, a.first_name ASC;

--Encuentra el título de todas las películas que fueron alquiladas por más
de 8 días
SELECT DISTINCT 
    f.title
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
WHERE 
    r.return_date IS NOT NULL
    AND (r.return_date - r.rental_date) > INTERVAL '8 days'
ORDER BY 
    f.title ASC;

--Encuentra el título de todas las películas que son de la misma categoría
que ‘Animation’.
SELECT 
    f.title
FROM 
    film f
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
WHERE 
    c.name = 'Animation'
ORDER BY 
    f.title ASC;

--Encuentra los nombres de las películas que tienen la misma duración
que la película con el título ‘Dancing Fever’. Ordena los resultados
alfabéticamente por título de película.

SELECT title
FROM film
WHERE length = (
    SELECT length
    FROM film
    WHERE title = 'DANCING FEVER'
)
ORDER BY title;

--Encuentra los nombres de los clientes que han alquilado al menos 7
películas distintas. Ordena los resultados alfabéticamente por apellido.

SELECT c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT f.film_id) >= 7
ORDER BY c.last_name ASC, c.first_name ASC;

--Encuentra la cantidad total de películas alquiladas por categoría y
muestra el nombre de la categoría junto con el recuento de alquileres
SELECT c.name AS categoria,
       COUNT(r.rental_id) AS total_alquileres
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY total_alquileres DESC;

--. Encuentra el número de películas por categoría estrenadas en 2006
SELECT c.name AS categoria,
       COUNT(f.film_id) AS numero_peliculas
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE f.release_year = 2006
GROUP BY c.name
ORDER BY numero_peliculas DESC;

--Obtén todas las combinaciones posibles de trabajadores con las tiendas
que tenemos.
--
SELECT s.staff_id,
       s.first_name,
       s.last_name,
       st.store_id
FROM staff s
CROSS JOIN store st
ORDER BY s.last_name, s.first_name, st.store_id;

--Encuentra la cantidad total de películas alquiladas por cada cliente y
muestra el ID del cliente, su nombre y apellido junto con la cantidad de
películas alquiladas.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_alquileres
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquileres DESC, c.last_name ASC, c.first_name ASC;




































		









