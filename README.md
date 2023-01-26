## Repaso de los conceptos mas relevantes para mi

---
### Datos, Información, Conocimiento

* **Datos**: Los Datos son un conjunto de hechos almacenados
* **Información**: Es el conjunto de datos procesados en tiempo y en forma, que constituyen un mensaje relevante y reduce la incertidumbre.
* **Conocimiento**: Se adquiere con la práctica y la experiencia. Dota a las personas con la capacidad de tomar decisiones.

---
### Calidad de los datos
Muchas veces los datos no son confiables. Debemos lidiar con datos faltantes, datos corruptos, etc.

#### Causas de la mala calidad de los datos
* Carga manual
* Carga de datos externos sin los recaudos apropiados
* Problemas con las bases de datos
* Cambios en aplicaciones o migraciones de base de datos

---
### Criterios de calidad

* Actualización: 
    * Los datos deben estar actulizados
    * Deben existir referencias a la fecha de creación
    * Deben existir referencias a la fecha de última modificación
* Completitud:
    * Los datos deben estar completos (parece obvio, pero suelen haber campos vacíos)
* Fiabilidad: La procedencia y la trazabilidad del dato son características que hacen a la fiabilidad.
* Accesibilidad: Los datos deben ser accesibles con bajo nivel de esfuerzo
    * Deben estar en lugares previsibles
    * Deben ser fácilmente ubicables 
    * Deben ser fácilmente  elegibles
* Consistencia
    * Interna: Calidad de caracteres y de lo que se guarda en los campos.
    * Externa: Calidad de interdependencia y racionalidad de los campos.

---
## Tablas de Hechos y Dimensiones

### **Tabla de dimensiones (o tablas maestro)**
Son tablas que contienen información respecto de las entidades que están incluidas en el modelo. Por ejemplo una tabla de clientes, donde se tenga una clave primaria para identificar a cada uno de manera unívoca, y ademas los datos filiatorios, como ser nombre, apellido, fecha de nacimiento ó nacionalidad. Existe un y sólo un registro por cada cliente.

### **Tabla de Hechos**
Son tablas que guardan eventos donde se relacionan las entidades incluidas en el modelo y tambien las métricas asociadas. Por ejemplo una tabla de ventas, donde se guarda la fecha de la venta, cliente y producto implicados, la sucursal actuante y el monto de la venta realizada. Existe un registro por evento, al cuál se asocian las entidades relacionadas y también una métrica. Consecuentemente, una tabla de hechos puede también reflejar una entidad en sí misma, como el caso de la venta ó una generación de factura.

*Nota: Tanto los hechos como las dimensiones son entidades*

---
## Preparación y análisis de los datos

En la etapa de preparación de los datos se pueden generar conjuntos de datos mas pequeños que el original. En este sentido es importante la agrupación en «temas» o «familias» de datos.
El objetivo es generar «información de calidad» desestimando la información accesoria o redundante.

En la etapa de **preparación de datos** se procede a la **integración, limpieza, transformación, modelado y reportes**.

Las técnicas de preparación para la incorporación de nuevos datos a nuestras bases son: 
* Integración
* Limpieza del ruido
* Transformación
* Imputación de valores faltantes.

*Nota: Estas técnicas son obligatorias (o deberían serlo)*

#### **Integración**
Esta primera etapa mplica integrar datos de diferentes fuentes e incorporar los datos a formatos tabulares si no lo estuvieran.

#### **Limpieza**
En esta segunda etapa se discriminan los datos importantes de los accesorios y a la vez los veraces de los erróneos. 
Posteriormente se procede a desestimar o borrar aquellos datos que no serán utilizados y a validar los que se conservarán.

#### **Normalización**
En este paso se identifican aquellos valores iguales con notaciones diferentes y se los reescribe de una manera uniforme.
> Ejemplo: Calle S Martín, Calle Gral. San Martín, Calle José de San Martín…. = Calle Gral. José de San Martín.

#### **Imputación de Valores Faltantes**
La imputación de valores faltantes esta relacionada con la identificación de los casos en donde exista perdida o ausencia de datos. En estos casos será importante realizar acciones de reconstrucción, aunque no siempre es posible resolverlas.

#### **Transformación de Datos**
Este es el momento en que la información nueva será convertida a un formato compatible con base de datos. En este punto es crítico reducir el efecto distorsivo de la transformación.

