/*
-------------------------------------------------------------------------------------
-- Script: Silver Layer Tables Creation
-- Description:
--   This script creates the foundational tables in the Silver layer of the data warehouse.
--   These tables store cleaned, structured, and integrated data from various source systems.
--
--   Steps:
--   - Drop each table if it already exists using IF OBJECT_ID + DROP TABLE.
--   - Recreate each table with clearly defined columns and appropriate data types.
--   - Include a technical metadata column `dwh_create_date` with default value as GETDATE().
--
-- Tables Created:
--   • silver.crm_cust_info       : Customer master data from CRM system.
--   • silver.crm_prd_info        : Product master data from CRM with categorization.
--   • silver.crm_sales_details   : Sales transactions including product and customer references.
--   • silver.erp_cust_az12       : Additional customer info from ERP (birthdate, gender).
--   • silver.erp_loc_a101        : Customer location data from ERP (country).
--   • silver.erp_px_cat_g1v2     : Product category hierarchy and maintenance info.
--
-- Purpose:
--   These Silver layer tables act as an intermediate storage zone where data is:
--     ✓ Standardized
--     ✓ De-duplicated
--     ✓ Enriched
--   before being transformed into the Gold layer for analytics and reporting.
-------------------------------------------------------------------------------------
*/

IF OBJECT_ID('silver.crm_cust_info' , 'U') IS NOT NULL 
	DROP TABLE silver.crm_cust_info ;
CREATE TABLE silver.crm_cust_info (
	cst_id 			INT ,
	cst_key 		NVARCHAR(50) ,
	cst_firstname 		NVARCHAR(50) ,
	cst_lastname 		NVARCHAR(50) ,
	cst_marital_status 	NVARCHAR(50) ,
	cst_gndr 		NVARCHAR(50) ,
	cst_create_date 	DATE ,
	dwh_create_date 	DATETIME2 DEFAULT GETDATE() 
	) ;


IF OBJECT_ID('silver.crm_prd_info' , 'U') IS NOT NULL 
	DROP TABLE silver.crm_prd_info ;
CREATE TABLE silver.crm_prd_info (
	prd_id			INT ,
	cat_id			NVARCHAR(50) ,
	prd_key			NVARCHAR(50) ,
	prd_nm			NVARCHAR(50) ,
	prd_cost		INT ,
	prd_line		NVARCHAR(50) ,
	prd_start_dt		DATE ,
	prd_end_dt		DATE ,
	dwh_create_date 	DATETIME2 DEFAULT GETDATE() 
	);


IF OBJECT_ID('silver.crm_sales_details' , 'U') IS NOT NULL 
	DROP TABLE silver.crm_sales_details ;
CREATE TABLE silver.crm_sales_details (
	sls_ord_num 		NVARCHAR(50) ,
	sls_prd_key 		NVARCHAR(50) ,
	sls_cust_id 		INT ,
	sls_order_dt 		DATE ,
	sls_ship_dt 		DATE,
	sls_due_dt 		DATE ,
	sls_sales 		INT ,
	sls_quantity 		INT ,
	sls_price 		INT,
	dwh_create_date 	DATETIME2 DEFAULT GETDATE() 
	);

IF OBJECT_ID('silver.erp_cust_az12' , 'U') IS NOT NULL 
	DROP TABLE silver.erp_cust_az12 ;
CREATE TABLE silver.erp_cust_az12 (
	cid 			NVARCHAR(50) ,
	bdate 			DATE ,
	gen 			NVARCHAR(50) ,
	dwh_create_date 	DATETIME2 DEFAULT GETDATE() 
	);


IF OBJECT_ID('silver.erp_loc_a101' , 'U') IS NOT NULL 
	DROP TABLE silver.erp_loc_a101 ;
CREATE TABLE silver.erp_loc_a101 (
	cid 			NVARCHAR(50) ,
	cntry 			NVARCHAR(50) ,
	dwh_create_date 	DATETIME2 DEFAULT GETDATE() 
	);


IF OBJECT_ID('silver.erp_px_cat_g1v2' , 'U') IS NOT NULL 
	DROP TABLE silver.erp_px_cat_g1v2 ;
CREATE TABLE silver.erp_px_cat_g1v2 (
	id 			NVARCHAR(50) ,
	cat 			NVARCHAR(50) ,
	subcat 			NVARCHAR(50) ,
	maintenance 		NVARCHAR(50) ,
	dwh_create_date 	DATETIME2 DEFAULT GETDATE() 
	);
