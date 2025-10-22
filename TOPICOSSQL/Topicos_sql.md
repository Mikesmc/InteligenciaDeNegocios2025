# Topicos SQL ( T-SQL )

```SQL
if not exists (select name from sys.databases where name = N'miniDB')
begin 
	 create database miniDB
	 collate latin1_general_100_CI_AS_SC_UTF8;
end
go

USE miniDB;
go

-- Creacion de tabla 
if OBJECT_ID ('clientes', 'U') is not null drop table clientes;

create table clientes(
	IdCliente int not null, 
	Nombre nvarchar(100),
	Edad int,
	Ciudad nvarchar(100),
	constraint pk_clientes
	primary key (IdCliente)
);

if OBJECT_ID ('productos', 'U') is not null drop table productos;

create table productos(
	Idproducto int primary key, 
	NombreProducto nvarchar(200),
	Categoria nvarchar(200),
	Precio decimal(12,2)
)
GO


/* 
 Insercion de registros 
*/

insert into clientes
values(1, 'Ana Torres', 25, 'Ciudad de Mexico');

insert into clientes (IdCliente, Nombre, Edad, Ciudad)
values (2, 'Luis Perez', 34, 'Guadalajara');


insert into clientes (IdCliente, Edad, Nombre, Ciudad)
values (3, 29, 'Soyla Vaca', null);



/* 
 Insercion de registros 
*/

insert into clientes
values(1, 'Ana Torres', 25, 'Ciudad de Mexico');

insert into clientes (IdCliente, Nombre, Edad, Ciudad)
values (2, 'Luis Perez', 34, 'Guadalajara');

insert into clientes (IdCliente, Nombre, Edad)
values (4, 'Natacha',42);

insert into clientes (IdCliente, Nombre, Edad, Ciudad)
values (5, 'Sofia Lopez', 19, 'Chapulhuacan'),
		(6, 'Laura Hernandez', 38, null),
		(7, 'Virtor Trujillo', 25, 'Zacualtipan');

go

create or alter procedure sp_add_customer
@Id int, @Nombre nvarchar(100), @Edad int, @Ciudad nvarchar(100)
as
begin
	insert into clientes (IdCliente, Nombre, Edad, Ciudad)
	values (@Id, @Nombre, @Edad, @Ciudad);
end;
go

exec sp_add_customer 8, 'Carlos Ruiz', 41, 'Monterrey';
exec sp_add_customer 9, 'Jose Perez', 74, 'Salte si Puedes';


select *
from clientes

select count(*) as [Numero de clientes] from clientes

--Mostrar todos los clientes ordenados por edad de menor a mayor 

select Nombre as [Cliente], Edad, upper(Ciudad) as [Ciudad]
from clientes
order by Edad desc;

-- Listar los clientes que viven en guadalajara

select Nombre as [Cliente], Edad, upper(Ciudad) as [Ciudad]
from clientes
where Ciudad = 'Guadalajara';

--Listar los clientes con una edad mayor o igual a 30

select upper(Nombre) as [Cliente], Edad, upper(Ciudad) as [Ciudad]
from clientes
where Edad>=30

-- Listar los clientes cuyas ciudad se anulan
select upper(Nombre) as [Cliente], Edad, upper(Ciudad) as [Ciudad]
from clientes
where Ciudad is null

-- Remplazar en la consulta la ciudades nulas por la palabra DESCONOCIDA(sin modificar los datos originales)

select upper(Nombre) as [Cliente], Edad, isnull(upper(Ciudad), 'DESCONOCIDO') as [Ciudad]
from clientes

--Selecciona los clientes que tengan edad entre 20 y 35 y que vivan en puebla o monterrey

select upper(Nombre) as [Cliente], Edad, isnull(upper(Ciudad), 'DESCONOCIDO') as [Ciudad]
from clientes
where Edad between 20 and 35
and 
Ciudad In ('Guadalajara', 'Chapulhuacan');

/* 
Actualizacion de datos
*/

select * from clientes

update clientes
set Ciudad = 'Xochitlan'
where  IdCliente=5;

update clientes
set Ciudad = 'Sin Ciudad'
where Ciudad is null;

update clientes
set Edad=30
where IdCliente between 3 and 6;

update clientes
set Ciudad = 'Metropoli'
where Ciudad in ('Ciudad de Mexico', 'Guadalajara', 'Monterrey')

update clientes
set Nombre = 'Juan Perez',
Edad = 27,
Ciudad = 'Ciudad Gotica'
where IdCliente = 2;

update clientes
set Nombre = 'Cliente Premium'
where Nombre like 'A%';

update clientes
set Nombre = 'Silver Customer'
where Nombre like '%er%';


update clientes
set Edad = (Edad * 2)
where edad >=30 and Ciudad = 'Metropoli';


/*   Eliminar Datos

*/


select * from clientes;


delete from	clientes
where Edad between 25 and 30;

delete clientes
where Nombre like '%r';

delete from clientes

/* 
=========Store procedure de update, delete, select==========
*/

--Modifica los datos por id
go 

create or alter procedure sp_update_customers
@id int, @nombre nvarchar(100),
@edad int, @ciudad nvarchar(100)
as
begin
update clientes
set Nombre = @nombre,
	Edad = @edad,
	Ciudad = @ciudad
where IdCliente = @id;
end;
go

select * from clientes

exec sp_update_customers 7,'Benito Lopez', 24, 'Lima los pies';

go
exec sp_update_customers
@ciudad ='Martinez de la torre', 
@edad =56,
@id= 3,
@nombre = 'Toribio Trompudo'


-- Ejercicio completo donde se pueda insertar datos en una tabla principal (encabezando) y una tabla detalle utilzando un sp.

--Tabla principal
create table ventas(
Idventa int identity(1,1) primary key,
Fechaventa datetime not null default getdate(),
Cliente nvarchar(100) not null,
Total decimal (10,2) null
);

--Tabla detalle
create table detalleVenta(
Iddetalle int identity (1,1) primary key,
Idventa int not null,
Producto nvarchar (100) not null,
Cantidad int not null,
Precio decimal (10,2),
constraint pk_detalle_venta
foreign key (Idventa)
references Ventas(Idventa)
);

-- Crear un tipo de tabla (table type)

-- Este tipo de tabla sirve como estructura para enviar detalles al sp

create type tipodetalleventas as table (
Producto nvarchar (100),
Cantidad int,
Precio decimal(10,2)
);

go
--Crear el store procedure 
-- El sp insertara el encabezado y luego todos los detalles utilizando el tipo de tabla 

create or alter procedure insertarventacondetalle
@Cliente nvarchar(100),
@Detalles tipodetalleventas readonly
as 
begin
	set nocount on;

	declare @Idventa int;
	begin try
		begin transaction;

		-- Insertar en la tabla principal
		insert into ventas (Cliente)
		values(@Cliente);

		--Obtener el id recien generado
		set @Idventa = SCOPE_IDENTITY();

		--Insertar los detalles (Tabla detalles)
		insert into detalleVenta  (Idventa, Producto, Cantidad,	Precio)
		select @Idventa, producto, cantidad, precio
		from @Detalles;

		-- Calcular el total en venta
		update ventas
		set Total = (select sum(Cantidad * Precio) from @Detalles)
		where Idventa = @Idventa;


		commit transaction;

end try
begin catch
	rollback transaction;
	throw;
end catch;

end;

-- Ejecutar el sp con datos de prueba 

--Declarar una variable tipo tabla
declare @Misdetalles as TipoDetalleVentas

-- Insertar productos en el type table

insert into @Misdetalles (Producto, Cantidad, Precio)
values 
('Laptop', 1, 15000),
('Mouse', 2, 300),
('Teclado', 1, 500),
('Pantalla', 5, 4500);

-- Ejecutar el sp
exec insertarventacondetalle @Cliente = 'Uriel Edgar', @Detalles = @Misdetalles


select * from ventas;
select * from detalleVenta;

```