#### **Modelado de Datos**
Se establecen las relaciones entre los datos, se determinan que entidades contienen datos maestros y cuáles contienen hechos, dando lugar a las dimensiones y las métricas.

#### **Reportes y Visualización**
Se genera Información a partir de los datos, esa información queda disponible para su análisis, que da lugar al Conocimiento.

#### **Claves subrogadas**
Una clave subrogada es un identificador único que se asigna a cada registro de una tabla. Puede obtenerse a partir de la conjunción de columnas ya preexistentes.

### **Recomendaciones Generales:**

* Lo simple es mejor.
* Evitar detalles superfluos.
* Crear variables adicionales antes de destruir las originales.
* Analizar los detalles antes de confiar en los resúmenes.
* Verificar la precisión de las variables derivadas y las recodificadas.

---
## Extracción, Transformación y Carga - ETL

### **Fase de Extracción**

Para llevar a cabo el proceso de se deben seguir los siguientes pasos:

* Extraer los datos desde los sistemas de origen.
* Analizar los datos extraídos obteniendo un chequeo.
* Interpretar este chequeo para verificar que los datos extraídos cumplen la pauta o estructura que se esperaba. Si no fuese así, los datos deberían ser rechazados.
* Convertir los datos a un formato preparado para iniciar el proceso de transformación.

### **Fase de Transformación**
La fase de transformación de un proceso ETL aplica una serie de reglas de negocio o funciones, sobre los datos extraídos para convertirlos en datos que serán cargados. Estas directrices pueden ser declarativas, pueden basarse en excepciones o restricciones pero, para potenciar su pragmatismo y eficacia, hay que asegurarse de que sean:

* Declarativas.
* Independientes.
* Claras.
* Inteligibles.
* Con una finalidad útil para el negocio.

---
## Outliers

Un elemento fundamental a descubrir dentro de las tareas de identificación del ruido son los valores atípicos o outliers.
Los Outliers son elementos que por su comportamiento se apartan notoriamente del comportamiento general. Esto se puede deber a un error en los datos o a un dato correcto que representa anomalías en la realidad.

---
### Diagrama de Caja

El Diagrama de Caja permite observar la distribución completa de los datos al mismo tiempo que su mediana y sus cuartiles. También, muestra los elementos que se escapan del universo, los outliers.

Se consideran outliers a los datos que son menores a la cota mínima o mayores a la cota máxima

Siendo
* Cota mínima = Q1 - 1.5 x IQR
* Cota máxima = Q3 + 1.5 x IQR

*IQR (rango intercuartil) = Q3 - Q1*

---
### Regla de las tres sigmas

La Regla de las Tres Sigmas se basa en el valor promedio y la desviación estándar para obtener el rango, fuera del cual, podemos asumir que un valor es atípico.

* Cota mínima = Promedio – 3 * Desviación Estándar
* Cota máxima = Promedio + 3 * Desviación Estándar

*Nota: Para usar el método de las 3 sigmas, los datos deben seguir una distribución normal*

---
---
# SQL

---
### Índices
Los índices de las tablas ayudan a indexar el contenido de diversas columnas para facilitar la búsquedas de contenido de cuando se ejecutan consultas sobre esas tablas.<br>
La creación de índices **optimiza el rendimiento de las consultas y a su vez el de la BBDD**, pueden agregarse índices en caso de tablas puentes donde no se ha solucionado el problema de indexación aplicado claves concatenadas.

Cuando se agrega una primary key a una tabla, se genera un índice agrupado.

```sql
CREATE TABLE carrera (
	idCarrera INT NOT NULL AUTO_INCREMENT,
	nombre VARCHAR (20) NOT NULL,
	PRIMARY KEY (idCarrera) --Aquí al crear una PK, SQL además crea un índice agrupado.
);
```

Para crear un índice podemos ejecutar la siguiente sentencia SQL:

```sql
CREATE INDEX nombre_indice ON nombre_tabla(nombre_columna);

```

Para eliminar un índice podemos ejecutar la siguiente sentencia SQL:
```sql
DROP INDEX nombre_indice;

```

Cuando hacemos una consulta sobre un campo sin índices, el motor busca la condición de forma exhaustiva registro a registro para quedarse con aquellos que la cumplan. Sí por el contrario, contamos con una tabla de índices, esa busqueda se de forma más óptima, ya que se tienen conocimiento de la ubicación de cada registro.

