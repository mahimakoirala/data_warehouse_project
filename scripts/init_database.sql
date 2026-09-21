/*
Create Database and Schemas

Script Purpose:
	This Script creates a new database named 'DataWarehouse' after checking if it already exists.
	If the database, exists, it is dropped and recreated. Additionally, the script sets up three schemas within the
	database: 'bronze', 'silver' and 'gold'.

WARNING:
	Running this script will drop entire 'DataWarehouse' database if it exists.
	All data in the database will be premanently deleted. Proceed with caution and ensure you have proper backups
	before running this script.
*/

USE master;
GO

--DROP and recreate the "DataWarehouse" database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN 
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

--create database 'DataWarehouse'
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

--create schemas

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
