---- TAREA 1 - BASES DE DATOS 


---PREGUNTA 1: Qu� contactos de proveedores tienen la posici�n de sales representative?
select * from suppliers s;

select s.contact_name  
from suppliers s 
where contact_title = 'Sales Representative'
order by contact_name asc;

---PREGUNTA 2: Qu� contactos de proveedores no son marketing managers?
select * from suppliers s ;

select s.contact_name  
from suppliers s 
where contact_title != 'Marketing Manager'
order by contact_name asc;

---PREGUNTA 3: Cuales �rdenes no vienen de clientes en Estados Unidos?
select * from orders o;
select * from customers c; 

select o.order_id 
from orders o join customers c on (o.customer_id=c.customer_id)
where c.country !='USA';

---PREGUNTA 4: Qu� productos de los que transportamos son quesos?
select * from products p;
select * from categories c;
select * from order_details od;
select * from orders o; 

select p.product_name 
from categories c join products p on (c.category_id = p.category_id) 
join order_details od on (od.product_id = p.product_id) 
join orders o2 on (o2.order_id = od.order_id) 
where shipped_date is not null and c.description='Cheeses'
group by p.product_name
order by p.product_name asc;

---PREGUNTA 5: Qu� ordenes van a B�lgica o Francia?
select * from orders o;

select o.order_id 
from orders o 
where shipped_date is not null and (ship_country = 'France' or ship_country = 'Belgium');

---PREGUNTA 6: Qu� �rdenes van a LATAM?
select * from orders o; 

select o.order_id 
from orders o 
where shipped_date is not  null and  ship_country in ('Brazil', 'Mexico', 'Venezuela', 'Argentina');
--2nda forma
select o.order_id 
from orders o 
where shipped_date is not null and (ship_country = 'Brazil' or ship_country = 'Argentina' or ship_country = 'Venezuela' or ship_country = 'Mexico');

---PREGUNTA 7: Qu� �rdenes no van a LATAM?
select * from orders o; 

select o.order_id 
from orders o 
where shipped_date is not  null and  ship_country not in ('Brazil', 'Mexico', 'Venezuela', 'Argentina');
--2nda forma
select o.order_id 
from orders o 
where shipped_date is not null and (ship_country != 'Brazil' and ship_country != 'Argentina' and ship_country != 'Venezuela' and ship_country != 'Mexico');

---PREGUNTA 8: Necesitamos los nombres completos de los empleados, nombres y apellidos unidos en un mismo registro
select  * from employees e; 

select concat(e.first_name, ' ',e.last_name) 
from employees e; 

---PREGUNTA 9: Cu�nta lana tenemos en inventario?
select * from products p;

select sum(p.unit_price*p.units_in_stock) 
from products p; 

---PREGUNTA 10: Cuantos clientes tenemos de cada pa�s?
select * from customers c;

select c.country ,count(*)
from customers c 
group by country;

---PREGUNTA 11: Obtener un reporte de edades de los empleados para checar su elegibilidad para seguro de gastos m�dicos menores.
select * from employees e;

select concat (e.first_name,' ', e.last_name) as nombre, (current_date- e.birth_date)/365 as edad
from employees e 
order by edad asc;

---PREGUNTA 12: Cu�l es la orden m�s reciente por cliente?
select * from customers c;
select * from orders o; 

select o.customer_id , max(o.order_id) as orden_mas_reciente
from orders o 
group by o.customer_id; 

---PREGUNTA 13: De nuestros clientes, qu� funci�n desempe�an y cu�ntos son?
select * from customers c;

select c.contact_title , count (*) as cantidad
from customers c 
group by c.contact_title
order by contact_title asc;

---PREGUNTA 14: Cu�ntos productos tenemos de cada categor�a?
select * from products p;

select c.category_name , count(p.product_id) as cantidad
from products p join categories c on (p.category_id=c.category_id)
group by c.category_name
order by c.category_name asc;

---PREGUNTA 15: C�mo podemos generar el reporte de reorder?
select * from products p;

select p.product_name, reorder_level, p.quantity_per_unit, p.unit_price*p.units_in_stock as costo 
from products p, suppliers s
where reorder_level<=10
group by p.product_id 
order by product_name asc;

---PREGUNTA 16: A donde va nuestro env�o m�s voluminoso?
select * from orders o;

select o.order_id, o.freight, o.ship_country 
from orders o  
order by o.freight desc limit 1;

---PREGUNTA 17: C�mo creamos una columna en customers que nos diga si un cliente es bueno, regular, o malo?
select * from customers c;
select * from order_details od;
select * from orders o;

explain analyze select o.customer_id , sum((od.unit_price-od.unit_price*od.discount)*od.quantity ) as ventas,
case 
	when sum((od.unit_price-od.unit_price*od.discount)*od.quantity )>75000 then 'Bueno'
	when sum((od.unit_price-od.unit_price*od.discount)*od.quantity )<10000 then 'Malo'
	else 'Regular'
end as ranking
from order_details od join orders o on (od.order_id=o.order_id) join customers c on (o.customer_id=c.customer_id)
group by o.customer_id
order by ventas desc;

---PREGUNTA 18: Qu� colaboradores chambearon durante las fiestas de navidad?
select * from employees e;

select e.first_name, e.last_name  , o.order_date 
from employees e join orders o using (employee_id)
where cast(o.order_date as text) like '%12-25'
order by last_name desc;

---PREGUNTA 19: Qu� productos mandamos en navidad?
select * from orders o;
select * from order_details od; 

select od.product_id,p.product_name, o.shipped_date  
from orders o join order_details od on (o.order_id=od.order_id) join products p on (p.product_id=od.product_id)
where cast(o.shipped_date  as text) like '%12-25'
order by od.product_id asc;

---PREGUNTA 20: Qu� pa�s recibe el mayor volumen de producto?
select * from orders o;

select o.ship_country, sum(o.freight) as volumen
from orders o 
group by o.ship_country
order by sum(o.freight) desc limit 1;