Podemos tener los siguientes tipos de índices en una tabla de MySQL:

- Únicos.<br>
- Primarios.<br>
- Ordinarios.<br>
- De texto completo.<br>
- Parte de campos o columnas.<br>

---
## Formas Normales

Las formas normales son conjuntos de criterios que utilizamos para diseñar la estructura de las bases de datos. Para mejorar el desempeño de una base de datos, así como evitar redundancia en la información que contiene y, en consecuencia, generar condiciones para un mejor diseño, se deben conocer las formas de normalización y condiciones en las que la desnormalización es recomendable.<br>

---

#### **Primera Forma Normal (1FN)**
Una relación se encuentra en 1FN sólo si cada uno de sus atributos contiene un único valor para un registro determinado.

En el siguiente ejemplo la tabla no cumple la **1FN** dado que en la columna sucursal hay mas de 1 valor.

|codigo | Nombre |  Apellido | Sucursal |
|-------|--------|-----------|----------|
|3467   | Pepe   | Argento   | a, b, c  |
|3817   | Naruto | Uzumaki   | b, d     |
|1155   | Sakura | Kinomoto  | d, e     |

Para lograr que se cumpla la 1° forma normal se crean dos tablas, donde vamos a poder ver que cada registro guarda un solo valor. De esta manera, el esquema cumple la 1FN.<br>
**Tabla 1:**

|codigo | Nombre |  Apellido |
|-------|--------|-----------|
|3467   | Pepe   | Argento   |
|3817   | Naruto | Uzumaki   |
|1155   | Sakura | Kinomoto  |


**Tabla 2:**
|codigo | Sucursal |
|-------|----------|
|3467   | a        |
|3467   | b        |
|3467   | c        |
|3817   | b        |
|3817   | d        |
|1155   | d        |
|1155   | e        |

---
#### **Segunda Forma Normal (2FN)**

Una relación se encuentra en 2FN sólo si se cumple 1FN y todos sus atributos no clave dependen en forma completa de la clave.

Supongamos que tenemos una tabla donde guardamos cuántas ventas se hizo a cada cliente en cada sucursal, y contamos con un esquema como el que se muestra a continuación:

|codigo_cliente|codigo_sucursal|Apellido_y_Nombre|Sucursal|Ventas|
|--------------|---------------|-----------------|--------|------|
|2000|100|Lamas Lorenzo|suc.1|4|
|2001|101|Gimenez Susana|Suc.2|3|
|2002|105|Black Jack|Suc. 6|10|

La clave de esta tabla, está formada por los campos Codigo_Cliente y Codigo_Sucursal y la relación se encuentra en 1FN, pero:
1. Apellido_Nombre sólo depende de Codigo_Cliente.<br>
2. Sucursal sólo depende de Codigo_Sucursal.<br>
3. Ventas depende de la clave completa Codigo_Cliente + Codigo_Sucursal.<br>

Por lo que ocurre en 1 y 2 no se cumple con la 2FN.

Para que se cumpla la 2FN se debe generar un modelo de 3 tablas como se muestra a continuación:
|codigo_cliente|Apellido_y_Nombre|
|--------------|-----------------|
|2000|Lamas Lorenzo|
|2001|Gimenez Susana|
|2002|Black Jack|

|codigo_sucursal|Sucursal|
|---------------|--------|
|100|suc.1|
|101|Suc.2|
|105|Suc. 6|


|codigo_cliente|codigo_sucursal|Ventas|
|--------------|---------------|------|
|2000|100|4|
|2001|101|3|
|2002|105|10|

---
#### **Tercera Forma Normal (3FN)**
Una relación se encuentra en 3FN sólo si se cumple 2FN y los campos no clave dependen únicamente de la clave o los campos no clave no dependen unos de otros.<br>

|codigo_cliente|Nombre_y_Apellido|Localidad|Provincia|
|--------------|-----------------|---------|---------|
|2000|Lamas Lorenzo|Lomas|Buenos Aires|
|2001|Gimenez Susana|San Pedro| Jujuy|
|2002|Black Jack|Rio Grande|Tierra del Fuego|
|2003|Joestar Joseph|Mar del Plata|Buenos Aires|

Aunque cumple con la 2FN, la Provincia está tambien ligada a la Localidad, con lo que no se cumple la 3FN.

