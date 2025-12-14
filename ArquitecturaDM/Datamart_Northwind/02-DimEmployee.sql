
select se.Empleado_Codigo,
cast (Empleado_NombreCompleto as nvarchar (61)) as Empleado_NombreCompleto,
cast (se.Empleado_Region as nvarchar (15)) as Empleado_Region,
cast (se.Empleado_Ciudad as nvarchar (15)) as Empleado_Ciudad,
CAST (se.Empleado_Pais as nvarchar (15)) as Empleado_Pais
from Stage_Northwind.dbo.Stage_Empleado as se



INSERT INTO [STAGE_NORTHWIND].[dbo].[Dim_Empleado_Mod]
([Empleado_Codigo], [Empleado_NombreCompleto], [Empleado_Ciudad], [Empleado_Region], [Empleado_Pais], [ETLLoad])
VALUES
(?, ?, ?, ?, ?, GETDATE())



UPDATE [DATAMART_NORTHWIND].[dbo].[Dim_Employee]
SET [DATAMART_NORTHWIND].[dbo].[Dim_Employee].full_name = S.Empleado_NombreCompleto,
	[DATAMART_NORTHWiND].[dbo].[Dim_Employee].region = S.Empleado_Region,
	[DATAMART_NORTHWiND].[dbo].[Dim_Employee].city = S.Empleado_Ciudad,
	[DATAMART_NORTHWiND].[dbo].[Dim_Employee].country = S.Empleado_Pais
FROM [DATAMART_NORTHWiND].[dbo].[Dim_Employee]
JOIN
	[STAGE_NORTHWIND].[dbo].[Stage_Empleado] AS S
	ON [DATAMART_NORTHWIND].[dbo].[Dim_Employee].employee_key = S.Empleado_Codigo
WHERE [DATAMART_NORTHWIND].[dbo].[Dim_Employee].employeeid_nk = ?


DELETE FROM Datamart_Northwind.dbo.dim_product;
DBCC CHECKIDENT ('Datamart_Northwind.dbo.dim_product', RESEED, 0);


--Insertar registros en Northwnd_Metadata en la tabla ETLExecution
INSERT INTO ETLExecution(UserName, MachineName, PackageName, ETLLoad)
                VALUES(?,?,?,GETDATE())

--Obtener el �ltimo ID de la tabla ETLExecution
SELECT TOP(1) ID FROM ETLExecution
WHERE PackageName = ?
ORDER BY ID DESC


--Actualizar la tabla ETLExecution
UPDATE ETLExecution
SET [ETLCountNewRegister] = ?,
    [ETLCountModifiedRegister] = ?
WHERE ID = ?


--Actualizar la tabla ETLExecution
UPDATE ETLExecution
SET [ETLCountRows]=([ETLCountNewRegister]+[ETLCountModifiedRegister])
WHERE ID = ?


select * from Datamart_northwind.dbo.dim_employee
select * from NORTHWIND_METADATA.dbo.ETLExecution
select * from Stage_Northwind.dbo.Dim_Empleado_Mod
