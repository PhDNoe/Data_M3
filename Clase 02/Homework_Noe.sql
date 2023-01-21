/*
## Homework

Con el objetivo de asegurarse de que la calidad de la información con la que se va a trabajar sea la óptima, 
es necesario realizar una lista de propuestas de mejora teniendo en cuenta los siguientes puntos:

1) ¿Qué tan actualizada está la información? ¿La forma en que se actualiza ó mantiene esa información 
    se puede mejorar?
2) ¿Los datos están completos en todas las tablas?
3) ¿Se conocen las fuentes de los datos?
4) Al integrar éstos datos, es prudente que haya una normalización respecto de nombrar las tablas y sus campos.
5) Es importante revisar la consistencia de los datos: ¿Se pueden relacionar todas las tablas al modelo? 
    ¿Cuáles son las tablas de hechos y las tablas dimensionales o maestros? 
    ¿Podemos hacer esa separación en los datos que tenemos (tablas de hecho y dimensiones)? 
    ¿Hay claves duplicadas? ¿Cuáles son variables cualitativas y cuáles son cuantitativas? 
    ¿Qué acciones podemos aplicar sobre las mismas?

### Limpieza, Valores faltantes y Normalización

6) Normalizar los nombres de los campos y colocar el tipo de dato adecuado para cada uno en cada una de 
    las tablas. Descartar columnas que consideres que no tienen relevancia.
7) Buscar valores faltantes y campos inconsistentes en las tablas sucursal, proveedor, empleado y cliente. 
    De encontrarlos, deberás corregirlos o desestimarlos. Propone y realiza una acción correctiva 
    sobre ese problema.
8) Chequear la consistencia de los campos precio y cantidad de la tabla de ventas.
9) Utilizar la funcion provista 'UC_Words' para modificar a letra capital los campos que contengan 
    descripciones para todas las tablas.
10) Chequear que no haya claves duplicadas, y de encontrarla en alguna de las tablas, proponer una solución.
11) Generar dos nuevas tablas a partir de la tabla 'empelado' que contengan las entidades Cargo y Sector.
12) Generar una nueva tabla a partir de la tabla 'producto' que contenga la entidad Tipo de Producto.
13) Es necesario contar con una tabla de localidades del país con el fin de evaluar la apertura de una nueva 
    sucursal y mejorar nuestros datos. 
    A partir de los datos en las tablas cliente, sucursal y proveedor hay que generar una tabla definitiva 
    de Localidades y Provincias.
    Utilizando la nueva tabla de Localidades controlar y corregir (Normalizar) los campos Localidad y 
    Provincia de las tablas cliente, sucursal y proveedor.
14) Es necesario discretizar el campo edad en la tabla cliente.

*/


-- Codigo de Noe 👻
-- Antes que nada debemos ejecutar el script Creacion_db_Noe.sql para crear una nueva base de datos

/* ********************************************************************************************* */
--                         LIMPIEZA, VALORES FALTANTES Y NORMALIZACION
/* ********************************************************************************************* */

/*
6) Normalizar los nombres de los campos y colocar el tipo de dato adecuado para cada uno en cada una de 
    las tablas. Descartar columnas que consideres que no tienen relevancia.
7) Buscar valores faltantes y campos inconsistentes en las tablas sucursal, proveedor, empleado y cliente. 
    De encontrarlos, deberás corregirlos o desestimarlos. Propone y realiza una acción correctiva 
    sobre ese problema.
*/

use henry_m3_noe_clase_02_v2;
-- ------------------------------------------------------------------------------------------------
-- canal_venta
SELECT * from canal_venta;

ALTER TABLE canal_venta RENAME COLUMN canal to Canal;


-- ------------------------------------------------------------------------------------------------
-- cliente
-- Tiene missing data en las siguientes columnas: 
-- Provincia, Domicilio, Telefono, Localidad, X, Y
SELECT * FROM cliente;

ALTER TABLE cliente RENAME COLUMN ID to IdCliente;