Para que se cumpla la 3FN:
|codigo_cliente|Nombre_y_Apellido|Localidad|
|--------------|-----------------|---------|
|2000|Lamas Lorenzo|Lomas|
|2001|Gimenez Susana|San Pedro|
|2002|Black Jack|Rio Grande|
|2003|Joestar Joseph|Mar del Plata|

|Localidad|Provincia|
|---------|---------|
|Lomas|Buenos Aires|
|San Pedro| Jujuy|
|Rio Grande|Tierra del Fuego|
|Mar del Plata|Buenos Aires|

---
#### **Cuarta Forma Normal (4FN)**
Una relación se encuentra en 4FN sólo si se cumple 3FN y no posee dependencias multivaluadas no triviales.<br>
Una tabla con una dependencia multivaluada es una donde la existencia de dos o más relaciones independientes muchos a muchos causa redundancia; y es esta redundancia la que es suprimida por la cuarta forma normal.

Por Ejemplo, observemos la siguiente tabla de permutaciones de envíos de pizzas:<br>

|Restaurante|Variedad de Pizza|Área de envío|
|-----------|-----------------|-------------|
|Vincenzo's Pizza	|Corteza gruesa|	Springfield|
Vincenzo's Pizza	|Corteza gruesa|	Shelbyville|
Vincenzo's Pizza	|Corteza fina|	Springfield|
Vincenzo's Pizza	|Corteza fina|	Shelbyville|
Elite Pizza	|Corteza fina| Capital City|
Elite Pizza	|Corteza rellena| Capital City|
A1 Pizza	|Corteza gruesa|	Springfield|
A1 Pizza	|Corteza gruesa|	Shelbyville|
A1 Pizza	|Corteza gruesa|	Capital City|
A1 Pizza	|Corteza rellena| Springfield|
A1 Pizza	|Corteza rellena| Shelbyville|
A1 Pizza	|Corteza rellena| Capital City|

Notar que las variedades de pizza que un restaurante ofrece son independientes de las áreas a las cuales el restaurante envía, por lo que hay redundancia en la tabla.

Para que se cumpla la 4FN vamos a generar dos tablas: Variedades por restaurante y Áreas de envío por restaurante<br>

**Variedades por restaurante**<br>

|Restaurante	|Variedad de pizza|
|---------------|-----------------|
|Vincenzo's Pizza|	Corteza gruesa|
|Vincenzo's Pizza|	Corteza fina|
|Elite Pizza|	Corteza fina|
|Elite Pizza|	Corteza rellena|
|A1 Pizza|	Corteza gruesa|
|A1 Pizza|	Corteza rellena|

**Áreas de envío por restaurante**

|Restaurante|	Área de envío|
|-----------|----------------|
|Vincenzo's Pizza|	Springfield|
|Vincenzo's Pizza|	Shelbyville|
|Elite Pizza|	Capital City|
|A1 Pizza|	Springfield|
|A1 Pizza|	Shelbyville|
|A1 Pizza|	Capital City|

---
#### **Quinta Forma Normal (5FN)**

Una relación se encuentra en 5FN sólo si se cumple 4FN y cada dependencia de unión en ella es implicada por las claves candidatas.

De Wikipedia: La quinta forma normal (5FN), también conocida como forma normal de proyección-unión (PJ/NF), es un nivel de normalización de bases de datos diseñado para reducir redundancia en las bases de datos relacionales que guardan hechos multi-valores aislando semánticamente relaciones múltiples relacionadas. Una tabla se dice que está en 5NF si y solo si está en 4NF y cada dependencia de unión (join) en ella es implicada por las claves candidatas.

Ejemplo:

|Asignatura	|Profesor|Semestre|
|-----------|-------|--------|
|Computación|Anshika|1|
|Computación|John|1|
|Matemática| John|1|
|Matemática|Akash|2|
|Química|Praveen|1|

Para hacer que se cumpla la 5ta forma normal, podemos descomponer en tres relaciones P1, P2 y P3:

**P1<br>**

|Semestre |Asignatura|
|---------|----------|
|1|	Computación|
|1|	Matemática|
|1|	Química|
|2|	Matemática|

**P2<br>**

|Asignatura|Profesor|
|----------|--------|
|Computación|Anshika|
|Computación|John|
|Matemática|John|
|Matemática|Akash|
|Química|Praveen|

