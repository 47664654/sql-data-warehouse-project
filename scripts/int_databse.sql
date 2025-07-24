/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/



use master;
Go 

--Drop and recreate the  'DataWarehouse' datbase 
IF EXISTS ( select 1 from sys.databases where name = 'DataWarehouse')
Begin
alter database DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE DataWarehouse;
END;
GO




-- create the 'DataWarehouse'database
CREATE DATABASE DataWarehouse; 
Go


use DataWarehouse;

-- create schemas
create schema bronze;
Go
create schema silver;
Go
create schema gold;
GO
