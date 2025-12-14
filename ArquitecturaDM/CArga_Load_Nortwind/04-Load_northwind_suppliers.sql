CREATE TABLE dbo.Shippers (
    ShipperID   int           NOT NULL,
    CompanyName nvarchar(40)  NOT NULL,
    Phone       nvarchar(24)  NULL,
    ETLLoad     datetime      NULL,
    ETLExecution int          NULL
);


-- EN DF Load Shippers

SELECT
    ShipperID,
    CompanyName,
    Phone
FROM dbo.Shippers;