-- creamos columnas auxiliares
ALTER TABLE cliente ADD Latitud DECIMAL(15,10) NOT NULL DEFAULT '0' AFTER `Y`, 
ADD Longitud DECIMAL(15,10) NOT NULL DEFAULT '0' AFTER Latitud;

UPDATE cliente SET X='0' where TRIM(X)="";
UPDATE cliente SET Y='0' where TRIM(Y)="";

UPDATE cliente SET Latitud=REPLACE(Y, ',', '.');
UPDATE cliente SET Longitud=REPLACE(X, ',', '.');

-- Dropeamos las columnas que ya no necesitamos
ALTER TABLE cliente
DROP X, DROP Y, DROP col10;


-- ------------------------------------------------------------------------------------------------
-- compra
select* from compra;
-- Nada que cambiar

-- ------------------------------------------------------------------------------------------------
-- empleado
select * from empleado;
-- No tiene missing data

ALTER TABLE empleado
RENAME COLUMN ID_empleado to IdEmpleado;

-- ------------------------------------------------------------------------------------------------
-- gasto
select *  from gasto LIMIT 10000;
-- nada que cambiar

-- ------------------------------------------------------------------------------------------------
-- producto
select * from producto ;
-- Hay missing values --> tipo
-- Precio es de tipo varchar, deberia ser DECIMAL 10,2

ALTER TABLE producto RENAME COLUMN ID_PRODUCTO to IdProducto;
ALTER TABLE producto ADD Precio2 DECIMAL(10,2) NOT NULL DEFAULT 0.0 AFTER Precio;

-- 	Error Code: 1264. Out of range value for column 'Precio2' at row 51	0.000 sec
ALTER TABLE producto 
modify Precio2 DECIMAL(15,2);  

UPDATE producto 
SET Precio2=Precio;

ALTER TABLE producto DROP Precio;

ALTER TABLE producto RENAME COLUMN Precio2 to Precio;


-- ------------------------------------------------------------------------------------------------
-- proveedor
select * from proveedor;

-- Missing data en las columnas: Nombre

ALTER TABLE proveedor
RENAME COLUMN IDProveedor to IdProveedor;

-- ------------------------------------------------------------------------------------------------
-- Sucursal

select * from sucursal;


ALTER TABLE sucursal
RENAME COLUMN ID to IdSucursal;

-- Agregamos unas columnas auxiliares
ALTER TABLE sucursal
ADD Latitud2 DECIMAL(15,10) DEFAULT 0 AFTER Longitud,
ADD Longitud2 DECIMAL(15,10) DEFAULT 0 AFTER Latitud2;

UPDATE sucursal
SET Latitud2=REPLACE(Latitud,',','.');

UPDATE sucursal
SET Longitud2=REPLACE(Longitud,',','.');

-- Dropeamos las columnas que ya no son necesarias
ALTER TABLE sucursal
DROP Latitud, DROP Longitud;

-- Renombramos las nuevas columnas
ALTER TABLE sucursal
RENAME COLUMN Latitud2 to Latitud, 
RENAME COLUMN Longitud2 to Longitud;

-- ------------------------------------------------------------------------------------------------
-- tipo_gasto
select * from tipo_gasto;
-- nada que cambiar

-- ------------------------------------------------------------------------------------------------
-- venta
select * from venta LIMIT 100000;
-- missing data en las columnas: Precio, Cantidad

-- En un primer momento vamos a setear Cantidad en cero para los datos faltantes
UPDATE venta
SET Precio="0" WHERE TRIM(Precio)="" OR Precio IS NULL;

ALTER TABLE venta 
modify Precio DECIMAL(15,2);

-- Ahora vamos a intentar cargar el precio, fijandonos en conjunto con la tabla producto
update venta v
join producto p on (v.IdProducto=p.IdProducto)
SET v.Precio=p.Precio
WHERE v.Precio=0;

-- Queda pendiente Modificar la cantidad --> Ya pensaremos en algo

