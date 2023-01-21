-- Codigo de Noe 👻

/* ********************************************************************************************* */
--                               CREACION DE LAS BASE DE DATOS
/* ********************************************************************************************* */


-- Debo crear y cargar cada una de las tablas
-- DROP DATABASE Henry_m3_Noe_clase_01;
CREATE DATABASE IF NOT EXISTS Henry_m3_Noe_clase_02_v2; 
USE Henry_m3_Noe_clase_02_v2;



/* ********************************************************************************************* */
--                             CATALOGO DE FUNCIONES Y PROCEDIMIENTOS
/* ********************************************************************************************* */

SET GLOBAL log_bin_trust_function_creators = 1;
DROP FUNCTION IF EXISTS `UC_Words`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `UC_Words`( str VARCHAR(255) ) RETURNS varchar(255) CHARSET utf8
BEGIN  
    DECLARE c CHAR(1);  
    DECLARE s VARCHAR(255);  
    DECLARE i INT DEFAULT 1;  
    DECLARE bool INT DEFAULT 1;  
    DECLARE punct CHAR(17) DEFAULT ' ()[]{},.-_!@;:?/';  
    SET s = LCASE( str );  
    WHILE i < LENGTH( str ) DO  
        BEGIN  
            SET c = SUBSTRING( s, i, 1 );  
            IF LOCATE( c, punct ) > 0 THEN  
                SET bool = 1;  
            ELSEIF bool=1 THEN  
            BEGIN  
                IF c >= 'a' AND c <= 'z' THEN  
                BEGIN  
                    SET s = CONCAT(LEFT(s,i-1),UCASE(c),SUBSTRING(s,i+1));  
                    SET bool = 0;  
                END;  
                ELSEIF c >= '0' AND c <= '9' THEN  
                    SET bool = 0;  
                END IF;  
            END;  
            END IF;  
            SET i = i+1;  
        END;  
    END WHILE;  
    RETURN s;  
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `Llenar_dimension_calendario`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Llenar_dimension_calendario`(IN `startdate` DATE, IN `stopdate` DATE)
BEGIN
    DECLARE currentdate DATE;
    SET currentdate = startdate;
    WHILE currentdate < stopdate DO
        INSERT INTO calendario VALUES (
                        YEAR(currentdate)*10000+MONTH(currentdate)*100 + DAY(currentdate),
                        currentdate,
                        YEAR(currentdate),
                        MONTH(currentdate),
                        DAY(currentdate),
                        QUARTER(currentdate),
                        WEEKOFYEAR(currentdate),
                        DATE_FORMAT(currentdate,'%W'),
                        DATE_FORMAT(currentdate,'%M'));
        SET currentdate = ADDDATE(currentdate,INTERVAL 1 DAY);
    END WHILE;
END$$
DELIMITER ;


/* ********************************************************************************************* */
--                                  CREACION DE LAS TABLAS
/* ********************************************************************************************* */

-- canal_venta
DROP TABLE IF EXISTS canal_venta;
CREATE TABLE IF NOT EXISTS canal_venta(
    IdCanal INT,
    canal VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- cliente
DROP TABLE IF EXISTS cliente;
CREATE TABLE IF NOT EXISTS cliente(
    ID INT,
    Provincia VARCHAR(50),
    Nombre_y_Apellido VARCHAR(80),
    Domicilio VARCHAR(150),
    Telefono VARCHAR(30),
    Edad VARCHAR(5),
    Localidad VARCHAR(80),
    X VARCHAR(30),
    Y VARCHAR(30),
    col10 VARCHAR(1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;


-- compra
DROP TABLE IF EXISTS compra;
CREATE TABLE IF NOT EXISTS compra(
    IdCompra INT,
    Fecha DATE,
    IdProducto INT,
    Cantidad INT,
    Precio DECIMAL(10,2),
    IdProveedor INT
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;


-- empleado
DROP TABLE IF EXISTS empleado;
CREATE TABLE IF NOT EXISTS empleado(
    ID_empleado INT,
    Apellido VARCHAR(100),
    Nombre VARCHAR(100),
    Sucursal VARCHAR(50),
    Sector VARCHAR(50),
    Cargo VARCHAR(50),
    Salario DECIMAL(15,3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- gasto
DROP TABLE IF EXISTS gasto;
CREATE TABLE IF NOT EXISTS gasto(
    IdGasto INT,
    IdSucursal INT,
    IdTipoGasto INT,
    Fecha DATE,
    Monto DECIMAL(15,2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- producto
DROP TABLE IF EXISTS producto;
CREATE TABLE IF NOT EXISTS producto(
    ID_PRODUCTO INT,
    Concepto VARCHAR(150),
    Tipo VARCHAR(50),
    Precio varchar(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- proveedor
DROP TABLE IF EXISTS proveedor;
CREATE TABLE IF NOT EXISTS proveedor(
    IDProveedor INT,
    Nombre VARCHAR(50),
    Direccion VARCHAR(150),
    Ciudad VARCHAR(80),
    Provincia VARCHAR(80),
    Pais VARCHAR(50),
    Departamento VARCHAR(80)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- sucursal
DROP TABLE IF EXISTS sucursal;
CREATE TABLE IF NOT EXISTS sucursal(
    ID INT,
    Sucursal VARCHAR(50),
    Direccion VARCHAR(150),
    Localidad VARCHAR(80),
    Provincia VARCHAR(80),
    Latitud VARCHAR(50),
    Longitud VARCHAR(50)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- tipo_gasto
DROP TABLE IF EXISTS tipo_gasto;
CREATE TABLE IF NOT EXISTS tipo_gasto(
    IdTipoGasto INT,
    Descripcion VARCHAR(20),
    Monto_Aproximado DECIMAL(10,2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- venta
DROP TABLE IF EXISTS venta;
CREATE TABLE IF NOT EXISTS venta(
    IdVenta INT,
    Fecha DATE,
    Fecha_Entrega DATE,
    IdCanal INT,
    IdCliente INT,
    IdSucursal INT,
    IdEmpleado INT,
    IdProducto INT,
    Precio VARCHAR(20),
    Cantidad VARCHAR(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;


/* ********************************************************************************************* */
--                                  CARGAMOS LAS TABLAS CON DATOS
/* ********************************************************************************************* */

-- canal_venta
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/M3/CanalDeVenta.csv' 
INTO TABLE canal_venta
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- cliente
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/M3/Clientes.csv' 
INTO TABLE cliente
FIELDS TERMINATED BY ';' ENCLOSED BY '"' ESCAPED BY '"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- compra
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/M3/Compra.csv' 
INTO TABLE compra
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- empleado
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/M3/Empleados.csv' 
INTO TABLE empleado
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- gasto
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/M3/Gasto.csv' 
INTO TABLE gasto
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- producto
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/M3/Productos.csv' 
INTO TABLE producto
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- proveedor
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/M3/Proveedores.csv' 
INTO TABLE proveedor
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- sucursal
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/M3/Sucursales.csv' 
INTO TABLE sucursal
FIELDS TERMINATED BY ';' ENCLOSED BY '"' ESCAPED BY '"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- tipo_gasto
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/M3/TiposDeGasto.csv' 
INTO TABLE tipo_gasto
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- venta
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/M3/Venta.csv' 
INTO TABLE venta
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

/* ********************************************************************************************* */
--                            CREAMOS Y CARGAMOS UNA TABLA CALENDARIO
/* ********************************************************************************************* */


DROP TABLE IF EXISTS `calendario`;
CREATE TABLE calendario (
        id                      INTEGER PRIMARY KEY,  -- year*10000+month*100+day
        fecha                 	DATE NOT NULL,
        anio                    INTEGER NOT NULL,
        mes                   	INTEGER NOT NULL, -- 1 to 12
        dia                     INTEGER NOT NULL, -- 1 to 31
        trimestre               INTEGER NOT NULL, -- 1 to 4
        semana                  INTEGER NOT NULL, -- 1 to 52/53
        dia_nombre              VARCHAR(9) NOT NULL, -- 'Monday', 'Tuesday'...
        mes_nombre              VARCHAR(9) NOT NULL -- 'January', 'February'...
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CALL Llenar_dimension_calendario('2015-01-01','2020-12-31');
SELECT * FROM calendario;
