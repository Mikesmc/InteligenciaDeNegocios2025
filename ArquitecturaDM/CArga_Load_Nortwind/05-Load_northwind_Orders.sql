-- En load Northwind

CREATE TABLE dbo.Orders (
    OrderID       int           NOT NULL,
    CustomerID    nchar(5)      NULL,
    CustomerName  nvarchar(40)  NULL,
    EmployeeID    int           NULL,
    EmployeeName  nvarchar(50)  NULL,
    OrderDate     datetime      NULL,
    RequiredDate  datetime      NULL,
    ShippedDate   datetime      NULL,
    ShipperID     int           NULL,
    ShipperName   nvarchar(40)  NULL,
    Freight       money         NULL,
    ShipName      nvarchar(40)  NULL,
    ShipAddress   nvarchar(60)  NULL,
    ShipCity      nvarchar(15)  NULL,
    ShipRegion    nvarchar(15)  NULL,
    ShipPostalCode nvarchar(10) NULL,
    ShipCountry   nvarchar(15)  NULL,
    ETLLoad       datetime      NULL,
    ETLExecution  int           NULL
);

-- DF Load Orders
SELECT
    o.OrderID,
    c.CustomerID,
    c.CompanyName                AS CustomerName,
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    o.OrderDate,
    o.RequiredDate,
    o.ShippedDate,
    s.ShipperID,
    s.CompanyName                AS ShipperName,
    o.Freight,
    o.ShipName,
    o.ShipAddress,
    o.ShipCity,
    o.ShipRegion,
    o.ShipPostalCode,
    o.ShipCountry
FROM dbo.Orders   o
LEFT JOIN dbo.Customers c ON o.CustomerID = c.CustomerID
LEFT JOIN dbo.Employees e ON o.EmployeeID = e.EmployeeID
LEFT JOIN dbo.Shippers s  ON o.ShipVia    = s.ShipperID;
