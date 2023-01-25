/*
## Homework

1. Obtener un listado del nombre y apellido de cada cliente que haya adquirido algun producto junto
    al id del producto y su respectivo precio.
2. Obtener un listado de clientes con la cantidad de productos adquiridos, incluyendo aquellos que 
    nunca compraron algún producto.
3. Obtener un listado de cual fue el volumen de compra (cantidad) por año de cada cliente. 
4. Obtener un listado del nombre y apellido de cada cliente que haya adquirido algun producto junto 
    al id del producto, la cantidad de productos adquiridos y el precio promedio.
5. Cacular la cantidad de productos vendidos y la suma total de ventas para cada localidad, 
    presentar el análisis en un listado con el nombre de cada localidad.
6. Cacular la cantidad de productos vendidos y la suma total de ventas para cada provincia, presentar 
    el análisis en un listado con el nombre de cada provincia, pero solo en aquellas donde la suma 
    total de las ventas fue superior a $100.000.
7. Obtener un listado de dos campos en donde por un lado se obtenga la cantidad de productos vendidos 
    por rango etario y las ventas totales en base a esta misma dimensión. El resultado debe obtenerse 
    en un solo listado.
8. Obtener la cantidad de clientes por provincia.

*/
use henry_m3_noe_clase_03;
/*
*************************************************************************************************************
1. Obtener un listado del nombre y apellido de cada cliente que haya adquirido algun producto junto
    al id del producto y su respectivo precio.
*************************************************************************************************************
*/
select distinct c.IdCliente, c.Nombre_y_Apellido, v.IdProducto, v.Precio
from cliente as c
inner join venta as v on c.IdCliente=v.IdCliente
order by IdCliente
limit 100000;


/*
*************************************************************************************************************
2. Obtener un listado de clientes con la cantidad de productos adquiridos, incluyendo aquellos que
	nunca compraron algún producto. 
*************************************************************************************************************
*/

select c.IdCliente, c.Nombre_y_Apellido, sum(v.Cantidad) as cantidad_tot, sum(ifnull(v.Cantidad, 0)) as cant_con_nulos
from cliente as c
left join venta as v on c.IdCliente=v.IdCliente
group by v.IdCliente
order by c.IdCliente
limit 100000;
-- La cliente con IdCliente=22 no realizo compras

/*
*************************************************************************************************************
3. Obtener un listado de cual fue el volumen de compra (cantidad) por año de cada cliente. 
*************************************************************************************************************
*/

-- Esta query cuenta la cantidad de entradas en la tabla ventas por cada cliente
-- agrupados por año
select c.IdCliente, c.Nombre_y_Apellido, YEAR(v.fecha) as anio,  count(v.IdVenta) as cantidad_tot
from cliente c
left join venta v on c.IdCliente=v.IdCliente
group by c.IdCliente, anio
order by c.IdCliente, anio
limit 100000;

-- Esta query muestra la cantidad de productos comprados por cada cliente
-- agrupados por año
select c.IdCliente, c.Nombre_y_Apellido, YEAR(v.fecha) as anio,  sum(ifnull(v.Cantidad, 0)) as cantidad_tot
from cliente c
left join venta v on c.IdCliente=v.IdCliente
group by c.IdCliente, anio
order by c.IdCliente, anio
limit 100000;

/*
*************************************************************************************************************
4. Obtener un listado del nombre y apellido de cada cliente que haya adquirido algun producto junto 
    al id del producto, la cantidad de productos adquiridos y el precio promedio.
*************************************************************************************************************
*/

select c.Nombre_y_Apellido, v.IdProducto, sum(v.Cantidad) as cant_total, round(avg(v.Precio),2)as precio_promedio
from cliente c
inner join venta v on c.IdCliente=v.IdCliente
where c.Nombre_y_Apellido!=""  -- estoy descartando los que no tienen nombre (porque se me ocurrio)
group by c.IdCliente, v.IdProducto
order by c.Nombre_y_Apellido, precio_promedio, cant_total;

/*
*************************************************************************************************************
5. Cacular la cantidad de productos vendidos y la suma total de ventas para cada localidad, 
    presentar el análisis en un listado con el nombre de cada localidad.
*************************************************************************************************************
*/