**P3<br>**

|Semestre|Profesor|
|--------|--------|
|1|	Anshika|
|1|	John|
|1|	John|
|2|	Akash|
|1|	Praveen|


---

## Modelos de datos

#### **Modelo estrella**

Es muy común encontrar en herramientas de BI, modelos de este tipo, donde las tablas de hecho son centrales, mientras que las tablas de maestros, que también son denominadas de dimensiones, están alrededor.
La nomenclatura típica, es anteponer “Fact_” a las tablas de hechos, y “Dim_” a las tablas de dimensiones o maestros.

#### **Modelos de Copo de Nieve**

El esquema de copo de nieve consta de una tabla de hechos que está conectada a muchas tablas de dimensiones, que pueden estar conectadas a otras tablas de dimensiones a través de una relación de muchos a uno.<br>
Las tablas de un esquema de copo de nieve generalmente se normalizan en la tercera forma normal. Cada tabla de dimensiones representa exactamente un nivel en una jerarquía.<br>

#### **Diferencias entre estrella y copo de nieve**
La principal diferencia entre el esquema de estrella y el esquema de copo de nieve es que la tabla de dimensiones del esquema de copo de nieve se mantiene en forma normalizada para reducir la redundancia. La ventaja aquí es que tales tablas (normalizadas) son fáciles de mantener y ahorran espacio de almacenamiento. Sin embargo, también significa que se necesitarán más combinaciones para ejecutar la consulta. Esto afectará negativamente al rendimiento del sistema. 

* Copo nieve 
    * Dimensiones normalizadas (**pro**)
    * Son fáciles de mantener (**pro**)
    * Ahorran espacio de almacenamiento (**pro**)
    * Se necesitan mas combinaciones para ejecutar la query --> Baja del rendimiento (**contra**)

---
## Carga de datos

#### Tabla de auditoria
La tabla de auditoría es una dimensión especial que se ensambla en el sistema ETL para cada tabla de hechos. La dimensión de auditoría contiene el contexto de metadatos en el momento en que se crea una fila específica de la tabla de hechos. Se podría decir se elevan metadatos a datos reales! Para visualizar cómo se crean las filas de dimensión de auditoría, imagine esta tabla de hechos de envíos se actualiza una vez al día a partir de un archivo por lotes. Supongamos que hoy Tiene una carga perfecta sin errores marcados. En este caso, generaría solo una fila de dimensión de auditoría, y se adjuntaría a cada fila de hechos cargada hoy.<br>
Todas las categorías, puntuaciones y números de versión serían los mismos.


#### Tabla de errores
La tabla de errores es un esquema dimensional centralizado cuyo propósito es registrar cada evento de error lanzado por una pantalla de en cualquier lugar de la canalización de ETL. Aunque nos enfocamos en el procesamiento ETL, este enfoque se puede usar en aplicaciones genéricas de integración de datos (DI) donde los datos se transfieren entre aplicaciones.<br>
La tabla principal es la tabla de hechos de eventos de error. Sus registros se componen de cada error arrojado (producido) por una pantalla en cualquier parte del sistema ETL. Así cada error de pantalla produce exactamente una fila en esta tabla, y cada fila en la tabla corresponde a un error observado.<br>
La tabla de hechos de eventos de error también tiene una clave principal de una sola columna, que se muestra como la clave de evento de error. Esta clave sustituta, como las claves primarias de la tabla de dimensiones, es un simple entero asignado secuencialmente a medida que se agregan filas a la tabla. Esta columna clave es necesaria en aquellas situaciones en las que se añade una enorme cantidad de filas de error a la tabla. ¡¡Esperemos que esto no suceda!!.

---
### **TRIGGERS**
Un trigger es un objeto con nombre dentro de una base de datos el cual se asocia con una tabla y se activa cuando ocurre en ésta un evento en particular.

Cada trigger queda asociado a una tabla, la cual deb ser permanente, no puede ser una tabla TEMPORARY ni una vista.

El trigger puede entrar en acción :
* antes (BEFORE)
* después (AFTER).

Se puede definir que clase de acción activará el trigger:
* INSERT
* UPDATE
* DELETE

No puede haber dos disparadores en una misma tabla que correspondan al mismo momento y sentencia. Por ejemplo, no se pueden tener dos disparadores BEFORE UPDATE. Pero sí es posible tener los disparadores BEFORE UPDATE y BEFORE INSERT o BEFORE UPDATE y AFTER UPDATE.

