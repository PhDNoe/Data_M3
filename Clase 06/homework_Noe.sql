/*
## Homework

1. Crear un procedimiento que recibe como parametro una fecha y devuelva el listado de productos 
    que se vendieron en esa fecha.
2. Crear una función que calcule el valor nominal de un margen bruto determinado por el usuario 
    a partir del precio de lista de los productos.
3. Obtener un listado de productos de IMPRESION y utilizarlo para cálcular el valor nominal de un 
    margen bruto del 20% de cada uno de los productos.
4. Crear un procedimiento que permita listar los productos vendidos desde fact_venta a partir de 
    un "Tipo" que determine el usuario.
5. Crear un procedimiento que permita realizar la insercción de datos en la tabla fact_inicial.
6. Crear un procedimiento almacenado que reciba un grupo etario y devuelta el total de ventas 
    para ese grupo.
7. Crear una variable que se pase como valor para realizar una filtro sobre Rango_etario en una 
    consulta génerica a dim_cliente.
*/

/*
*************************************************************************************************************
1. Crear un procedimiento que recibe como parametro una fecha y devuelva el listado de productos 
    que se vendieron en esa fecha.
*************************************************************************************************************
*/

use henry_m3_noe_clase_03;
set global log_bin_trust_function_creators=1;

delimiter $$

create procedure ventas_por_fecha(fecha DATE) 
BEGIN
    select v.IdProducto, p.Concepto as producto
    from venta as v 
    join producto as p
    where v.Fecha=fecha;
    
END $$

delimiter ;

call ventas_por_fecha("2018-04-03");

show variables;

/*
*************************************************************************************************************
2. Crear una función que calcule el valor nominal de un margen bruto determinado por el usuario 
    a partir del precio de lista de los productos.
*************************************************************************************************************
*/
delimiter $$
create function margen_bruto(precio decimal(15,2), margen decimal(8,2)) returns decimal(15,2)
BEGIN
    declare mg_bruto decimal(15,2);
    set mg_bruto = precio*margen; -- El margen esta calculado como 1 + variacion porcentual, ej --> 1.2 --> 20%
    return mg_bruto;
end $$

delimiter ;

select c.Fecha, p.IdProducto, p.Concepto, pv.IdProveedor,p.Precio, margen_bruto(p.Precio, 1.35) as margen_bruto
from compra as c
inner join producto as p on c.IdProducto=  p.IdProducto
inner join proveedor as pv on c.IdProveedor=pv.IdProveedor;


/*
*************************************************************************************************************
3. Obtener un listado de productos de IMPRESION y utilizarlo para cálcular el valor nominal de un 
    margen bruto del 20% de cada uno de los productos.
*************************************************************************************************************
*/
select p.IdProducto, p.Concepto, tp.Tipo, p.Precio, margen_bruto(p.Precio, 1.2) as margen_bruto
from producto as p
inner join tipo_producto as tp
on p.IdTipoProducto=tp.IdTipoProducto
where tp.Tipo = "Impresión";

/*
*************************************************************************************************************
4. Crear un procedimiento que permita listar los productos vendidos desde fact_venta a partir de 
    un "Tipo" que determine el usuario.
*************************************************************************************************************
*/

delimiter $$
create procedure listar_por_tipo(tipo varchar(50))
begin
	select p.IdProducto, p.Concepto, tp.Tipo
	from fact_venta as fv 
	inner join producto as p on fv.IdProducto=p.IdProducto
	inner join tipo_producto as tp on p.IdTipoProducto=tp.IdTipoProducto
	where tp.Tipo collate utf8mb4_spanish_ci like concat("%",tipo,"%");
    end $$

delimiter ;

call listar_por_tipo("Gabinetes");


/*
*************************************************************************************************************
5. Crear un procedimiento que permita realizar la insercción de datos en la tabla fact_venta.
*************************************************************************************************************
*/

drop procedure if exists carga_fact_venta;
delimiter $$
create procedure carga_fact_venta(idventa int, fecha date, fecha_entrega date, idsucursal int, 
idproducto int, idcliente int, precio decimal(15,2), Cantidad int)
begin
	insert into fact_venta
    (IdVenta, Fecha, Fecha_Entrega, IdSucursal, IdProducto, IdCliente, Precio, Cantidad)
    values
    (idventa, fecha, fecha_entrega, idsucursal, idproducto, idcliente, precio, cantidad);
end $$

delimiter ;

call carga_fact_venta(48244, "2020-10-15", "2020-10-16", 13, 42761, 53, 1384.46, 2);


/*
*************************************************************************************************************
6. Crear un procedimiento almacenado que reciba un grupo etario y devuelta el total de ventas 
    para ese grupo.
*************************************************************************************************************
*/
drop procedure if exists venta_rango_edad;
delimiter $$
create procedure venta_rango_edad(rango_edad varchar(20))
begin
select v.Fecha,  c.Nombre_y_Apellido, c.rango_edad, p.Concepto as producto, v.Precio, v.Cantidad
from venta as v
inner join cliente as c on v.IdCliente=c.IdCliente
inner join producto as p on v.IdProducto=p.IdProducto
where c.rango_edad collate utf8mb4_spanish_ci = rango_edad;

end $$
delimiter ;

-- probamos con el rango de edad 30 - 39
call venta_rango_edad("30 - 39");

/*
*************************************************************************************************************
7. Crear una variable que se pase como valor para realizar una filtro sobre Rango_etario en una 
    consulta génerica a dim_cliente.
*************************************************************************************************************
*/

set @rango_edad = "20 - 29" collate utf8mb4_spanish_ci;

select * from dim_cliente where rango_edad=@rango_edad;
