
use miniDB;
--1. Funciones de Cadenas
SELECT 
    IdCliente,
    UPPER(Nombre) AS NombreMayus,
    LEN(Nombre) AS LongitudNombre,
    SUBSTRING(Nombre, 1, 3) AS Iniciales,
    CONCAT(Nombre, ' - ', Ciudad) AS ClienteUbicacion
FROM Clientes;

--2. Funciones de Fechas
SELECT 
    Nombre,
    GETDATE() AS FechaActual,
    YEAR(GETDATE()) AS Año,
    MONTH(GETDATE()) AS Mes,
    DAY(GETDATE()) AS Día
FROM Clientes;

-- 3. Control de Valores Nulos
SELECT 
    IdCliente,
    Nombre,
    ISNULL(Ciudad, 'Sin Cuidad') AS CiudadCompleta
FROM Clientes;

--4.- Merge

-- Crear tabla temporal con nuevos datos
CREATE TABLE ClientesViejos (
    IdCliente INT,
    Nombre NVARCHAR(50),
    Edad INT,
    Ciudad NVARCHAR(50)
);

INSERT INTO ClientesViejos VALUES 
(2, 'Ana Torres', 34, 'Mexico'),  -- Actualización
(8, 'Laura Hernandez', 24, 'Neza');   -- Nuevo cliente

-- Sincronización con MERGE

MERGE Clientes AS T
USING ClientesViejos AS S
ON T.IdCliente = S.IdCliente
WHEN MATCHED THEN
    UPDATE SET 
        T.Edad = S.Edad,
        T.Ciudad = S.Ciudad
WHEN NOT MATCHED THEN
    INSERT (IdCliente, Nombre, Edad, Ciudad)
    VALUES (S.IdCliente, S.Nombre, S.Edad, S.Ciudad)
OUTPUT 
    $action AS TipoDeCambio,
    inserted.*;

select * from ClientesViejos


-- 5. Uso de CASE

SELECT 
    Nombre,
    Edad,
    CASE 
        WHEN Edad >= 35 THEN 'Mayor'
        WHEN Edad BETWEEN 25 AND 34 THEN 'Joven'
        ELSE 'Joven'
    END AS CategoriaEdad
FROM Clientes;