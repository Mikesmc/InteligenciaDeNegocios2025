/* ============================
Datmart de Ventass (northwind) - ddl inicio de base de datos
Database Datamart_northwind, northwind_metadata, Stage_northwind,
Load_northwind

Autor: MASC
================================*/

-- 1) Crear base de datos
use master

go
if DB_ID('Northwind_Metadata') is NULL
    BEGIN
        CREATE DATABASE Northwind_Metadata;
    END
go

if DB_ID('Load_Northwind') is NULL
    BEGIN
        CREATE DATABASE Load_Northwind;
    END
go 

if DB_ID('Stage_Northwind') is NULL
    BEGIN
        CREATE DATABASE Stage_Northwind;
    END
go 

if DB_ID('Datamart_Northwind') is NULL
    BEGIN
        CREATE DATABASE Datamart_northwind;
    END
go 


