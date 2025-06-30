-- =====================================================================================
-- This script creates a Data Warehouse with three schemas: bronze, silver, and gold.
-- The bronze schema is for raw data, silver for cleaned and transformed data,
-- and gold for aggregated and business-ready data.
-- =====================================================================================

Use master;
GO
  
CREATE DATABASE DataWarehouse ;

USE DataWarehouse;
GO

CREATE SCHEMA bronze ;
GO

CREATE SCHEMA silver ;
GO

CREATE SCHEMA gold ;
GO

