/* ============================
Datmart de Ventass (northwind) - ddl construccion esquema start
Databases: Datamart_northwind

Autor: MASC
================================*/

/*
1) dim_customer (scd type 2)

================================*/
use Datamart_northwind
GO


if OBJECT_ID('dim_customer') is NULL
    BEGIN
        CREATE TABLE dim_customer(
            customer_key int IDENTITY(1,1) PRIMARY KEY,
            customer_nk NVARCHAR(10) NOT NULL, -- Clave natural (source)
            companyname NVARCHAR(40) NOT NULL,
            contact_name NVARCHAR(30) NULL,
            contact_title NVARCHAR(30) NULL,
            [address] NVARCHAR(60) NULL,
            city NVARCHAR(15) NULL,
            region NVARCHAR(15) NULL,
            postal_code NVARCHAR(10) NULL,
            country  NVARCHAR(15)NULL,
            start_date DATETIME NULL,
            end_date DATETIME NULL,
            is_current BIT NOT NULL DEFAULT (1)
            )
    END
GO

/*================================

2) dim_product (scd type 1)

================================*/

if OBJECT_ID('dim_product') is NULL
    BEGIN
        CREATE TABLE dim_product(
            product_key int IDENTITY(1,1) PRIMARY KEY,
            productid_nk INT NOT NULL, 
            product_name NVARCHAR(40) NOT NULL,
            category_name NVARCHAR(15) NOT NULL,
            supplier_name NVARCHAR(40) NOT NULL,
            quantity_per_unit NVARCHAR(20) NOT NULL,
            discontinued BIT NOT NULL
        );
    END
GO


/*================================

3) dim_employee (scd type 1)

================================*/

if OBJECT_ID('dim_employee') is NULL
    BEGIN
        CREATE TABLE dim_employee(
            employee_key int IDENTITY(1,1) PRIMARY KEY,
            employeeid_nk INT NOT NULL, 
            full_name NVARCHAR(61) NOT NULL,
            [title] NVARCHAR(30) NULL,
            hire_date DATE NULL
        );
    END
GO


/*================================

4) dim_shipper (scd type 1)

================================*/

if OBJECT_ID('dim_shipper') is NULL
    BEGIN
        CREATE TABLE dim_shipper(
            shipper_key int IDENTITY(1,1) PRIMARY KEY,
            shipperid_nk INT NOT NULL, 
            company_name NVARCHAR(40) NOT NULL
        );
    END
GO


/*================================

5) dim_date

================================*/
if OBJECT_ID('dim_date') is NULL
    BEGIN
        CREATE TABLE dim_date(
            date_key INT NOT NULL PRIMARY KEY, -- Formato YYYYMMDD
            [date] DATE NOT NULL, 
            [day] TINYINT NOT NULL, --1....31
            [month] TINYINT NOT NULL, --1....12
            MONTH_NAME VARCHAR(20) NOT NULL,
            [quarter] TINYINT NOT NULL, ---1....4
            [year] SMALLINT NOT NULL, 
            week_of_year TINYINT NOT NULL,
            is_weekend BIT NOT NULL
        );
    END
GO  

/*================================

6) dim_supplier (scd type 2)

================================*/

if OBJECT_ID('dim_supplier') is NULL
    BEGIN
        CREATE TABLE dim_supplier(
            supplier_key int IDENTITY(1,1) PRIMARY KEY,
            supplierid_nk INT NOT NULL, 
            company_name NVARCHAR(40) NOT NULL,
            contact_name NVARCHAR(30) NULL,
            contact_title NVARCHAR(30) NULL,
            [address] NVARCHAR(60) NULL,
            city NVARCHAR(15) NULL,
            region NVARCHAR(15) NULL,
            postal_code NVARCHAR(10) NULL,
            country  NVARCHAR(15)NULL,
            start_date DATETIME NOT NULL,
            end_date DATETIME NULL,
            is_current BIT NOT NULL DEFAULT (1)
        );
    END