## Funciones integradas (Built-in functions)

## Funciones de cadena 
```SQL
| Función                               | Descripción                                      | Ejemplo                                            |
| ------------------------------------- | ------------------------------------------------ | -------------------------------------------------- |
| `LEN(cadena)`                         | Longitud del texto (sin contar espacios finales) | `LEN('SQL Server ') → 10`                          |
| `LTRIM(cadena)`                       | Elimina espacios a la izquierda                  | `'  Hola' → 'Hola'`                                |
| `RTRIM(cadena)`                       | Elimina espacios a la derecha                    | `'Hola  ' → 'Hola'`                                |
| `LOWER(cadena)`                       | Convierte a minúsculas                           | `'HOLA' → 'hola'`                                  |
| `UPPER(cadena)`                       | Convierte a mayúsculas                           | `'hola' → 'HOLA'`                                  |
| `SUBSTRING(cadena, inicio, longitud)` | Extrae una parte del texto                       | `SUBSTRING('SQLServer', 4, 6) → 'Server'`          |
| `LEFT(cadena, n)`                     | Devuelve los primeros *n* caracteres             | `LEFT('SQLServer', 3) → 'SQL'`                     |
| `RIGHT(cadena, n)`                    | Devuelve los últimos *n* caracteres              | `RIGHT('SQLServer', 6) → 'Server'`                 |
| `CHARINDEX(subcadena, cadena)`        | Devuelve la posición de una subcadena            | `CHARINDEX('S', 'SQL Server') → 1`                 |
| `REPLACE(cadena, buscar, reemplazo)`  | Reemplaza texto                                  | `REPLACE('SQL 2022', '2022', '2025') → 'SQL 2025'` |
| `REVERSE(cadena)`                     | Invierte el texto                                | `REVERSE('SQL') → 'LQS'`                           |
| `CONCAT(val1, val2, ...)`             | Une varios valores en una sola cadena            | `CONCAT('Cliente ', Nombre)`                       |
| `CONCAT_WS(sep, val1, val2, ...)`     | Une valores con un separador                     | `CONCAT_WS('-', 'MX', '001') → 'MX-001'`           |



-- Funciones integradas (Built-in functions)

-- Funciones de cadena
select top 0
idCliente,
Nombre as [Nombre Fuente],
ltrim(upper (Nombre)) as Mayusculas,
LOWER (Nombre) as Minuscula,
Len (Nombre) as Logitud,
SUBSTRING (Nombre, 1,3) as prefijo,
ltrim(Nombre) as [Sin espacios izquierda],
concat (Nombre, ' - ', Edad) as [Nombre Edad],
upper(replace(trim(Ciudad), 'Chapulhuacan', 'Chapu')) as [Ciudad Normal]
into stage_clientes
from clientes;

alter table stage_clientes
add constraint pk_stage_clientes
primary key(idCliente)


-- Insertar datos a partir de una consulta (Insert - Select)
insert into stage_clientes (IdCliente, [Nombre Fuente], Mayusculas, Minuscula, Logitud, prefijo, [Sin espacios izquierda], [Nombre Edad], [Ciudad Normal])


select
idCliente,
Nombre as [Nombre Fuente],
ltrim(upper (Nombre)) as Mayusculas,
LOWER (Nombre) as Minuscula,
Len (Nombre) as Logitud,
SUBSTRING (Nombre, 1,3) as prefijo,
ltrim(Nombre) as [Sin espacios izquierda],
concat (Nombre, ' - ', Edad) as [Nombre Edad],
upper(replace(trim(Ciudad), 'Chapulhuacan', 'Chapu')) as [Ciudad Normal]
from clientes;



select * from clientes

select * from stage_clientes


insert into clientes (IdCliente, Nombre, Edad, Ciudad)
values (10, 'Luis Lopez', 45, 'Achichilco');


insert into clientes (IdCliente, Nombre, Edad, Ciudad)
values (11, 'German Gar', 32, 'Achichilco2');


insert into clientes (IdCliente, Nombre, Edad, Ciudad)
values (12, 'Roberto Estrada', 19, 'Chapulhuacan');


```