/*
8) Chequear la consistencia de los campos precio y cantidad de la tabla de ventas.

*/

-- Vamos a generar una tabla de auditoria, en donde vamos a indicar los campos que tienen cantidad 0
/*
* motivo = 1 --> Cantidad = 0
*/
DROP TABLE IF EXISTS auditoria_venta;
CREATE TABLE IF NOT EXISTS auditoria_venta(
	IdVenta	INT,
	fecha DATE NOT NULL,
	fecha_entrega DATE NOT NULL,
	IdCliente INT, 
    IdSucursal INT,
    IdEmpleado INT,
    IdProducto INT,
    Precio FLOAT,
	Cantidad INT,
    Motivo INT
) ENGINE = InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;


-- Reemplazamos los caracteres especiales en la tala venta
UPDATE venta SET Cantidad = REPLACE(Cantidad, '\r', '');

-- populamos la tabla de auditoria con los valores que tienen problemas
INSERT INTO auditoria_venta (IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, Cantidad, Motivo)
SELECT IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, 0, 1
FROM venta WHERE Cantidad = '' or Cantidad is null;

-- Ahora que ya tenemos una tabla en donde constan los cambios realizados a la tabla de venta con valores faltantes
-- podemos setear la cantidad en 1 (suponiendo que al menos se realizo una venta)
UPDATE venta SET Cantidad = '1' WHERE Cantidad = '' or Cantidad is null;

-- Ahora que ya no tiene cadenas vacias o null values, podemos cambiar el dtype de la columna cantidad
ALTER TABLE venta MODIFY Cantidad INT NOT NULL DEFAULT '0';

/*
9) Utilizar la funcion provista 'UC_Words' para modificar a letra capital los campos que contengan 
    descripciones para todas las tablas.
*/

-- Cliente: Nombre_y_Apellido, Domicilio, Provincia y Localidad
UPDATE cliente
SET Nombre_y_Apellido=UC_Words(TRIM(Nombre_y_Apellido)),
Domicilio=UC_Words(TRIM(Domicilio)),
Provincia=UC_Words(TRIM(Provincia)),
Localidad=UC_Words(TRIM(Localidad));

-- empleado: Nombre, Apellido, Sucursal, Sector, Cargo
UPDATE empleado
SET Nombre=UC_Words(TRIM(Nombre)),
Apellido=UC_Words(TRIM(Apellido)),
Sucursal=UC_Words(TRIM(Sucursal)),
Sector=UC_Words(TRIM(Sector)),
Cargo=UC_Words(TRIM(Cargo));

-- producto: Concepto y Tipo
UPDATE producto
SET Concepto=UC_Words(TRIM(Concepto)),
Tipo=UC_Words(TRIM(Tipo));

-- proveedor: Nombre, Direccion, Ciudad, Provincia, Pais, Departamento
UPDATE proveedor
SET Nombre=UC_Words(TRIM(Nombre)),
Direccion=UC_Words(TRIM(Direccion)),
Ciudad=UC_Words(TRIM(Ciudad)),
Provincia=UC_Words(TRIM(Provincia)),
Pais=UC_Words(TRIM(Pais)),
Departamento=UC_Words(TRIM(Departamento));

-- Sucursal: Sucursal, Direccion, Localidad, Provincia
UPDATE sucursal
SET Sucursal=UC_Words(TRIM(Sucursal)),
Direccion=UC_Words(TRIM(Direccion)),
Localidad=UC_Words(TRIM(Localidad)),
Provincia=UC_Words(TRIM(Provincia));

/*
10) Chequear que no haya claves duplicadas, y de encontrarla en alguna de las tablas, proponer una solución.

*/
-- ------------------------------------------------------------------------------------------------
-- canal_venta
-- IdCanal no tiene IdDuplicadas
SELECT IdCanal, COUNT(IdCanal) 
FROM canal_venta
GROUP BY IdCanal
HAVING COUNT(IdCanal) > 1;

