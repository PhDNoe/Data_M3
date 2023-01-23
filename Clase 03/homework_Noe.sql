-- Codigo de Noe 👻

use henry_m3_noe_clase_03;
SET SQL_SAFE_UPDATES=0;

/*
## Homework

1) Aplicar alguna técnica de detección de Outliers en la tabla ventas, sobre los campos Precio y Cantidad.
Realizar diversas consultas para verificar la importancia de haber detectado Outliers. 
Por ejemplo ventas por sucursal en un período teniendo en cuenta outliers y descartándolos.
2) Es necesario armar un proceso, mediante el cual podamos integrar todas las fuentes, aplicar las transformaciones 
o reglas de negocio necesarias a los datos y generar el modelo final que va a ser consumido desde los reportes. 
Este proceso debe ser claro y autodocumentado.
¿Se puede armar un esquema, donde sea posible detectar con mayor facilidad futuros errores en los datos?
3) Elaborar 3 KPIs del negocio. Tener en cuenta que deben ser métricas fácilmente graficables, por lo tanto debemos asegurarnos de contar con los datos adecuados.
¿Necesito tener el claro las métricas que voy a utilizar? 
¿La métrica necesaria debe tener algún filtro en especial? 
La Meta que se definió ¿se calcula con la misma métrica?

*/

-- Creamos 3 variables para almacenar la cantidad de registros de la columna cantidad en venta
-- La posicion del 1er cuartil (Q1) y la del tercer cuartil (Q3)
SET @n_registros_cantidad := (SELECT COUNT(Cantidad) FROM venta);
SET @Q1_position_cantidad := ceil(0.25 * @n_registros_cantidad);
SET @Q3_position_cantidad := ceil(0.75 * @n_registros_cantidad);

SET @n_registros_precio := (SELECT COUNT(Precio) FROM venta);
SET @Q1_position_precio := ceil(0.25 * @n_registros_precio);
SET @Q3_position_precio := ceil(0.75 * @n_registros_precio);
-- Mostramos el contenido de las variables
SELECT @n_registros_cantidad, @Q1_position_cantidad, @Q3_position_cantidad,
 @n_registros_precio, @Q1_position_precio, @Q3_position_precio;


-- Creamos una nueva tabla (temporal) donde solo me quedo con el Precio y agrego un Id nuevo
CREATE TEMPORARY TABLE venta_precio (
	IdVentaTemp int not null auto_increment primary key,
    Precio decimal(15,2)   
);

INSERT INTO venta_precio (Precio) 
SELECT Precio
FROM venta ORDER BY Precio ASC;


-- Creamos una nueva tabla (temporal) donde solo me quedo con la Cantidad y agrego un Id nuevo
CREATE TEMPORARY TABLE venta_cantidad(
	IdVentaTemp int not null auto_increment primary key,
    Cantidad int 
);

INSERT INTO venta_cantidad (Cantidad) 
SELECT Cantidad
FROM venta ORDER BY Cantidad ASC;

-- ----------------------   Outliers de Precio  ---------------------------

-- Vamos a visualizar todos los registros de la tabla temporal de precio
select * from venta_precio;


-- vamos a visualizar los registros en la tabla temporal, en la posicion Q1
select * from venta_precio where IdVentaTemp=@q1_position_precio;

-- vamos a visualizar los registros en la tabla temporal, en la posicion Q3
select * from venta_precio where IdVentaTemp=@q3_position_precio;

-- Buscamos el valor de Q1
set @Q1_precio = (select Precio from venta_precio where IdVentaTemp=@q1_position_precio);

-- Buscamos el valor de Q3
set @Q3_precio = (select Precio from venta_precio where IdVentaTemp=@q3_position_precio);
    
-- Seteamos el rango intercuartil
set @IQR_precio = @Q3_precio - @Q1_precio;

-- cota  superior
set @cota_sup_precio = @Q3_precio + 1.5 * @IQR_precio;