## Funciones de de fecha

| Función                               | Descripción                        |
| ------------------------------------- | ---------------------------------- |
| `GETDATE()`                           | Devuelve la fecha y hora actual    |
| `DATEADD(intervalo, cantidad, fecha)` | Suma o resta unidades de tiempo    |
| `DATEDIFF(intervalo, fecha1, fecha2)` | Calcula la diferencia entre fechas |

``` sql

--Funciones de fecha
go 

use NORTHWND;


select 
OrderDate,
GETDATE() as [Fecha Actual],
DATEADD(DAY, 10, OrderDate) as [FechaMAs10Dias],
DATEPART(QUARTER, OrderDate) as [Trimestre],
DATEPART(MONTH, OrderDate)[MesConNumero],
DATENAME ( MONTH, OrderDate)[MesConNombre],
DATENAME(WEEKDAY, OrderDate) as [NombreDia],
DATEDIFF(day, OrderDate, GETDATE()) as [DiasTranscurrido],
DATEDIFF(year, OrderDate, GETDATE()) as [AñosTranscurrido],
DATEDIFF(YEAR, '2003-07-13', GETDATE()) as [EdadGael],
DATEDIFF(YEAR, '1979-07-13', GETDATE()) as [EdadGallardo]
from Orders;


```

## Manejo de valores nulos

