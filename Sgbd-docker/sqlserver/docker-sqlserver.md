
## Comando para ejecutar en linux
```Docker
docker run -e  "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<Mipassw0rd123>" 
-p 1422:1423 --name sqlserverBI 
-v sqlserver-volume:/var/opt/mssql 
-d mcr.microsoft.com/mssql/server:2025-latest
```

## Comando para ejecutar en windows
```Docker
docker run -e  "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<Mipassw0rd123>" `
-p 1422:1423 --name sqlserverBI `
-v sqlserver-volume:/var/opt/mssql ` 
-d mcr.microsoft.com/mssql/server:2025-latest

```
crear una version mas baja


docker run -e  "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<Mipassw0rd123>" -p 1423:1433 --name sqlserverBI2 -v sqlserver-volume:/var/opt/mssql -d mcr.microsoft.com/mssql/server:2022-latest

