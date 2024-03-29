---TAREA 5: AUTOMATIZACION DE LAS RENTAL STORES
---TAREA 5: AUTOMATIZACION DE LAS RENTAL STORES
---TAREA 5: AUTOMATIZACION DE LAS RENTAL STORES
---TAREA 5: AUTOMATIZACION DE LAS RENTAL STORES

---HINTS:
----1)Cada cajita de Blu-Ray mide 20cm x 13.5cm x 1.5cm, y para que el brazo pueda manipular adecuadamente cada cajita, 
------debe estar contenida dentro de un arn�s que cambia las medidas a 30cm x 21cm x 8cm para un espacio total de 5040 cent�metros c�bicos
------y un peso de 500 gr por pel�cula.
----2)Las medidas deben ser est�ndar, es decir, la misma para todas nuestras stores, y en cada store pueden ser instalados m�s de 1 de estos cilindros. 
------Cada cilindro aguanta un peso m�ximo de 50kg como m�ximo.
----3)Cada pelicula tiene un peso de 500g.
----4)Cada cilindro es capaz de contener 100 peliculas. Esto debido a que: 50kg/0.5kg=100.


---Cantidad de peliculas por store
with t as(
	select store_id, count(*) as tot_peliculas 
	from inventory i 
	group by store_id 
	)
	select * from t;
----Sabemos ahora que 
----Store1: 2,270 peliculas  
----Store2: 2,311 peliculas


---Volumen total de las peliculas
with h as(
	select store_id, (count(*)*5040) as tot_volumen 
	from inventory i 
	group by store_id 
	)
	select * from h;
----Sabemos ahora que en terminos de volumen:
----Store1: 11440800 cm^3
----Store2: 11647440 cm^3


---Peso total de las peliculas
with k as(
	select store_id, (count(*)*0.5) as tot_volumen 
	from inventory i 
	group by store_id 
	)
	select * from k;
----Sabemos ahora que en terminos de peso:
----Store1: 1,135 kg
----Store2: 1,155 kg

---Cilindros totales necesarios
with p as(
	select store_id, (count(*)*0.5/50) as tot_volumen 
	from inventory i 
	group by store_id 
	)
	select * from p;
----Sabemos ahora que en terminos de cilindros cada store necesita:
----Store1: 23 cilindros
----Store2: 24 cilindros

----Ya sabiendo cuantos cilindros requiere cada store
----Optimicemos el espacio
----Si cada cilindro contiene 1 solo piso donde se alacenen los 100 bluerays, como en las rocolas o radios antiguas que almacenaban discos
----habra mucho desperdicio de espacio.
----Dicho esto, podemos hacer un cilindro que contenga las 100 peliculas, inspirado en esta division de las rocolas y radios anyiguas
----pero con varios niveles.
----Tomando en cuenta que la altura promedio en Mexico es de 1.64 m, esto mencionado como el factor humano de la optimizacion ademas de la robotizacion del proceso,
----y que cada BlueRay esta contenido en un arnes de 21 cm de alto
----podemos hacer proponer un cilindro de 5 niveles, cada nivel con peliculas. Dando pues una altura aproximada de 110 cm, tomando en cuenta la separacion
----entre niveles.

---Tomando en cuenta esto: que el radio internom mide 30.08 cm, el radio externo 61.08 cm y la atura 110cm hacemos el calculo:
select (pi()*power(61.08,2))*110 as volumen; 

---Volumen de un cilindro: 1289260.3145 cm^3

--POR LO TANTO, siguiendo esta propuesta se utilizarian:
--Store1 (en mts^3): 
select (((pi()*power(61.08,2))*110)*23)/1000000 as volumen_tot_Store1;
--Store2 (en mts^3): 
select (((pi()*power(61.08,2))*110)*24)/1000000 as volumen_tot_Store2;