-- cota inferior
set @cota_inf_precio = 
(SELECT IF ((@Q1_precio - 1.5 * @IQR_precio)>0, @Q1_precio - 1.5 * @IQR_precio, 0)); -- si es menor que 0, retorna 0

-- Mostramos las variables
select @IQR_precio, @Q1_precio, @Q3_precio, @cota_inf_precio, @cota_sup_precio;

-- mostramos los outliers
select IdVenta, Precio from venta
where Precio<@cota_inf_precio or Precio>@cota_sup_precio;


-- ----------------------   Outliers de Cantidad  ---------------------------
select Cantidad, count(Cantidad)
from venta
group by Cantidad
order by count(Cantidad);
-- Vamos a visualizar todos los registros de la tabla temporal de cantidad
select * from venta_cantidad;


-- vamos a visualizar los registros en la tabla temporal, en la posicion Q1
select * from venta_cantidad where IdVentaTemp=@q1_position_cantidad;

-- vamos a visualizar los registros en la tabla temporal, en la posicion Q3
select * from venta_cantidad where IdVentaTemp=@q3_position_cantidad;

-- Buscamos el valor de Q1
set @Q1_cantidad = (select Cantidad from venta_cantidad where IdVentaTemp=@q1_position_cantidad);

-- Buscamos el valor de Q3
set @Q3_cantidad = (select Cantidad from venta_cantidad where IdVentaTemp=@q3_position_cantidad);
    
-- Seteamos el rango intercuartil
set @IQR_cantidad = @Q3_cantidad - @Q1_cantidad;

-- cota  superior
set @cota_sup_cantidad = @Q3_cantidad + 1.5 * @IQR_cantidad;

-- cota inferior
set @cota_inf_cantidad = 
(SELECT IF ((@Q1_cantidad - 1.5 * @IQR_cantidad)>0, @Q1_cantidad - 1.5 * @IQR_cantidad, 0)); -- si es menor que 0, retorna 0

-- Mostramos las variables
select @IQR_cantidad, @Q1_cantidad, @Q3_cantidad, @cota_inf_cantidad, @cota_sup_cantidad;

-- mostramos los outliers
select IdVenta, Cantidad from venta
where Cantidad<@cota_inf_cantidad or Cantidad>@cota_sup_cantidad;


-- *******************************************************************************************************************
-- Ventas totales por sucursal con outliers
select IdSucursal, sum(Precio*Cantidad) as ventas_totales
from venta
group by IdSucursal
order by ventas_totales desc;
/*
Esta query retorna (top 3)
---------------------------
IdSucursal | ventas_totales
---------------------------
31	       |  78757788.73
10	       |  69586881.41
7	       |  62587160.11
---------------------------
*/

-- Vamos a quitar los outliers de Precio
select IdSucursal, sum(Precio*Cantidad) as ventas_totales
from venta
where Precio>=@cota_inf_precio and Precio<=@cota_sup_precio
group by IdSucursal
order by ventas_totales desc;
/*
Esta query retorna (top 3)
---------------------------
IdSucursal | ventas_totales
---------------------------
7	       |   8282720.53
24	       |   5498845.21
1	       |   5389008.90
*/


-- Vamos a quitar los outliers de Cantidad
select IdSucursal, sum(Precio*Cantidad) as ventas_totales
from venta
where Cantidad>=@cota_inf_cantidad and Cantidad<=@cota_sup_cantidad
group by IdSucursal
order by ventas_totales desc;
/*
Esta query retorna (top 3)
---------------------------
IdSucursal | ventas_totales
---------------------------
31	       |  78407593.33
10	       |  62283598.41
7	       |  60481345.11
*/


-- Vamos a quitar los outliers de Precio y Cantidad
select IdSucursal, sum(Precio*Cantidad) as ventas_totales
from venta
where Precio>=@cota_inf_precio and Precio<=@cota_sup_precio 
and Cantidad>=@cota_inf_cantidad and Cantidad<=@cota_sup_cantidad
group by IdSucursal
order by ventas_totales desc;
/*
Esta query retorna (top 3)
---------------------------
IdSucursal | ventas_totales
---------------------------
7	       |   6638864.13
25	       |   4658445.32
24	       |   4509743.01
*/