/*================================

7) fact_sales (grano : linea de pedido (pedido - producto))

================================*/

if OBJECT_ID('fact_sales') is NULL
    BEGIN
        CREATE TABLE fact_sales(
            fact_sales_key begint IDENTITY(1,1) PRIMARY KEY,

            -- Foreign Keys de Dimensiones
            orderid_date_key INT NOT NULL,
            customer_key INT NOT NULL,
            product_key INT NOT NULL,
            employee_key INT NOT NULL,
            shipper_key INT NOT NULL,
            supplier_key INT NOT NULL,
            order_number INT NOT NULL,  -- Numero de pedido (orderid)

            -- Medidas
            order_qty INT NOT NULL,
            unit_price decimal(19,4) NOT NULL,
            discount decimal(5,4) NOT NULL, -- [0.0000 - 1.0000]
            extended_amount  as (CAST(order_qty * unit_price * (1 - discount) as decimal(19,4))) PERSISTED,

            --checks 
            CONSTRAINT chk_fact_sales_qty_positive CHECK (order_qty > 0),
            CONSTRAINT chk_fact_sales_price_positive CHECK (unit_price > 0),
            CONSTRAINT chk_fact_sales_discount_01 CHECK (discount >= 0 AND discount <= 1)

        );
    END
GO


/*================================

8) fk building

================================*/

ALTER TABLE fact_sales
    ADD CONSTRAINT fk_fact_sales_dim_date
    FOREIGN KEY (orderid_date_key) REFERENCES dim_date(date_key);
GO

alter TABLE fact_sales
    ADD CONSTRAINT fk_fact_sales_dim_customer
    FOREIGN KEY (customer_key) 
    REFERENCES dim_customer(customer_key);
GO

alter TABLE fact_sales
    ADD CONSTRAINT fk_fact_sales_dim_product
    FOREIGN KEY (product_key) 
    REFERENCES dim_product(product_key);
GO

alter TABLE fact_sales
    ADD CONSTRAINT fk_fact_sales_dim_employee
    FOREIGN KEY (employee_key) 
    REFERENCES dim_employee(employee_key);
GO

alter TABLE fact_sales
    ADD CONSTRAINT fk_fact_sales_dim_shipper
    FOREIGN KEY (shipper_key) 
    REFERENCES dim_shipper(shipper_key);
GO

alter TABLE fact_sales
    ADD CONSTRAINT fk_fact_sales_dim_supplier
    FOREIGN KEY (supplier_key) 
    REFERENCES dim_supplier(supplier_key);





    
/*================================

7) fact_sales (grano : linea de pedido (pedido - producto))

================================*/

if OBJECT_ID('fact_sales') is NULL
    BEGIN
        CREATE TABLE fact_sales(
            fact_sales_key begint IDENTITY(1,1) PRIMARY KEY,

            -- Foreign Keys de Dimensiones
            orderid_date_key INT NOT NULL,
            customer_key INT NOT NULL,
            product_key INT NOT NULL,
            employee_key INT NOT NULL,
            shipper_key INT NOT NULL,
            supplier_key INT NOT NULL,
            order_number INT NOT NULL,  -- Numero de pedido (orderid)

            -- Medidas
            order_qty INT NOT NULL,
            unit_price decimal(19,4) NOT NULL,
            discount decimal(5,4) NOT NULL, -- [0.0000 - 1.0000]
            extended_amount  as (CAST(order_qty * unit_price * (1 - discount) as decimal(19,4))) PERSISTED,

            --checks 
            CONSTRAINT chk_fact_sales_qty_positive CHECK (order_qty > 0),
            CONSTRAINT chk_fact_sales_price_positive CHECK (unit_price > 0),
            CONSTRAINT chk_fact_sales_discount_01 CHECK (discount >= 0 AND discount <= 1)

        );
    END
GO