-- Seteo IdCanal como primary key
ALTER TABLE canal_venta ADD PRIMARY KEY(IdCanal);


-- ------------------------------------------------------------------------------------------------
-- cliente
-- IdCliente no tiene duplicados
select IdCliente, count(IdCliente)
from cliente
group by IdCliente
having count(IdCliente)>1;

-- Puedo setear IdCliente como primary key
alter table cliente
add primary key(IdCliente);

-- ------------------------------------------------------------------------------------------------
-- compra
-- IdCompra no tiene duplicados
select IdCompra, count(IdCompra)
from compra
group by IdCompra
having count(IdCompra)>1;

-- Puedo setear IdCompra como primary key
alter table compra
add primary key(IdCompra);

-- ------------------------------------------------------------------------------------------------
-- empleado
-- IdEmpleado tiene duplicados y triplicados --> No puede ser clave primaria
select IdEmpleado, count(IdEmpleado)
from empleado
group by IdEmpleado
having count(IdEmpleado)>1;

-- Los IdEmpleado estaran dado en un scope de sucursal??
select e.*, s.Sucursal, s.IdSucursal 
from empleado e join sucursal s
on e.Sucursal=s.Sucursal;


-- Vamos a agregar el IdSucursal
alter table empleado
add column IdSucursal int after Sucursal;

update empleado e join sucursal s
on e.Sucursal=s.Sucursal
set e.IdSucursal = s.IdSucursal;

-- Vamos a verificar si quedo algun empleado cuya sucursal no se encuentra en la lista de sucursales
select distinct Sucursal from empleado
where Sucursal not in (select Sucursal from sucursal);
-- Efectivamente hay dos sucursales "Mendoza 1" y "Mendoza 2" que no estan en la lista de sucursales.alter

select distinct Sucursal from sucursal
where sucursal like "%Mendo%";
-- Esto retorna las sucursales "Mendoza1" y "Mendoza2"
-- El error es que en la tabla empleado tienen un espacio entre Mendoza y el numero

update empleado
set Sucursal = "Mendoza1" where Sucursal="Mendoza 1";

update empleado
set Sucursal="Mendoza2" where sucursal="Mendoza 2";

-- Listo! Ahora vamos a setear el id
update empleado e join sucursal s
on e.Sucursal=s.Sucursal
set e.IdSucursal = s.IdSucursal;


-- Vamos a renombrar IdEmpleado como CodigoEmpleado y luego vamos a generar una nueva IdEmpleado
ALTER TABLE empleado RENAME COLUMN IdEmpleado to CodigoEmpleado;

ALTER TABLE empleado ADD COLUMN IdEmpleado INT NOT NULL DEFAULT 0 FIRST;

-- Vamos a crear una clave subrogada en base al IdSucursal y CodigoEmpleado
update empleado
set IdEmpleado= (IdSucursal * 1000000) + CodigoEmpleado;

-- Vamos a verificar si tengo duplicados en mi nueva clave
select IdEmpleado, count(IdEmpleado)
from empleado
group by IdEmpleado
having count(IdEmpleado)>1;

-- Dado que no tiene duplicados --> puedo setearla como clave primaria
alter table empleado
add primary key(IdEmpleado);

-- ------------------------------------------------------------------------------------------------
-- gasto
-- IdGasto no tiene duplicados
select IdGasto, count(IdGasto)
from gasto
group by IdGasto
having count(IdGasto)>1;

-- Puedo setear IdGasto como clave primaria
alter table gasto
add primary key(IdGasto);

-- ------------------------------------------------------------------------------------------------
-- producto
-- IdProducto no tiene duplicados
select IdProducto, count(IdProducto)
from producto
group by IdProducto
having count(IdProducto)>1;

-- Puedo seterar IdProducto como clave primaria
alter table producto
add primary key (IdProducto);

-- ------------------------------------------------------------------------------------------------
-- proveedor
-- IdProveedor no tiene duplicados
select IdProveedor, count(IdProveedor)
from proveedor
group by IdProveedor
having count(IdProveedor)>1;

