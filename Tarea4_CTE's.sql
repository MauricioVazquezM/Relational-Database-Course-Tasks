----TAREA 4:
----TAREA 4:
----TAREA 4:
----TAREA 4:

--Una aplicaci�n frecuente de Ciencia de Datos aplicada a la industria del microlending es el de calificaciones crediticias (credit scoring). 
--Puede interpretarse de muchas formas: propensi�n a pago, probabilidad de default, etc. 
--La intuici�n nos dice que las variables m�s importantes son el saldo o monto del cr�dito, y la puntualidad del pago; 
--sin embargo, otra variable que frecuentemente escapa a los analistas es el tiempo entre cada pago. 
--La puntualidad es una p�sima variable para anticipar default o inferir capacidad de pago de micropr�stamos, por su misma naturaleza. 
--Si deseamos examinar la viabilidad de un producto de cr�dito para nuestras videorental stores:

--Cu�l es el promedio, en formato human-readable, de tiempo entre cada pago por cliente de la BD Sakila?
--Sigue una distribuci�n normal?
--Qu� tanto difiere ese promedio del tiempo entre rentas por cliente?

---FUNCION HISTOGRAMA
CREATE OR REPLACE FUNCTION histogram(table_name_or_subquery text, column_name text)
RETURNS TABLE(bucket int, "range" numrange, freq bigint, bar text)
AS $func$
BEGIN
RETURN QUERY EXECUTE format('
  WITH
  source AS (
    SELECT * FROM %s
  ),
  min_max AS (
    SELECT min(%s) AS min, max(%s) AS max FROM source
  ),
  histogram AS (
    SELECT
      width_bucket(%s, min_max.min, min_max.max, 20) AS bucket,
      numrange(min(%s)::numeric, max(%s)::numeric, ''[]'') AS "range",
      count(%s) AS freq
    FROM source, min_max
    WHERE %s IS NOT NULL
    GROUP BY bucket
    ORDER BY bucket
  )
  SELECT
    bucket,
    "range",
    freq::bigint,
    repeat(''*'', (freq::float / (max(freq) over() + 1) * 15)::int) AS bar
  FROM histogram',
  table_name_or_subquery,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name
  );
END
$func$ LANGUAGE plpgsql;


---PREGUNTA 1:Cu�l es el promedio, en formato human-readable, de tiempo entre cada pago por cliente de la BD Sakila?
with t as(
	select p.customer_id , p.payment_date , (p.payment_date - LAG(p.payment_date,1) OVER (partition by p.customer_id ORDER BY p.payment_date asc)) AS dias_ultimo_pago
	FROM payment p 
	) 
	select t.customer_id, cast(avg(t.dias_ultimo_pago) as interval) as tiempo_promedio_entre_pago 
	from t join customer c using (customer_id)
	group by t.customer_id
	order by t.customer_id asc;


---PREGUNTA 2:Sigue una distribuci�n normal?
CREATE VIEW pagos_intervalos_promedio
AS (
	with t as(
		select p.customer_id, p.payment_date , (p.payment_date - LAG(p.payment_date,1) OVER (partition by p.customer_id ORDER BY p.payment_date asc)) AS dias_ultimo_pago
		FROM payment p 
	) 
	select t.customer_id, extract(epoch from (avg(t.dias_ultimo_pago))) as tiempo_promedio_entre_pago 
	from t join customer c using (customer_id)
	group by t.customer_id
	order by t.customer_id asc
);

select * from pagos_intervalos_promedio;---SALE EN NUMERICO DEBIDO A QUE, DE no SER ASI, EL HISTOGRAMA MARCABA ERROR
select * from histogram('pagos_intervalos_promedio', 'tiempo_promedio_entre_pago'); 
---No es normal, ya que los datos no son Log normales


---PREGUNTA 3: Qu� tanto difiere ese promedio del tiempo entre rentas por cliente?
with o as(
	select r.customer_id, r.rental_date, (r.rental_date - LAG(r.rental_date ,1) OVER (partition by r.customer_id ORDER BY r.rental_date asc)) AS dias_de_ultima_renta
	FROM rental r 
	) 
	select o.customer_id, cast(avg(o.dias_de_ultima_renta) as interval) as tiempo_promedio_entre_renta 
	from o join customer c using (customer_id)
	group by o.customer_id
	order by o.customer_id asc;

CREATE VIEW rentas_intervalos_promedio
AS (
	with o as(
		select r.customer_id, r.rental_date, (r.rental_date - LAG(r.rental_date ,1) OVER (partition by r.customer_id ORDER BY r.rental_date asc)) AS dias_de_ultima_renta
		FROM rental r 
	) 
	select o.customer_id, cast(avg(o.dias_de_ultima_renta) as interval) as tiempo_promedio_entre_renta 
	from o join customer c using (customer_id)
	group by o.customer_id
	order by o.customer_id asc
);

select * from rentas_intervalos_promedio;

---CONCLUSION: 
---La diferencia entre el tiempo entre rentas por cliente y el tiempo entre cada pago por cliente
---es 0. Por lo que, podemos concluir que en el dia de renta se hace el pago.



