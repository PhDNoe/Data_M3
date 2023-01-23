/*
    ## Homework
    
    1. Genere 5 consultas simples con alguna función de agregación y filtrado sobre las tablas. 
        Anote los resultados del la ficha de estadísticas.
    2. A partir del conjunto de datos elaborado en clases anteriores, genere las PK de cada una 
        de las tablas a partir del campo que cumpla con los requisitos correspondientes.
    3. Genere la indexación de los campos que representen fechas o ID en las tablas:
        - calendario.
        - venta.
        - cana_venta.
        - productp.
        - tipo_producto.
        - sucursal.
        - empleado.
        - localidad.
        - proveedor.
        - gasto.
        - cliente.
        - compra.
    4. Ahora que las tablas están indexadas, vuelva a ejecutar las consultas del punto 1 y evalue 
        las estadístias. ¿Nota alguna diferencia?.
    5. Genere una nueva tabla que lleve el nombre fact_venta (modelo estrella) que pueda agrupar 
        los hechos relevantes de la tabla venta, los campos a considerar deben ser los siguientes:
        - IdFecha ,
        - Fecha,
        - IdSucursal,
        - IdProducto,
        - IdCliente,
        - Precio
        - Cantidad
    
    6. A partir de la tabla creada en el punto anterior, deberá poblarla con los datos de la tabla ventas.
    
 */

-- **********************************************************************************************************
-- 1. Genere 5 consultas simples con alguna función de agregación y filtrado sobre las tablas. 
--    Anote los resultados del la ficha de estadísticas.
-- **********************************************************************************************************

-- No voy a generar una nueva base de datos, voy a trabajar con la de la clase 03
use henry_m3_noe_clase_03;

-- ----------------------------------------------------------------------------------------------------------
-- 1° Consulta --> Venta agrupado por trimestre y rango de edad
-- ----------------------------------------------------------------------------------------------------------
-- Primero debo ver cuales son las tablas que necesito agrupar
select * from venta; -- Los campos que me pueden servir son: Fecha, IdCliente, Precio, Cantidad
select * from cliente; -- Los campos que me pueden servir son: rango_edad
select * from calendario; -- Los campos que me pueden interesar son: fecha, trimestre


-- creamos la query
select SQL_NO_CACHE cal.trimestre, cli.rango_edad, sum(v.Precio*v.Cantidad) as ventas
from venta as v 
inner join cliente as cli on v.IdCliente=cli.IdCliente
inner join calendario as cal on v.Fecha=cal.fecha
group by cal.trimestre, cli.rango_edad
order by ventas;
-- Resultado: Duracion: entre 0.171 y 0.188 sec

-- ----------------------------------------------------------------------------------------------------------
-- 2° Consulta: Venta agrupado por año, trimestre tipo de producto
-- ----------------------------------------------------------------------------------------------------------
select SQL_NO_CACHE cal.anio, cal.trimestre, tp.Tipo, sum(v.Precio * v.Cantidad) as ventas
from venta as v
inner join Calendario as cal on v.Fecha = cal.fecha
inner join Producto as prod on v.IdProducto=prod.IdProducto
inner join tipo_producto as tp on prod.IdTipoProducto=tp.IdTipoProducto
group by cal.anio, cal.trimestre, tp.Tipo
order by ventas;
-- Resultado: 0.219sec

-- ----------------------------------------------------------------------------------------------------------
-- 3° consulta: Venta agrupado por sucursal, canal, mayor a 5000000
-- ----------------------------------------------------------------------------------------------------------
select SQL_NO_CACHE suc.Sucursal as sucursal, can.Canal as canal_venta, sum(v.Precio*v.Cantidad) as ventas
from venta as v
inner join sucursal as suc on v.IdSucursal=suc.IdSucursal
inner join canal_venta as can on v.IdCanal=can.IdCanal
group by sucursal, canal
having ventas> 5000000
order by sucursal, canal, ventas;
-- Retorna 0.140sec

-- ----------------------------------------------------------------------------------------------------------
-- CREAMOS INDICES EN LAS TABLAS (en todos los campos Fecha e Ids)
-- - calendario.
-- - venta.
-- - cana_venta.
-- - producto.
-- - tipo_producto.
-- - sucursal.
-- - empleado.
-- - localidad.
-- - proveedor.
-- - gasto.
-- - cliente.
-- - compra.
-- ----------------------------------------------------------------------------------------------------------