-- Puedo setear IdProveedor como clave primaria
alter table proveedor
add primary key(IdProveedor);

-- ------------------------------------------------------------------------------------------------
-- sucursal
-- IdSucursal no tiene duplicados
select IdSucursal, count(IdSucursal)
from sucursal
group by IdSucursal
having count(IdSucursal)>1;

-- Puedo setar IdSucursal como clave primaria
alter table sucursal
add primary key (IdSucursal);

-- ------------------------------------------------------------------------------------------------
-- tipo_gasto
-- IdTipoGasto no tiene duplicados
select IdTipoGasto, count(IdTipoGasto)
from tipo_gasto
group by IdTipoGasto
having count(IdTipoGasto)>1;

-- Puedo setar IdTipoGasto como clave primaria
alter table tipo_gasto
add primary key (IdTipoGasto);

-- ------------------------------------------------------------------------------------------------
-- venta
-- IdVenta no tiene duplicados
select IdVenta, count(IdVenta)
from venta
group by IdVenta
having count(IdVenta)>1;

-- Puedo setar IdVenta como clave primaria
alter table venta
add primary key (IdVenta);


/*
11) Generar dos nuevas tablas a partir de la tabla 'empleado' que contengan las entidades Cargo y Sector.
*/

select * from empleado;

-- Craeamos la tabla sector
create table if not exists sector(
IdSector int not null auto_increment primary key,
Sector varchar(50)
) engine=InnoDb default charset=utf8mb4 collate=utf8mb4_spanish_ci;

-- Creamos la tabla cargo
create table if not exists cargo(
IdCargo int not null auto_increment primary key,
Cargo varchar(50)
)engine=InnoDb default charset=utf8mb4 collate=utf8mb4_spanish_ci;

-- insertamos valores en la tabla sector, solo valores unicos
insert into sector (Sector) (select distinct Sector from empleado);

-- insertamos valores en la tabla cargo, solo valores unicos
insert into cargo(Cargo) (select distinct Cargo from empleado);

-- Ahora Creamos dos nuevas columnas en empleado --> IdSector e IdCargo
alter table empleado
add column IdSector int not null after Sector, 
add column IdCargo int not null after Cargo;

update empleado
join sector
on empleado.Sector = sector.Sector
set empleado.IdSector = sector.IdSector;

update empleado
join cargo
on empleado.Cargo=cargo.Cargo
set empleado.IdCargo=cargo.IdCargo;

-- Ahora podemos dropear las columnas Cargo y Sector de la tabla de empleados
alter table empleado
drop Cargo, drop Sector;


/*
12) Generar una nueva tabla a partir de la tabla 'producto' que contenga la entidad Tipo de Producto.
*/

select * from producto;
-- hay missig data en la columna Tipo, vamos a agregar tipo_desconocido

-- Agregamos el tipo de producto "tipo_desconocido"
update producto
set Tipo="tipo_desconocido" where TRIM(Tipo)="" or Tipo is NULL;

create table if not exists tipo_producto(
	IdTipoProducto int not null auto_increment primary key,
    Tipo varchar(50)
) engine = InnoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;

insert into tipo_producto (Tipo) (select distinct Tipo from producto);

-- Agregamos una nueva columna en producto llamada IdTipoProducto
alter table producto
add column IdTipoProducto int not null  default 0 after Tipo;

-- agregamos el Id desde la tabla tipo_producto
update producto join tipo_producto
on producto.Tipo=tipo_producto.Tipo
set producto.IdTipoProducto=tipo_producto.IdTipoProducto;

-- Ahora ya podemos dropear la columna Tipo
alter table producto
drop Tipo;


