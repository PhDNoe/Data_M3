/*
## Homework

1. Crear una tabla que permita realizar el seguimiento de los usuarios que ingresan nuevos registros en fact_venta.
2. Crear una acción que permita la carga de datos en la tabla anterior.
3. Crear una tabla que permita registrar la cantidad total registros, luego de cada ingreso la tabla fact_venta.
4. Crear una acción que permita la carga de datos en la tabla anterior.
5. Crear una tabla que agrupe los datos de la tabla del item 3, a su vez crear un proceso de carga de los datos agrupados.
6. Crear una tabla que permita realizar el seguimiento de la actualización de registros de la tabla fact_venta.
7. Crear una acción que permitan la carga de datos en la tabla anterior, para su actualización.

*/
use henry_m3_noe_clase_03;

/*
*************************************************************************************************************
1. Crear una tabla que permita realizar el seguimiento de los usuarios que ingresan nuevos 
registros en fact_venta.
*************************************************************************************************************
*/


create table if not exists fact_venta_auditoria(
    IdFactVentaAuditoria int not null auto_increment primary key,
    Fecha DATE,
    Fecha_Entrega DATE,
    IdSucursal INT,
    IdCliente Int,
    IdProducto Int,
    Usuario VARCHAR(30),
    Fecha_Modificacion DATETIME
)engine=InnoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;

/*
*************************************************************************************************************
2. Crear una acción que permita la carga de datos en la tabla anterior.
*************************************************************************************************************
*/

create trigger vf_auditoria after insert on fact_venta
for each row
insert into fact_venta_auditoria 
(Fecha, Fecha_Entrega, IdSucursal, 
IdCliente, IdProducto, usuario, Fecha_Modificacion)
values (NEW.Fecha, NEW.Fecha_Entrega, NEW.IdSucursal, NEW.IdCliente, 
New.IdProducto, CURRENT_USER, Now());

-- Agregamos un registro a fact_venta para ver si el trigger funciona correctamente
insert into fact_venta (IdVenta,Fecha, Fecha_Entrega, IdSucursal, IdProducto, IdCliente, Precio, Cantidad)
values (48242, "2020-10-05", "2020-10-06", 13, 42795, 1722, 543.18,1);

/*
*************************************************************************************************************
3. Crear una tabla que permita registrar la cantidad total registros, luego de cada ingreso en 
la tabla fact_venta.
*************************************************************************************************************
*/
create table if not exists fact_venta_tot_reg(
	IdFactVentaTotReg int not null auto_increment primary key,
    TotalRegistros int,
    Usuario varchar(30),
    Fecha_Modificacion datetime
)engine=InnoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;


/*
*************************************************************************************************************
4. Crear una acción que permita la carga de datos en la tabla anterior.
*************************************************************************************************************
*/


create trigger fv_tot_reg_tg after insert on fact_venta
for each row
insert into fact_venta_tot_reg
(TotalRegistros, Usuario, Fecha_Modificacion)
values ((select count(*) from fact_venta), CURRENT_USER, NOW());

-- Agregamos otro registro a fact_venta para ver si ambos triggers funcionan correctamente
insert into fact_venta (IdVenta,Fecha, Fecha_Entrega, IdSucursal, IdProducto, IdCliente, Precio, Cantidad)
values (48243, "2020-10-08", "2020-10-09", 6, 42761, 53, 1384.46,2);


/*
*************************************************************************************************************
5. Crear una tabla que agrupe los datos de la tabla del item 3, a su vez crear un proceso de 
carga de los datos agrupados.
*************************************************************************************************************
*/
-- No tengo ni idea bajo que criterio agrupar los datos --> los agrupo por mes??


/*
*************************************************************************************************************
6. Crear una tabla que permita realizar el seguimiento de la actualización de registros de la tabla fact_venta.
*************************************************************************************************************
*/
create table if not exists fact_venta_updates(
    IdFactVentaUpdates int not null auto_increment primary key,
    IdVenta INT,
    Precio decimal(15,2),
    Cantidad int,
    change_Precio BOOLEAN default 0,
    change_Cantidad BOOLEAN default 0,    
    Usuario VARCHAR(30),
    Fecha_Modificacion DATETIME
)engine=InnoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;


/*
*************************************************************************************************************
7. Crear una acción que permitan la carga de datos en la tabla anterior, para su actualización.
*************************************************************************************************************
*/
delimiter $$
create trigger fv_update after update on fact_venta
for each row
begin
	IF OLD.Precio <> NEW.Precio THEN
		set @ch_precio=1;
	ELSE 
		set @ch_precio=0;
	END IF;
    
    IF OLD.Cantidad <> NEW.Cantidad THEN
		set @ch_cantidad=1;
	ELSE 
		set @ch_cantidad=0;
	END IF;
    
    IF @ch_precio=1  AND @ch_cantidad=0 THEN
		insert into fact_venta_updates (IdVenta, Precio, Cantidad, change_Precio, change_Cantidad, Usuario, Fecha_Modificacion)
		values(old.IdVenta, new.Precio, old.Cantidad, @ch_precio, @ch_cantidad, CURRENT_USER, now());
    ELSEIF  @ch_precio=1  AND @ch_cantidad=1 THEN
		insert into fact_venta_updates (IdVenta, Precio, Cantidad, change_Precio, change_Cantidad, Usuario, Fecha_Modificacion)
		values(old.IdVenta, new.Precio, new.Cantidad, @ch_precio, @ch_cantidad, CURRENT_USER, now());
	ELSEIF @ch_precio=0 AND @ch_cantidad=1 THEN
		insert into fact_venta_updates (IdVenta, Precio, Cantidad, change_Precio, change_Cantidad, Usuario, Fecha_Modificacion)
		values(old.IdVenta, old.Precio, new.Cantidad, @ch_precio, @ch_cantidad, CURRENT_USER, now());
	ELSE
		insert into fact_venta_updates (IdVenta, Precio, Cantidad, change_Precio, change_Cantidad, Usuario, Fecha_Modificacion)
		values(old.IdVenta, old.Precio, old.Cantidad, @ch_precio, @ch_cantidad, CURRENT_USER, now());
	END if;    
        
end$$

delimiter ;

-- Modificamos un registro para ver si funciona el trigger
update fact_venta
set Precio=1000
where IdVenta=48242;

-- FUNCIONA!!!