Ejemplo:

```SQL

CREATE TABLE alumno (
cedulaIdentidad INT NOT NULL AUTO_INCREMENT,
nombre VARCHAR(20),
apellido VARCHAR(20),
fechaInicio DATE,
PRIMARY KEY (cedulaIdentidad)
)

CREATE alumnos_auditoria (
id_auditoria INT NOT NULL AUTO_INCREMENT,
cedulaIdentidad_auditoria INT,
nombre_auditoria VARCHAR(20),
apellido_auditoria VARCHAR(20),
fechaInicio_auditoria DATE,
usuario VARCHAR (20),
fecha DATE,
PRIMARY KEY (id_auditoria)
)

CREATE TRIGGER auditoria AFTER INSERT ON alumno
FOR EACH ROW
INSERT INTO alumnos_auditoria (cedulaIdentidad_auditoria, nombre_auditoria, apellido_auditoria, fechaInicio_auditoria, usuario, fecha)
VALUES (NEW.cedulaIdentidad_auditoria, NEW.nombre_auditoria, NEW.apellido_auditoria, NEW.fechaInicio_auditoria,CURRENT_USER,NOW())
```

---
### **Variables**

MySQL reconoce diferentes tipos de variables

**Variables definidas por el usuario**
* Se identifican por un símbolo @
* Para inicializarlas se usa la clausula SET --> ` SET @edad=45;`

```SQL

SET @carrera1 = 'Data Science',@carrera2 = 'Full Stack'

SELECT @carrera1, @carrera2


```

**Variables Locales**
* No necesitan el prefijo @ en sus nombres
* Se declaradan antes de que puedan ser usadas (statement DECLARE)
* Se pueden utilizar de dos maneras:
    * Utilizando la declaración DECLARE.
    * Como un parámetro dentro de una declaración STORED PROCEDURE. 
* Cada variable existe en el espacio delimitado por el bloque BEGIN - END.




```SQL

-- Más abajo daremos más detalles sobre los procedimientos almacenados.
DELIMITER $$

CREATE PROCEDURE GetTotalAlumnos()
BEGIN
	DECLARE totalAlumnos INT DEFAULT 0;
    
    SELECT COUNT(*) 
    INTO totalAlumnos
    FROM alumnos;
    
    SELECT totalAlumnos;
END$$

DELIMITER ;

CALL GetTotalAlumnos()

```

**Variables del sistema**
* Se establecen normalmente al inicio del servidor
* Se idenfican con un doble signo @@ o utilizando las palabras GLOBAL o SESSION en la sentencia SET. 
* Para ver las variables de sistema en uso dentro de una sesión o en el servidor, se utiliza la sentencia SHOW VARIABLES.<br>

```SQL
SHOW VARIABLES; -- Muestra todas las variables.

SHOW SESSION VARIABLES; 
SHOW LOCAL VARIABLES ;
SHOW VARIABLES;

-- Se puede utilizar el operador LIKE '%Variable%' para acceder a una variable en particular.
-- Ejemplo:

SHOW SESSION VARIABLES LIKE 'version';

SHOW SESSION VARIABLES LIKE 'version_comment';

```

---

### **Funciones**

Las funciones  nos permiten procesar y manipular datos de forma procedural de un modo muy eficiente. Existen funciones integradas dentro de SQL, algunas de las que utilizamos son AVG, SUM, CONCATENATE, etc.<br>

Para poder crear funciones se deben tener los permisos INSERT y DELETE.<br>

**EJEMPLO 1:**
```SQL


-- Esta función recibe una fecha de ingreso y cálcula la antigüedad en meses del alumno.

DELIMITER $$
CREATE FUNCTION antiguedadMeses(fechaIngreso DATE) RETURNS INT -- Asignamos un nombre, parámetros de la función y tipo de dato a retornar.

-- La función se define entre BEGIN - END.
BEGIN
	DECLARE meses INT; -- Declaramos las variables que van a operar en la función
	SET meses = TIMESTAMPDIFF(MONTH, fechaIngreso, DATE(NOW())); - -- Definimos el script.
    RETURN meses; -- Retornamos el valor de salida que debe coincidir con el tipo declarado en CREATE
END$$

DELIMITER ;

SELECT * , antiguedadMeses(fechaIngreso) 

FROM alumnos


```