/*
13) Es necesario contar con una tabla de localidades del país con el fin de evaluar la apertura de una nueva 
    sucursal y mejorar nuestros datos. 
    A partir de los datos en las tablas cliente, sucursal y proveedor hay que generar una tabla definitiva 
    de Localidades y Provincias.
    Utilizando la nueva tabla de Localidades controlar y corregir (Normalizar) los campos Localidad y 
    Provincia de las tablas cliente, sucursal y proveedor.
*/

select Localidad, Provincia from cliente; -- tiene provincia y localidad
-- hay valores faltantes
update cliente 
set Localidad="localidad_desconocida" where Localidad="" or Localidad is null;

update cliente 
set Provincia="provincia_desconocida" where Provincia="" or Provincia is null;



select Localidad, Provincia from sucursal; -- tiene Localidad y Provincia

select Ciudad as Localidad, Provincia from proveedor; -- tiene ciudad y Provincia

-- Vamos a crear una tabla de auditoria para las localidades/provincias
create table if not exists auditoria_localidades(
	LocalidadOrig varchar(80),
    ProvinciaOrig varchar(80),
    LocalidadModif varchar(80),
    ProvinciaModif varchar(80),
    IdLocalidad int not null
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;

insert into auditoria_localidades (LocalidadOrig, ProvinciaOrig, LocalidadModif, ProvinciaModif, IdLocalidad)
select distinct Localidad, Provincia, Localidad, Provincia, 0 from cliente
union
select distinct Localidad, Provincia, Localidad, Provincia, 0 from sucursal
union
select distinct Ciudad, Provincia, Ciudad, Provincia, 0 FROM proveedor
ORDER BY 2, 1; -- order by provincia y luego por localidad

-- Voy a buscar todas las opciones compatibles con provincia de buenos aires
select distinct ProvinciaOrig from auditoria_localidades
where (ProvinciaOrig like "B%" or ProvinciaOrig like "P%") and (ProvinciaOrig not like "%desconocida");

   
-- Vamos a ver cuantos distintos hay
select  * from auditoria_localidades
where ProvinciaOrig in (
select distinct aux.ProvinciaOrig from auditoria_localidades as aux
where (aux.ProvinciaOrig like "B%" or aux.ProvinciaOrig like "P%") and (aux.ProvinciaOrig not like "%desconocida")
);

-- Modificamos la columna ProvinciaModif para Buenos Aires
update auditoria_localidades as t1, 
(select distinct ProvinciaOrig from auditoria_localidades
where (ProvinciaOrig like "B%" or ProvinciaOrig like "P%") and (ProvinciaOrig not like "%desconocida")) as t2
set t1.ProvinciaModif = "Buenos Aires"
where t1.ProvinciaOrig=t2.ProvinciaOrig;

-- Vamos a ver cuantos distintos quedan
select distinct ProvinciaModif 
from auditoria_localidades;

-- Vamos a ver cuantos distintos hay para CABA
select  distinct ProvinciaModif from auditoria_localidades
where ProvinciaOrig in (
select distinct aux.ProvinciaOrig from auditoria_localidades as aux
where (aux.ProvinciaOrig like "C%") and (aux.ProvinciaOrig not like "Córdoba")
);


-- Modificamos la columna ProvinciaModif para CABA
update auditoria_localidades as t1, 
(select distinct aux.ProvinciaOrig from auditoria_localidades as aux
where (aux.ProvinciaOrig like "C%") and (aux.ProvinciaOrig not like "Córdoba")) as t2
set t1.ProvinciaModif = "CABA"
where t1.ProvinciaOrig=t2.ProvinciaOrig;

select distinct ProvinciaOrig from auditoria_localidades;

-- Hacemos lo mismo para las localidades. Primero las visualizamos para inspeccionar inconsistencias
select distinct LocalidadOrig, ProvinciaModif 
from auditoria_localidades 
order by LocalidadOrig asc ;

-- Modificamos para Localidad CABA
update auditoria_localidades
set LocalidadModif = "CABA"
where LocalidadOrig in
("caba", "Caba", "Cap.   Federal", "Cap. Fed.", "Capfed", "Capital", 
"Capital Federal", "Cdad De Buenos Aires","Ciudad De Buenos Aires");

-- Modificamos para ciudad Córdoba
update auditoria_localidades
set LocalidadModif = "Córdoba"
where LocalidadOrig in
("cordoba", "Coroba");

-- selecciono las Provincias unicas para hacer una tabla de provincias
select distinct ProvinciaModif from auditoria_localidades;

-- Creo una tabla de provincias
create table if not exists provincia(
IdProvincia int not null auto_increment primary key,
Provincia varchar(80)
) engine= InnoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;

insert into provincia(Provincia)(select distinct ProvinciaModif from auditoria_localidades) order by 1;

-- Creo una tabla de Localidades
create table if not exists localidad(
IdLocalidad int not null auto_increment primary key,
Localidad varchar(80),
Provincia varchar(80)
) engine= InnoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;

-- Agrego las localidades unicas
insert into localidad(Localidad, Provincia)
(select distinct LocalidadModif, ProvinciaModif from auditoria_localidades) order by 1;


-- Agrego una columna a Localidad
alter table localidad
add column IdProvincia int not null after Provincia;

-- Seteo los valores de la columna IdProvincia
update localidad
join provincia
on localidad.Provincia=provincia.Provincia
set localidad.IdProvincia = provincia.IdProvincia;

-- Ahora dropeo la columna Provincia
alter table localidad
drop Provincia;


-- Ahora puedo modificar las tablas originales donde habia localidad y provincia (cliente, sucursal, proveedor)

select * from cliente;

alter table cliente 
add column IdLocalidad int not null after Localidad;

-- populamos la tabla cliente
update cliente c
join localidad l
on c.Localidad=l.Localidad
set c.IdLocalidad = l.IdLocalidad;

-- Dropeamos las columnas Provincia y Localidad
alter table cliente
drop Provincia, drop Localidad;


-- Hacemos lo propio con la tabla sucursal
select * from sucursal;

update sucursal as t1
join auditoria_localidades as t2
on t1.Localidad = t2.LocalidadOrig
set t1.Localidad=t2.LocalidadModif;


alter table sucursal
add column IdLocalidad int not null after Localidad;

update sucursal s
join localidad l
on s.Localidad = l.Localidad
set s.IdLocalidad = l.IdLocalidad;

alter table sucursal
drop Localidad, drop Provincia;


-- Hacemos lo propio con la tabla proveedor

select * from proveedor;

update proveedor p
join auditoria_localidades a
on p.Ciudad=a.LocalidadOrig
set p.Ciudad=a.LocalidadModif;

alter table proveedor
add column IdLocalidad int not null after Ciudad;

update proveedor p
join localidad l
on p.Ciudad=l.Localidad
set p.IdLocalidad = l.IdLocalidad;

alter table proveedor
drop Ciudad, drop Provincia;

alter table proveedor
drop Pais, drop Departamento;


/*
14) Es necesario discretizar el campo edad en la tabla cliente.
*/

alter table cliente
add column rango_edad varchar(20) not null default "0" after edad;

update cliente
set rango_edad = CASE 
    WHEN edad < 10 THEN '0 - 9'
    WHEN edad < 20 THEN '10 - 19'
    WHEN edad < 30 THEN '20 - 29'
    WHEN edad < 40 THEN '30 - 39'
    WHEN edad < 50 THEN '40 - 49'
    WHEN edad < 60 THEN '50 - 59'
    WHEN edad < 70 THEN '60 - 69'
    WHEN edad < 80 THEN '70 - 79'
    WHEN edad < 90 THEN '80 - 89'
    ELSE 'mas de 90' 
END ;

-- ordenados por mayor cantidad de individuos
select rango_edad, count(rango_edad) as cantidad
from cliente
group by rango_edad
order by count(rango_edad);

-- ordenados por rango de edad
select rango_edad, count(rango_edad) as cantidad
from cliente
group by rango_edad
order by rango_edad;

/*
Fin
*/