--- EN DF Load OrderDetails
CREATE TABLE dbo.OrderDetails (
    OrderID      int      NOT NULL,
    ProductID    int      NOT NULL,
    ProductName  nvarchar(40) NULL,
    UnitPrice    money    NOT NULL,
    Quantity     smallint NOT NULL,
    Discount     real     NOT NULL,
    ETLLoad      datetime NULL,
    ETLExecution int      NULL
);

-- DF Load OrderDetails
SELECT
    od.OrderID,
    od.ProductID,
    p.ProductName,
    od.UnitPrice,
    od.Quantity,
    od.Discount
FROM dbo.[Order Details] od
LEFT JOIN dbo.Products p ON od.ProductID = p.ProductID;
