
## Homework

Con el objetivo de asegurarse de que la calidad de la información con la que se va a trabajar sea la óptima, es necesario realizar una lista de propuestas de mejora teniendo en cuenta los siguientes puntos:

1) ¿Qué tan actualizada está la información? ¿La forma en que se actualiza ó mantiene esa información se puede mejorar?
2) ¿Los datos están completos en todas las tablas?
3) ¿Se conocen las fuentes de los datos?
4) Al integrar éstos datos, es prudente que haya una normalización respecto de nombrar las tablas y sus campos.
5) Es importante revisar la consistencia de los datos: ¿Se pueden relacionar todas las tablas al modelo? ¿Cuáles son las tablas de hechos y las tablas dimensionales o maestros? ¿Podemos hacer esa separación en los datos que tenemos (tablas de hecho y dimensiones)? ¿Hay claves duplicadas? ¿Cuáles son variables cualitativas y cuáles son cuantitativas? ¿Qué acciones podemos aplicar sobre las mismas?

### Limpieza, Valores faltantes y Normalización

6) Normalizar los nombres de los campos y colocar el tipo de dato adecuado para cada uno en cada una de las tablas. Descartar columnas que consideres que no tienen relevancia.
7) Buscar valores faltantes y campos inconsistentes en las tablas sucursal, proveedor, empleado y cliente. De encontrarlos, deberás corregirlos o desestimarlos. Propone y realiza una acción correctiva sobre ese problema.
8) Chequear la consistencia de los campos precio y cantidad de la tabla de ventas.
9) Utilizar la funcion provista 'UC_Words' para modificar a letra capital los campos que contengan descripciones para todas las tablas.
10) Chequear que no haya claves duplicadas, y de encontrarla en alguna de las tablas, proponer una solución.
11) Generar dos nuevas tablas a partir de la tabla 'empelado' que contengan las entidades Cargo y Sector.
12) Generar una nueva tabla a partir de la tabla 'producto' que contenga la entidad Tipo de Producto.
13) Es necesario contar con una tabla de localidades del país con el fin de evaluar la apertura de una nueva sucursal y mejorar nuestros datos. 
A partir de los datos en las tablas cliente, sucursal y proveedor hay que generar una tabla definitiva de Localidades y Provincias.
Utilizando la nueva tabla de Localidades controlar y corregir (Normalizar) los campos Localidad y Provincia de las tablas cliente, sucursal y proveedor.
14) Es necesario discretizar el campo edad en la tabla cliente.