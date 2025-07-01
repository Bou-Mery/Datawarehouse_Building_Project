-- Create Stored Procedure

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN 
	DECLARE @start_time DATETIME , @end_time DATETIME , @batch_start_time DATETIME , @batch_end_time DATETIME;
	BEGIN TRY

		SET @batch_start_time = GETDATE() ;
		PRINT '================================================' ;
		PRINT '				Loading Bronze Layer' ;
		PRINT '================================================' ;


	-- ================================================
						-- CRM -- 
	-- ================================================


		PRINT '	***************************************';
		PRINT '		  Loading CRM Tables' ;
		PRINT '	***************************************';


	-- 1- bronze.crm_cust_info Table 

		SET @start_time = GETDATE();
		PRINT ' bronze.crm_cust_info Table  ';
		TRUNCATE TABLE bronze.crm_cust_info ; -- Full load

		BULK INSERT bronze.crm_cust_info 
		FROM 'D:\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2 ,
			FIELDTERMINATOR = ',',
			TABLOCK  
		);

		SET @end_time = GETDATE();

		PRINT '>> Load Duration : '+ CAST( DATEDIFF(second , @start_time , @end_time) AS NVARCHAR ) + ' seconds';

	-- 2- bronze.crm_prd_info Table

		SET @start_time = GETDATE();
		PRINT '----------------------------------------'
		PRINT ' bronze.crm_prd_info Table  ';
		TRUNCATE TABLE bronze.crm_prd_info ; -- Full load

		BULK INSERT bronze.crm_prd_info
		FROM 'D:\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2 ,
			FIELDTERMINATOR = ',',
			TABLOCK  
		);

		SET @end_time = GETDATE();

		PRINT '>> Load Duration : '+ CAST( DATEDIFF(second , @start_time , @end_time) AS NVARCHAR ) + ' seconds';


	-- 3- bronze.crm_sales_details Table

		SET @start_time = GETDATE();
		PRINT '----------------------------------------'
		PRINT ' bronze.crm_sales_details Table ';
		TRUNCATE TABLE bronze.crm_sales_details ; -- Full load

		BULK INSERT bronze.crm_sales_details
		FROM 'D:\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2 ,
			FIELDTERMINATOR = ',',
			TABLOCK  
		);
		SET @end_time = GETDATE();

		PRINT '>> Load Duration : '+ CAST( DATEDIFF(second , @start_time , @end_time) AS NVARCHAR ) + ' seconds';


	-- ================================================
						-- ERP -- 
	-- ================================================


		PRINT '	***************************************';
		PRINT '			Loading ERP Tables ' ;
		PRINT '	***************************************';

	-- 1- bronze.erp_cust_az12 Table

		SET @start_time = GETDATE();
		PRINT '----------------------------------------'
		PRINT 'bronze.erp_cust_az12 Table ';
		TRUNCATE TABLE bronze.erp_cust_az12; -- Full load

		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2 ,
			FIELDTERMINATOR = ',',
			TABLOCK  
		);

		SET @end_time = GETDATE();

		PRINT '>> Load Duration : '+ CAST( DATEDIFF(second , @start_time , @end_time) AS NVARCHAR ) + ' seconds';

	-- 2- bronze.erp_loc_a101 Table

		SET @start_time = GETDATE();
		PRINT '----------------------------------------'
		PRINT ' bronze.erp_loc_a101 Table ';
		TRUNCATE TABLE bronze.erp_loc_a101 ; -- Full load

		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2 ,
			FIELDTERMINATOR = ',',
			TABLOCK  
		);
		SET @end_time = GETDATE();

		PRINT '>> Load Duration : '+ CAST( DATEDIFF(second , @start_time , @end_time) AS NVARCHAR ) + ' seconds';


	-- 3- bronze.erp_px_cat_g1v2 Table

		SET @start_time = GETDATE();
		PRINT '----------------------------------------'
		PRINT ' bronze.erp_px_cat_g1v2 Table  ';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2 ; -- Full load

		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2 ,
			FIELDTERMINATOR = ',',
			TABLOCK  
		);

		SET @end_time = GETDATE();

		PRINT '>> Load Duration : '+ CAST( DATEDIFF(second , @start_time , @end_time) AS NVARCHAR ) + ' seconds';

		SET @batch_end_time = GETDATE() ;

		PRINT '#####################################################' ;
		PRINT '#												    #' ;
		PRINT '#		LOADING BRONZE LAYER IS COMPLETED 		    #' ;
		PRINT '#		Total Load Duration : '+ CAST( DATEDIFF(second , @batch_start_time , @batch_end_time) AS NVARCHAR ) + ' seconds' + '			    #';
		PRINT '#												    #' ;
		PRINT '#####################################################' ; 

	END TRY 
	BEGIN CATCH
		PRINT '***********************************************';
		PRINT 'ERROR ACCURED DURING LOADING BRONZE LAYER '
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Number' + CAST(ERROR_NUMBER() AS NVARCHAR );
		PRINT 'Error State' + CAST(ERROR_STATE() AS NVARCHAR );
		PRINT '***********************************************';
	END CATCH

END
