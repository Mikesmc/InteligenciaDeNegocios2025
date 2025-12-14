--Dim producto

--Origen de datos stage northwind

SELECT [Producto_Codigo]
      ,CAST([Producto_Nombre] as nvarchar(40)) AS [Producto_Nombre]
      ,CAST([CategoriaProducto_Nombre] AS nvarchar (15)) AS [Categoria_nombre]
      ,CAST([ProveedorNombre] AS nvarchar (40)) AS [ProveedorNombre]
      ,[ETLLoad]
      ,[ETLExecution]
  FROM [Stage_Northwind].[dbo].[Stage_Producto]

INSERT INTO ETLExecution(UserName, MachineName, PackageName, ETLLoad)
                VALUES(?,?,?,GETDATE())


SELECT TOP(1) ID FROM ETLExecution
WHERE PackageName = ?
ORDER BY ID DESC

UPDATE ETLExecution
SET [ETLCountNewRegister] = ?,
    [ETLCountModifiedRegister] = ?
WHERE ID = ?


UPDATE ETLExecution
SET [ETLCountRows]=([ETLCountNewRegister]+[ETLCountModifiedRegister])
WHERE ID = ?