/*
-- Calendario
ALTER TABLE Calendario ADD INDEX(fecha);
ALTER TABLE Calendario ADD INDEX(anio);
ALTER TABLE Calendario ADD INDEX(trimestre);

*/
ALTER TABLE calendario ADD UNIQUE(`fecha`);

-- venta
ALTER TABLE venta ADD INDEX(Fecha);
ALTER TABLE venta ADD INDEX(Fecha_entrega);
ALTER TABLE venta ADD INDEX(IdCanal);
ALTER TABLE venta ADD INDEX(IdCliente);
ALTER TABLE venta ADD INDEX(IdSucursal);
ALTER TABLE venta ADD INDEX(IdEmpleado);
ALTER TABLE venta ADD INDEX(IdProducto);

-- canal_venta
-- Ya fue agregada la PK con anterioridad

-- producto
ALTER TABLE producto ADD INDEX(IdTipoProducto);

-- tipo_producto
-- Ya fue agregada la PK con anterioridad

-- sucursal
ALTER TABLE sucursal ADD INDEX(IdLocalidad);

-- empleado.
ALTER TABLE empleado ADD INDEX(IdSucursal);
ALTER TABLE empleado ADD INDEX(IdSector);
ALTER TABLE empleado ADD INDEX(IdCargo);

-- localidad.
ALTER TABLE localidad ADD INDEX(IdProvincia);

-- proveedor.
ALTER TABLE proveedor ADD INDEX(IdLocalidad);

-- gasto.
ALTER TABLE gasto ADD INDEX(IdSucursal);
ALTER TABLE gasto ADD INDEX(IdTipoGasto);
ALTER TABLE gasto ADD INDEX(Fecha);

-- cliente.
ALTER TABLE cliente ADD INDEX(IdLocalidad);

-- compra.
ALTER TABLE compra ADD INDEX(Fecha);
ALTER TABLE compra ADD INDEX(IdProducto);
ALTER TABLE compra ADD INDEX(IdProveedor);


-- Agregamos las foreign keys
-- venta --> IdCanal, IdCliente, IdSucursal, IdEmpleado, IdProducto
ALTER TABLE venta ADD CONSTRAINT venta_fk_canal 
FOREIGN KEY (IdCanal) REFERENCES canal_venta (IdCanal) 
ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE venta ADD CONSTRAINT venta_fk_cliente
FOREIGN KEY (IdCliente) REFERENCES cliente (IdCliente) 
ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE venta ADD CONSTRAINT venta_fk_sucursal
FOREIGN KEY (IdSucursal) REFERENCES sucursal (IdSucursal) 
ON DELETE RESTRICT ON UPDATE RESTRICT;

SET FOREIGN_KEY_CHECKS=0; -- Es para que tome la query que sigue, que por alguna razon tiraba el sig. error
-- error-1452-cannot-add-or-update-a-child-row-a-foreign-key-constraint-fails

ALTER TABLE venta ADD CONSTRAINT venta_fk_empleado
FOREIGN KEY (IdEmpleado) REFERENCES empleado (IdEmpleado) 
ON DELETE RESTRICT ON UPDATE RESTRICT;
-- esta tira error


ALTER TABLE venta ADD CONSTRAINT venta_fk_producto
FOREIGN KEY (IdProducto) REFERENCES producto (IdProducto) 
ON DELETE RESTRICT ON UPDATE RESTRICT;


-- producto --> IdTipoProducto
ALTER TABLE producto ADD CONSTRAINT producto_fk_tipo_producto
FOREIGN KEY (IdTipoProducto) REFERENCES tipo_producto (IdTipoProducto) 
ON DELETE RESTRICT ON UPDATE RESTRICT;


-- sucursal --> IdLocalidad
ALTER TABLE sucursal ADD CONSTRAINT sucursal_fk_localidad
FOREIGN KEY (IdLocalidad) REFERENCES localidad (IdLocalidad) 
ON DELETE RESTRICT ON UPDATE RESTRICT;

-- empleado --> IdSucursal, IdSector, IdCargo
ALTER TABLE empleado ADD CONSTRAINT empleado_fk_sucursal
FOREIGN KEY (IdSucursal) REFERENCES sucursal (IdSucursal) 
ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE empleado ADD CONSTRAINT empleado_fk_sector
FOREIGN KEY (IdSector) REFERENCES sector (IdSector) 
ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE empleado ADD CONSTRAINT empleado_fk_cargo
FOREIGN KEY (IdCargo) REFERENCES cargo (IdCargo) 
ON DELETE RESTRICT ON UPDATE RESTRICT;