**EJEMPLO 2**

```sql

-- Esta función recibe el id de un alumno y devuelve su antigüedad en meses.

DELIMITER $$
CREATE FUNCTION antiguedadMeses2(id INT) RETURNS INT
BEGIN
	DECLARE meses INT;
    SELECT TIMESTAMPDIFF(MONTH, fechaIngreso, DATE(NOW()))
    INTO meses
    FROM alumnos
    WHERE idAlumno = id;
    RETURN meses;
END$$

DELIMITER ;

SELECT antiguedadMeses2(130)

```

---
### Procedimientos Almacenados
Es un objeto que se crea con la sentencia CREATE PROCEDURE y se invoca con la sentencia CALL. Un procedimiento puede tener cero o muchos parámetros de entrada y cero o muchos parámetros de salida.<br>
Para definir un procedimiento almacenado es necesario modificar temporalmente el carácter separador que se utiliza para delimitar las sentencias SQL.<br>


```SQL
-- Este procedimiento lista los alumnos pertenecientes a una carrera.

DELIMITER $$
CREATE PROCEDURE listarCarrera( IN nombreCarrera VARCHAR(25))
BEGIN
	SELECT CONCAT(alumnos.nombre,' ',apellido) AS Alumno, cohorte
	FROM alumnos
	INNER JOIN cohortes
	ON cohorte = idCohorte
	INNER JOIN carreras 
	ON carrera = idCarrera
	WHERE carreras.nombre=nombreCarrera;
END;

DELIMITER

CALL listarCarrera('Data Science')

```

---
### **Tipos de Join en MySQL**

* **Inner Join:** Devuelve los resultados de la intersección de las tablas (donde hay *match*)
* **Left Join:** retorna todos los resultados de la  tabla de la derecha, y las coincidencias de la de la izquierda. Si no hay match, retorna NULL en esa fila
* **Right Join:** Similar que Left join, pero mirando desde la derecha (casi  no se utiliza)
* **Full outer join:** Es como la suma de las dos anteriores. Queremos tanto las filas de la A como las de B, tanto si hay match como si no (evidentemente cuando haya match la consulta devolverá todos los campos de A y B que hayamos indicado, cuando no, la consulta devolverá sólo los campos de A o B).

---
---
# CHEAT SHEET MYSQL
> Deshabilitar el SAFEMODE
```sql
SET SQL_SAFE_UPDATES=0;
```

> Crear una base de datos (si no existe)
```sql
CREATE DATABASE IF NOT EXISTS db_name; 
```

> Usar la base de datos
```sql
USE db_name;
```

> Mostrar las bases de datos existentes
```sql
SHOW DATABASES;
```

> Crear una tabla, indicando la primary key
```sql
CREATE TABLE IF NOT EXISTS animal(
    id int not null auto_increment primary key,
    tipo varchar(50),
    estado varchar(50)
)engine=InnoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;
```

> Crear una tabla  y luego modificarla para agregar primary key y auto_increment
```sql
CREATE TABLE IF NOT EXISTS animal(
    id int not null,
    tipo varchar(50),
    estado varchar(50)
)engine=InnoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;

-- add primary key
ALTER TABLE animal ADD PRIMARY KEY(id);

-- add auto_increment 
ALTER TABLE animal MODIFY COLUMN id int auto_increment;
```
> Cargar datos en una tabla
```sql
INSERT INTO animal
    (tipo, raza,altura_cm, peso_gr, estado)
VALUES ("Perro", "Pug", 38.2, 6300, "Jugueton");
```

> Cargar datos desde un csv (En Workbench)
```sql
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/animales.csv' 
INTO TABLE animal
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;
```

> Mostrar todos los elementos de una tabla
```sql
SELECT * FROM animal;
```

> Mostrar todos los elementos de una tabla que cumplan con una característuca
```sql
SELECT * FROM animal where tipo='Perro';
```

> Mostrar el codigo de como se ha creado una tabla
```sql
SHOW CREATE TABLE animal;
```

> Renombrar una columna de una tabla
```sql
ALTER TABLE animal RENAME COLUMN id to IdAnimal;
```