| Función                                 | Descripción                                 | Ejemplo                                                     |
| --------------------------------------- | ------------------------------------------- | ----------------------------------------------------------- |
| `ISNULL(expresión, valor)`              | Reemplaza `NULL` por un valor definido.     | `SELECT ISNULL(phone, 'Sin teléfono');`                     |
| `COALESCE(expresión1, expresión2, ...)` | Devuelve el primer valor no nulo.           | `SELECT COALESCE(email, secondary_email, 'No disponible');` |
| `NULLIF(expresión1, expresión2)`        | Devuelve `NULL` si los valores son iguales. | `SELECT NULLIF(salary, 0);`                                 |

```sql
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    SecondaryEmail NVARCHAR(100),
    Phone NVARCHAR(20),
    Salary DECIMAL(10,2),
    Bonus DECIMAL(10,2)
);

insert into Employees (EmployeeID, FirstName, LastName, Email, SecondaryEmail, Phone, Salary,Bonus)
values 
	(1, 'Ana', 'Lopez', 'ana.lopez@empresa.com',NULL,'555-2345', 12000, 100),
    (2, 'Carlos', 'Ramirez', NULL, 'c.ramirez@empresa.com', NULL, 9500, NULL),
    (3, 'Laura', 'Gomez', NULL, NULL, '555-8900', 0, 500),
    (4, 'Jorge', 'Diaz', 'jorge.diaz@empresa.com', NULL, NULL, 15000, 0);


-- Ejercicio1 - isnull
-- Mostrar el nombre completo del empleado junto con su numero de telefono, si no tiene telefono mostrar el texto "No disponible" 

select concat (FirstName, ' ', LastName) as [FullName],
	ISNULL(Phone, 'No disponible') as [Phone]
from Employees;

-- Ejercicio 2 mostrar el nombre del empleado y su contacto

select CONCAT(FirstName, ' ', LastName)as [Nombre Completo],
email, secondaryEmail,
coalesce(Email,SecondaryEmail, 'Sin correo') as Correo_Contacto
from Employees;

--Ejercicio 3. Nullif
-- Mostar el nombre del empleado, su salario y el resultado de nullif (salary, 0) para detectar quien tiene salario cero

select CONCAT(FirstName, ' ', LastName) as [Nombre Completo],
Salary,
nullif (salary, 0) as [SalarioEvaluado]
from Employees;

--Evita error de division por cero:

select FirstName,
	Bonus,
	(Bonus/nullif(salary, 0)) as Bonus_Salario

from Employees;

```

## Expresiones condicionales case

Permite crear condiciones dentro de una consulta 

Sintaxis :

```sql
 Case
	when condicion 1 then resultado1
	when condicion 2 then resultado2
	else resultado_por_defecto
end

```