-- localidad --> IdProvincia
ALTER TABLE localidad ADD CONSTRAINT localidad_fk_provincia
FOREIGN KEY (IdPRovincia) REFERENCES provincia (IdProvincia) 
ON DELETE RESTRICT ON UPDATE RESTRICT;


-- proveedor --> IdLocalidad
ALTER TABLE proveedor ADD CONSTRAINT proveedor_fk_localidad
FOREIGN KEY (IdLocalidad) REFERENCES localidad (IdLocalidad) 
ON DELETE RESTRICT ON UPDATE RESTRICT;

-- gasto -->  IdSucursal, IdTipoGasto
ALTER TABLE gasto ADD CONSTRAINT gasto_fk_sucursal
FOREIGN KEY (IdSucursal) REFERENCES sucursal (IdSucursal) 
ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE gasto ADD CONSTRAINT gasto_fk_tipo_gasto
FOREIGN KEY (IdTipoGasto) REFERENCES tipo_gasto (IdTipoGasto) 
ON DELETE RESTRICT ON UPDATE RESTRICT;

-- este falla, pero con SET FOREIGN_KEY_CHECKS=0 funciona
-- cliente --> IdLocalidad
ALTER TABLE cliente ADD CONSTRAINT cliente_fk_localidad
FOREIGN KEY (IdLocalidad) REFERENCES localidad (IdLocalidad) 
ON DELETE RESTRICT ON UPDATE RESTRICT;

-- compra --> IdProducto, IdProveedor
ALTER TABLE compra ADD CONSTRAINT compra_fk_producto
FOREIGN KEY (IdProducto) REFERENCES producto (IdProducto) 
ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE compra ADD CONSTRAINT compra_fk_proveedor
FOREIGN KEY (IdProveedor) REFERENCES proveedor (IdProveedor) 
ON DELETE RESTRICT ON UPDATE RESTRICT;

-- ----------------------------------------------------------------------------------------------------------
-- Volvemos a ejecutar las querys de antes. Las copio para mayor legibilidad
-- ----------------------------------------------------------------------------------------------------------
-- 1° Consulta --> Venta agrupado por trimestre y rango de edad
-- ----------------------------------------------------------------------------------------------------------
-- creamos la query
select SQL_NO_CACHE cal.trimestre, cli.rango_edad, sum(v.Precio*v.Cantidad) as ventas
from venta as v 
inner join cliente as cli on v.IdCliente=cli.IdCliente
inner join calendario as cal on v.Fecha=cal.fecha
group by cal.trimestre, cli.rango_edad
order by ventas;
-- Resultado: Duracion: entre 0.171 y 0.188 sec
-- Resultado con Index: 0.203 sec  --> Empeoro

-- ----------------------------------------------------------------------------------------------------------
-- 2° Consulta: Venta agrupado por año, trimestre tipo de producto
-- ----------------------------------------------------------------------------------------------------------
select SQL_NO_CACHE cal.anio, cal.trimestre, tp.Tipo, sum(v.Precio * v.Cantidad) as ventas
from venta as v
inner join Calendario as cal on v.Fecha = cal.fecha
inner join Producto as prod on v.IdProducto=prod.IdProducto
inner join tipo_producto as tp on prod.IdTipoProducto=tp.IdTipoProducto
group by cal.anio, cal.trimestre, tp.Tipo
order by ventas;
-- Resultado: 0.219sec
-- Resultado con Index:0.297 sec  --> Empeoro

-- ----------------------------------------------------------------------------------------------------------
-- 3° consulta: Venta agrupado por sucursal, canal, mayor a 5000000
-- ----------------------------------------------------------------------------------------------------------
select SQL_NO_CACHE suc.Sucursal as sucursal, can.Canal as canal_venta, sum(v.Precio*v.Cantidad) as ventas
from venta as v
inner join sucursal as suc on v.IdSucursal=suc.IdSucursal
inner join canal_venta as can on v.IdCanal=can.IdCanal
group by sucursal, canal
having ventas> 5000000
order by sucursal, canal, ventas;
-- Retorna 0.140sec
-- Retorna 0.187sec --> En todos los casos ha empeorado

