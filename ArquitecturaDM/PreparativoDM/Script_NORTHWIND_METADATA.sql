use master
go

if exists (select name from SYS.database where name= 'NORTHWIND_METADATA')
BEGIN
	drop database NORTHWIND_METADATA

end 
go

create database NORTHWIND_METADATA
go

use NORTHWIND_METADATA
go

create table ETLExecution(
	Id int identity(1,1) not null,
	UserName nvarchar(50),
	MachineName nvarchar(50),
	PackageName nvarchar(50),
	ETLLoad datetime,
	ETLCountRows bigint,
	ETLCountNewRegister bigint,
	ETLCountModifiedRegister bigint
)
go