-- ************************************************************************************************
-- 2° Forma, como lo resuelve el profesor --> con media y 3 std
-- Nota: Este metodo no me parece adecuado dado que no sabemos si los datos son normales
-- como para poder utilizar media y std....pero bue...

-- Precio
set @mu_precio = (select avg(Precio) from venta);
set @std_precio = (select stddev(Precio) from venta);
set @sigma3_precio_sup = @mu_precio + 3 * @std_precio;
set @sigma3_precio_inf = @mu_precio - 3 * @std_precio;

select  @mu_precio, @std_precio, @sigma3_precio_sup, @sigma3_precio_inf;

-- Cantidad
set @mu_cantidad = (select avg(Cantidad) from venta);
set @std_cantidad = (select stddev(Cantidad) from venta);
set @sigma3_cantidad_sup = @mu_cantidad + 3 * @std_cantidad;
set @sigma3_cantidad_inf = @mu_cantidad- 3 * @std_cantidad;

select  @mu_cantidad, @std_cantidad, @sigma3_cantidad_sup, @sigma3_cantidad_inf;



-- Vamos a quitar los outliers de Precio
select IdSucursal, sum(Precio*Cantidad) as ventas_totales
from venta
where Precio>=@sigma3_precio_inf and Precio<=@sigma3_precio_sup
group by IdSucursal
order by ventas_totales desc;
/*
Esta query retorna (top 3)
---------------------------
IdSucursal | ventas_totales
---------------------------
7	       |   25981448.11
4	       |   18797765.11
10	       |   18388481.41
*/


-- Vamos a quitar los outliers de Cantidad
select IdSucursal, sum(Precio*Cantidad) as ventas_totales
from venta
where Cantidad>=@sigma3_cantidad_inf and Cantidad<=@sigma3_cantidad_sup
group by IdSucursal
order by ventas_totales desc;
/*
Esta query retorna (top 3)
---------------------------
IdSucursal | ventas_totales
---------------------------
31	       |   78444326.13
10	       |   62445648.41
7	       |   60646579.71
*/


-- Vamos a quitar los outliers de Precio y Cantidad
select IdSucursal, sum(Precio*Cantidad) as ventas_totales
from venta
where Precio>=@sigma3_precio_inf and Precio<=@sigma3_precio_sup
and Cantidad>=@sigma3_cantidad_inf and Cantidad<=@sigma3_cantidad_sup
group by IdSucursal
order by ventas_totales desc;
/*
Esta query retorna (top 3)
---------------------------
IdSucursal | ventas_totales
---------------------------
7	       |   24040867.71
23	       |   17138061.22
2	       |   16276766.51
*/

/*
CLARAMENTE, LOS RESULTADOS SON DIFERENTES, SIENDO MAS EVIDENTE EN LOS OUTLIERS DE PRECIO.

PARA SABER QUE METODO ES MAS ADECUADO, SE DEBEN REALIZAR MAS TEST PARA SABER SI LOS DATOS SON NORMALES O NO
*/

-- PARA SER CONSISTENTE CON LO QUE SE HACE EN CLASE, UTILIZO EL 2DO METODO ( A MI ENTENDER ERRONEO)
-- PARA ACTUALIZAR LA TABLA DE AUDITORIA DE VENTAS
-- OUTLIERS DE CANTIDAD CODIGO 2
-- OUTLIERS DE PRECIO CODIGO 3

-- outliers de cantidad
insert into auditoria_venta
select IdVenta, fecha, fecha_entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, Cantidad, 2
from venta
where Cantidad>=@sigma3_cantidad_inf and Cantidad<=@sigma3_cantidad_sup
order by Cantidad;

-- outliers de precio
insert into auditoria_venta
select IdVenta, fecha, fecha_entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, Cantidad, 3
from venta
where Precio>=@sigma3_precio_inf and Precio<=@sigma3_precio_sup
order by Precio;


-- KPI: Margen de Ganancia por producto superior a 20%
-- @TODO