select loc.Localidad, sum(v.Cantidad) as cant_prod, sum(v.Cantidad*v.Precio) as venta_total
from localidad as loc
inner join cliente c on loc.IdLocalidad=c.IdLocalidad
inner join venta as v on v.IdCliente=c.IdCliente
group by loc.IdLocalidad
order by loc.Localidad;
-- Pregunta --> Porque utilizar la tabla cliente y no la de Sucursal?? da muy distinto


/*
*************************************************************************************************************
6. Cacular la cantidad de productos vendidos y la suma total de ventas para cada provincia, presentar 
    el análisis en un listado con el nombre de cada provincia, pero solo en aquellas donde la suma 
    total de las ventas fue superior a $100.000.
*************************************************************************************************************
*/

select prov.Provincia, sum(v.Cantidad) as cantidad, sum(v.Cantidad * v.Precio) as ventas_totales
from venta as v
inner join cliente as c on (v.IdCliente=c.IdCliente)
inner join localidad loc on (c.IdLocalidad=loc.IdLocalidad)
inner join provincia prov on (loc.IdProvincia=prov.IdProvincia)
group by prov.Provincia
having ventas_totales>100000
order by ventas_totales desc;

-- Otra manera (da lo mismo, aunque no necesariamente deberia dar lo mismo)
SELECT p.Provincia,
		SUM(v.Cantidad) AS cantidad_productos,
        SUM(v.Precio * v.Cantidad) as total_ventas,
        count(v.IdVenta) as volumen_venta
FROM venta v
LEFT JOIN cliente c using(IdCliente)
LEFT JOIN localidad l ON(l.IdLocalidad = c.IdLocalidad)
LEFT JOIN provincia p using(IdProvincia)
GROUP BY p.Provincia
HAVING total_ventas > 100000
ORDER BY total_ventas desc;


/*
*************************************************************************************************************
7. Obtener un listado de dos campos en donde por un lado se obtenga la cantidad de productos vendidos 
    por rango etario y las ventas totales en base a esta misma dimensión. El resultado debe obtenerse 
    en un solo listado.
*************************************************************************************************************
*/

select c.rango_edad as rango_etario, sum(v.Cantidad) as cantidad, sum(v.Cantidad*v.Precio) as ventas_totales
from venta v
inner join cliente c on v.IdCliente=c.IdCliente
group by c.rango_edad
order by c.rango_edad, ventas_totales, cantidad;


/*
*************************************************************************************************************
8. Obtener la cantidad de clientes por provincia.
*************************************************************************************************************
*/

select p.IdProvincia, p.Provincia, count(distinct v.IdCliente) as cantidad_clientes
from provincia p
left join localidad loc on (p.IdProvincia=loc.IdProvincia)
left join cliente c on (c.IdLocalidad=loc.IdLocalidad)
left join venta v on (v.IdCliente=c.IdCliente)
group by p.IdProvincia
order by p.Provincia;
/*
IdProvincia     Provincia       Cantidad
-----------------------------------------
1				Buenos Aires	1786
2				CABA			0
3				Córdoba			194
4				Entre Ríos		5
5				Mendoza			273
6				Neuquén			37
7				provincia_desc	451
8				Río Negro		0
9				Santa Fe		133
10				Tucumán			90

*/


-- Esto retorna la cantidad de clientes (aunque quizas no hayan realizado compras)
SELECT p.IdProvincia, p.Provincia, count(c.IdCliente) as cantidad_clientes
FROM provincia p
LEFT JOIN localidad l ON(l.IdProvincia = p.IdProvincia)
LEFT JOIN cliente c ON(c.IdLocalidad = l.IdLocalidad)
GROUP BY p.IdProvincia, p.Provincia
ORDER BY p.IdProvincia;
/*
IdProvincia     Provincia       Cantidad
-----------------------------------------
1				Buenos Aires	1882
2				CABA			0
3				Córdoba			342
4				Entre Ríos		5
5				Mendoza			290
6				Neuquén			37
7				provincia_desc	490
8				Río Negro		0
9				Santa Fe		211
10				Tucumán			150
*/