-- **********************************************************************************************************
-- Voy a corregir el error de las foreign keys - Ejecutar esto una unica vez
-- **********************************************************************************************************
-- Hay algun IdEmpleado en ventas que no este en empleado?
select IdEmpleado from venta
where venta.IdEmpleado in
(
   select IdEmpleado from empleado where venta.IdEmpleado != empleado.IdEmpleado
);


alter table venta
add column IdEmpleado2 int after IdEmpleado;

SET SQL_SAFE_UPDATES=0;
update venta
set IdEmpleado2=IdSucursal*1000000+IdEmpleado;

ALTER TABLE venta
drop IdEmpleado;

alter TABLE venta
rename column IdEmpleado2 to IdEmpleado;

ALTER TABLE venta DROP FOREIGN KEY venta_fk_empleado;

ALTER TABLE venta ADD CONSTRAINT venta_fk_empleado
FOREIGN KEY (IdEmpleado) REFERENCES empleado (IdEmpleado) 
ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Ahora corregimos el de Cliente y localidad
-- Como hay localidades desconocidas, estan seteadas en cero
update cliente
set IdLocalidad=331 -- localidad desconocida
where IdLocalidad=0;
SET FOREIGN_KEY_CHECKS=1;
ALTER TABLE cliente DROP FOREIGN KEY cliente_fk_localidad;
ALTER TABLE cliente ADD CONSTRAINT cliente_fk_localidad
FOREIGN KEY (IdLocalidad) REFERENCES localidad (IdLocalidad) 
ON DELETE RESTRICT ON UPDATE RESTRICT;

select * from canal_venta;

select * from cargo;

select * from cliente limit 100000;

select * from compra limit 100000;

select * from empleado limit 100000;

select * from gasto limit 100000;

select * from localidad limit 100000;

select * from producto limit 100000;

select * from proveedor limit 100000;

select * from provincia;

select * from sector;

select * from sucursal;

select * from tipo_gasto;

select * from tipo_producto;

select * from venta limit 100000;

-- **********************************************************************************************************
/*
  5. Genere una nueva tabla que lleve el nombre fact_venta (modelo estrella) que pueda agrupar 
        los hechos relevantes de la tabla venta, los campos a considerar deben ser los siguientes:
        - IdFecha ,
        - Fecha,
        - IdSucursal,
        - IdProducto,
        - IdCliente,
        - Precio
        - Cantidad
*/
-- **********************************************************************************************************

create table if not exists fact_venta(
	IdVenta int not null primary key,
    Fecha date,
    Fecha_Entrega date,
    IdSucursal int,
    IdProducto int,
    IdCliente int,
    Precio decimal(15,2),
    Cantidad int
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;

create table if not exists dim_cliente(
	IdCliente int not null primary key,
    Nombre_y_Apellido varchar(80),
    Domicilio varchar(150),
    Telefono varchar(30),
    Edad varchar(5),
    rango_edad varchar(20),
    IdLocalidad int,
    Latitud decimal(15,10),
    Longitud decimal(15,10)
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;

create table if not exists dim_producto(
	IdProducto int not null primary key,
    Concepto varchar(150),
    IdTipoProducto int,
    Precio decimal(15,2)
)engine=InnoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;

create table if not exists dim_sucursal(
	IdSucursal int not null primary key,
    Sucursal varchar(50),
    Direccion varchar(150),
    IdLocalidad int,
    Latitud decimal(15,10),
    Longitud decimal(15,10)
)engine=InnoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;
-- **********************************************************************************************************
-- 6. A partir de la tabla creada en el punto anterior, deberá poblarla con los datos de la tabla ventas.
-- **********************************************************************************************************
insert into fact_venta 
select IdVenta, Fecha, Fecha_Entrega, IdSucursal, IdProducto, IdCliente, Precio, Cantidad
from venta where year(Fecha)=2020;


insert into dim_cliente
select IdCliente, Nombre_y_Apellido, Domicilio, Telefono, Edad, rango_edad, IdLocalidad, Latitud, Longitud
from cliente
where IdCliente in (select distinct IdCliente from fact_venta);

insert into dim_producto
select IdProducto, Concepto, IdTipoProducto, Precio
from producto
where IdProducto in (select distinct IdProducto from fact_venta);

insert into dim_sucursal
select IdSucursal, Sucursal, Direccion, IdLocalidad, Latitud, Longitud
from sucursal
where IdSucursal in (select distinct IdSucursal from fact_venta);