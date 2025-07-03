	-- --------------------------------------------------------------
	--						STORED PROCEDURE					   --
	--        Clean & Load Tables ( from bronze to silver )        --
	-- --------------------------------------------------------------

/*
Usage Example : 
	>> EXEC silver.load_silver ;
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME , @end_time DATETIME , @batch_start_time DATETIME , @batch_end_time DATETIME ;
	BEGIN TRY

		PRINT '================================================' ;
		PRINT '				Loading Silver Layer' ;
		PRINT '================================================' ;

		SET @batch_start_time = GETDATE() ;

		
		PRINT '	***************************************';
		PRINT '		  Loading CRM Tables' ;
		PRINT '	***************************************';
		-- --------------------------------------------------------------
		SET @start_time = GETDATE() ;

		PRINT ' ## Truncating Table : silver.crm_cust_info ';
		TRUNCATE TABLE silver.crm_cust_info; 
		PRINT ' ## Inserting Data Into: silver.crm_cust_info';
		INSERT INTO silver.crm_cust_info (
			cst_id ,
			cst_key ,
			cst_firstname , 
			cst_lastname ,
			cst_marital_status ,
			cst_gndr ,
			cst_create_date
		)
		SELECT 
			cst_id ,
			cst_key ,
			TRIM(cst_firstname) as cst_firstname , -- Removing unwanted spaces
			TRIM(cst_lastname) as cst_lastname ,

			CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single' -- Data Normalization & Standarization
				WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
				 ELSE 'n/a' -- Handling the missing values
			END cst_marital_status ,

			CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male' 
				 ELSE 'n/a'
			END cst_gndr ,

			cst_create_date

		FROM ( 
			SELECT 
			* ,
			ROW_NUMBER() OVER( PARTITION BY cst_id ORDER BY  cst_create_date DESC) as flag_last -- Remove Duplicates
			FROM bronze.crm_cust_info 
			)t 
		WHERE flag_last = 1  ; -- Data Filtring

		SET @end_time = GETDATE() ;

		PRINT '>> Load Duration : '+ CAST( DATEDIFF(second , @start_time , @end_time) AS NVARCHAR ) + ' seconds';
		PRINT '----------------------------------------';

		-- --------------------------------------------------------------
		SET @start_time = GETDATE() ;

		PRINT ' ## Truncating Table : silver.crm_prd_info ';
		TRUNCATE TABLE silver.crm_prd_info; 
		PRINT ' ## Inserting Data Into: silver.crm_prd_info';
		INSERT INTO silver.crm_prd_info (
			prd_id ,
			cat_id ,
			prd_key ,
			prd_nm ,
			prd_cost ,
			prd_line,
			prd_start_dt ,
			prd_end_dt
		)
		SELECT 
			prd_id ,
			REPLACE( SUBSTRING(prd_key , 1 , 5 ) , '-' , '_' ) as prd_cat , -- Extract category ID
			SUBSTRING(prd_key , 7 , LEN(prd_key) ) as prd_key ,  -- Extract product Key
			prd_nm ,
			ISNULL(prd_cost , 0 ) As prd_cost , -- Handling Missing Information (NULL by 0 )
	
			CASE UPPER(TRIM(prd_line)) 
				 WHEN 'M' THEN 'Mountain' 
				 WHEN 'R' THEN 'Road'
				 WHEN 'S' THEN 'Other Sales'
				 WHEN 'T' THEN 'Touring'
				 ELSE 'n/a'	 
			END prd_line ,  -- Map product line codes to descreptive values

			prd_start_dt ,  -- Correct dates : Calculate end date as one before the next start date
			DATEADD( DAY , -1 , LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ) ) As 	prd_end_dt -- Data Enrichment
		FROM bronze.crm_prd_info ;

		SET @end_time = GETDATE() ;

		PRINT '>> Load Duration : '+ CAST( DATEDIFF(second , @start_time , @end_time) AS NVARCHAR ) + ' seconds';
		PRINT '----------------------------------------'

		-- --------------------------------------------------------------
		SET @start_time = GETDATE() ;

		PRINT ' ## Truncating Table : silver.crm_sales_details ';
		TRUNCATE TABLE silver.crm_sales_details; 
		PRINT ' ## Inserting Data Into: silver.crm_sales_details';
		INSERT INTO silver.crm_sales_details (
			sls_ord_num  ,
			sls_prd_key ,
			sls_cust_id ,
			sls_order_dt ,
			sls_ship_dt ,
			sls_due_dt 	,
			sls_sales 	,
			sls_quantity ,
			sls_price 
			)
		SELECT  
		sls_ord_num ,
		sls_prd_key ,
		sls_cust_id ,

		CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL -- Handling Invalid Data
			ELSE  CAST ( CAST ( sls_order_dt AS NVARCHAR) AS DATE ) -- Data Type Casting
		END AS sls_order_dt ,

		CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL 
			ELSE  CAST ( CAST ( sls_ship_dt AS NVARCHAR) AS DATE ) 
		END AS sls_ship_dt ,

		CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL 
			ELSE  CAST ( CAST ( sls_due_dt AS NVARCHAR) AS DATE ) 
		END AS sls_due_dt ,
 
		CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) -- Handling the Missing & Invalid Data	 
				THEN sls_quantity * ABS(sls_price) 
			ELSE sls_sales
		END AS sls_sales , -- Recalculate sales if original value is missing or incorrect

		sls_quantity ,

		CASE WHEN sls_price = 0 OR sls_price IS NULL 
				THEN sls_sales / NULLIF(sls_quantity ,0)
			WHEN sls_price < 0 
				THEN ABS(sls_price)
			ELSE sls_price  -- Derive price if original value is invalid 
		END AS sls_price 

		FROM bronze.crm_sales_details ;

		SET @end_time = GETDATE() ;

		PRINT '>> Load Duration : '+ CAST( DATEDIFF(second , @start_time , @end_time) AS NVARCHAR ) + ' seconds';
		PRINT '----------------------------------------';

		-- --------------------------------------------------------------

		PRINT '	***************************************';
		PRINT '			Loading ERP Tables ' ;
		PRINT '	***************************************';

		-- --------------------------------------------------------------
		SET @start_time = GETDATE() ;

		PRINT ' ## Truncating Table : silver.erp_cust_az12 ';
		TRUNCATE TABLE silver.erp_cust_az12 ;
		PRINT ' ## Inserting Data Into: silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12 ;
		INSERT INTO silver.erp_cust_az12 (
			cid ,
			bdate ,
			gen
			)
		SELECT
			CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING( cid , 4 , LEN(cid)) -- Remove 'NAS' prefix if present   
				ELSE cid
			END AS cid ,
			CASE WHEN bdate > GETDATE() THEN NULL 
				ELSE bdate 
			END AS bdate , -- Set future birthdates to NULL

			CASE WHEN TRIM(UPPER(gen)) IN ( 'F' , 'FEMALE' ) THEN 'Female'
				 WHEN TRIM(UPPER(gen)) IN ( 'M' , 'MALE' ) THEN 'Male'
				 ELSE 'n/a' 
			END gen -- Normaize gender values and handle unkhown cases

		FROM bronze.erp_cust_az12 ;

		SET @end_time = GETDATE() ;

		PRINT '>> Load Duration : '+ CAST( DATEDIFF(second , @start_time , @end_time) AS NVARCHAR ) + ' seconds';
		PRINT '----------------------------------------';
		-- --------------------------------------------------------------
		SET @start_time = GETDATE() ;

		PRINT ' ## Truncating Table : silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101 ;
		PRINT ' ## Inserting Data Into: silver.erp_loc_a101';
		INSERT INTO silver.erp_loc_a101 (
			cid ,
			cntry
			)
		SELECT 
		REPLACE(cid , '-' ,'') cid , -- Handling Invalid Values (Removing - in old cid )
		CASE WHEN TRIM(UPPER(cntry)) ='DE' THEN 'Germany'
			 WHEN TRIM(UPPER(cntry)) IN ('US' , 'USA' )  THEN 'United States'
			 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
			 ELSE TRIM(cntry) -- Normalize and Handle missing or blank country codes
		END AS cntry
		FROM bronze.erp_loc_a101 ;

		SET @end_time = GETDATE() ;

		PRINT '>> Load Duration : '+ CAST( DATEDIFF(second , @start_time , @end_time) AS NVARCHAR ) + ' seconds';
		PRINT '----------------------------------------';
		-- --------------------------------------------------------------
		SET @start_time = GETDATE() ;

		PRINT ' ## Truncating Table : silver.erp_px_cat_g1v2';
		TRUNCATE TABLE silver.erp_px_cat_g1v2 ;
		PRINT ' ## Inserting Data Into: silver.erp_px_cat_g1v2';
		INSERT INTO silver.erp_px_cat_g1v2 (
			id ,
			cat ,
			subcat ,
			maintenance 
		)
		SELECT 
		id ,
		cat ,
		subcat ,
		maintenance
		FROM bronze.erp_px_cat_g1v2 ;

		SET @end_time = GETDATE() ;

		PRINT '>> Load Duration : '+ CAST( DATEDIFF(second , @start_time , @end_time) AS NVARCHAR ) + ' seconds';
		PRINT '----------------------------------------';

		SET @batch_end_time = GETDATE() ;

		PRINT '#####################################################' ;
		PRINT '#												    #' ;
		PRINT '#		LOADING SILVER LAYER IS COMPLETED 		    #' ;
		PRINT '#		Total Load Duration : '+ CAST( DATEDIFF(second , @batch_start_time , @batch_end_time) AS NVARCHAR ) + ' seconds' + '			    #';
		PRINT '#												    #' ;
		PRINT '#####################################################' ; 
	END TRY
	BEGIN CATCH
		PRINT '***********************************************';
		PRINT 'ERROR ACCURED DURING LOADING SILVER LAYER '
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Number' + CAST(ERROR_NUMBER() AS NVARCHAR );
		PRINT 'Error State' + CAST(ERROR_STATE() AS NVARCHAR );
		PRINT '***********************************************';
	END CATCH 

END