> Agregar nuevas columnas en una tabla
```sql
ALTER TABLE animal 
    ADD altura_cm DECIMAL(6,2) NOT NULL DEFAULT 0 AFTER tipo, 
    ADD peso_gr DECIMAL(10,2) NOT NULL DEFAULT 0 AFTER altura_cm,
    ADD raza varchar(30) NOT NULL DEFAULT "raza sin definir" after tipo;
```

> Modificar comas por puntos en un campo
```sql
-- Imaginemos que tenemos la siguiente tabla
CREATE TABLE medida(
    id int not null auto_increment primary key,
    latitud varchar(30),
    longitud varchar(30)
)engine=InnoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;

-- Porque es un varchar si debiera ser un decimal o un float?? 
-- Porque probablemente este utilizando como separador decimal una coma ',' y no un punto '.'

-- Vamos a cambiar el punto por coma, pero primero vamos a crear dos columnas auxiliares
ALTER TABLE medida 
ADD lat_aux FLOAT NOT NULL DEFAULT 0 AFTER latitud,
ADD lon_aux DECIMAL(15,10) NOT NULL DEFAULT 0 AFTER longitud;

-- Primero en los valores originales, buscamos espacios en blanco y los reemplazamos por cero
UPDATE medida SET longitud='0' where TRIM(longitud)="";
UPDATE medida SET latitud='0' where TRIM(latitud)="";

-- Ahora rellenamos las nuevas columnas, cambiando punto por coma
UPDATE medida SET lat_aux=REPLACE(latitud, ',', '.');
UPDATE medida SET lon_aux=REPLACE(longitud, ',', '.');

-- Una vez que verificamos que todo salio ok, dropeamos las columnas originales
ALTER TABLE animal
DROP latitud, DROP longitud;

-- Renombramos las columnas
ALTER TABLE animal
RENAME COLUMN lat_aux to latitud,
RENAME COLUMN lon_aux to longitud;

```

> Cambiar el datatype de una columna
```sql
ALTER TABLE animal 
modify latitud DECIMAL(15,10);   -- Cambia de float a decimal
```

> Verificar si un campo tiene duplicados
```sql
SELECT raza, COUNT(raza) 
FROM animal
GROUP BY raza
HAVING COUNT(raza) > 1;
```

---
### Filtros con Where

> Select con where 
```sql
-- AND
SELECT column1, column2
FROM table_name
WHERE condition1 AND condition2;

-- OR
SELECT column1, column2
FROM table_name
WHERE condition1 OR condition2;

-- NOT
SELECT column1, column2
FROM table_name
WHERE NOT condition1;

```

> Operadores para la clausula WHERE
```sql
=       equal
>       greater than
<       less than
>=      greater than or equal
>=      less than or equal
<>      not equal (en algunas versiones es !=)
BETWEEN Between un cierto rango
LIKE    Buscar un patrón
IN 	    Para especificar múltiples valores para una columna

```

--- 
#### Group by
```sql
select Cantidad, count(Cantidad)
from venta
group by Cantidad
order by count(Cantidad);
```

> Imaginemos que queremos mostrar los outliers, y hemos almacenado las cotas inferior y superior en variables
```sql
select IdSucursal, sum(Precio*Cantidad) as ventas_totales
from venta
where Precio>=@cota_inf_precio and Precio<=@cota_sup_precio
group by IdSucursal
order by ventas_totales desc;
```

#### Group by con JOIN
```sql
select suc.Sucursal as sucursal, can.Canal as canal, sum(v.Precio*v.Cantidad) as ventas
from venta as v
inner join sucursal as suc on v.IdSucursal=suc.IdSucursal
inner join canal_venta as can on v.IdCanal=can.IdCanal
group by sucursal, canal
having ventas> 5000000  -- having se usa cuando filtramos con funciones de agregacion
order by sucursal, canal, ventas;
```


#### SUBQUERYS
> Suponer que tenemos dos tablas, que tienen un campo en común.
> Como podemos verificar si hay algun dato que este en una y no este en la otra?

```sql
-- Vamos a verificar si hay algun empleado cuya sucursal no se encuentra en la lista de sucursales
select distinct Sucursal from empleado
where Sucursal not in (select Sucursal from sucursal);
```

> Cargar datos en una tabla a partir de los unicos de otra tabla
```sql
insert into dim_producto
select IdProducto, Concepto, IdTipoProducto, Precio
from producto
where IdProducto in (select distinct IdProducto from fact_venta);
```