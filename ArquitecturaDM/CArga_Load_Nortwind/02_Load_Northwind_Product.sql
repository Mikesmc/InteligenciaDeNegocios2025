-- CREAR LA TABLA PRODUCTS 
CREATE TABLE [dbo].[Products](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [nvarchar](40) NOT NULL,
	[CompanyName] [nvarchar] (40) NULL,
	[CategoryName] [nvarchar] (15) NULL,
	[QuantityPerUnit] [nvarchar](20) NULL,
	[UnitPrice] [money] NULL,
	[UnitsInStock] [smallint] NULL,
	[UnitsOnOrder] [smallint] NULL,
	[ReorderLevel] [smallint] NULL,
	[Discontinued] [bit] NOT NULL,
	[ETLLoad] datetime,
	[ETLExecution] int);
	--- CONSULTA DE ORIGEN 
select  pr.ProductID, pr.ProductName, sp.CompanyName ,ca.CategoryName, pr.QuantityPerUnit, pr.UnitPrice, pr.UnitsInStock,
	pr.ReorderLevel, pr.Discontinued
from (
	select ProductId, ProductName, QuantityPerUnit, Unitprice, UnitsInStock, UnitsOnOrder,
	ReorderLevel, Discontinued, CategoryId, SupplierId
	from NORTHWND.dbo.Products
) as pr
inner join
(
select CategoryId, CategoryName
from NORTHWND.dbo.Categories
)as ca
on pr.CategoryId = ca.CategoryId
inner join
(
select SupplierID, CompanyName
from NORTHWND.dbo.Suppliers
)
as sp
on sp.SupplierID = pr.SupplierID;