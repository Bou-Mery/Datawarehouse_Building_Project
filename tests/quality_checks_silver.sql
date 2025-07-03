-- ===============================================
-- =             QUALITY CHECKS                  =
-- =         silver.crm_cust_info Table          =
-- ===============================================

-- Check for NULLs or Duplicates in Primary Key
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for Unwanted Spaces
SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Data Standardization & Consistency
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;

-- ===============================================
-- =             QUALITY CHECKS                  =
-- =         silver.crm_prd_info Table           =
-- ===============================================

-- Check For Duplicates or NULLs Primary Key 
SELECT 
	prd_id ,
	COUNT(*)
FROM silver.crm_prd_info 
GROUP BY prd_id 
HAVING COUNT(*) > 1 OR prd_id IS NULL ;


-- Check unwanted Spaces 
SELECT prd_nm
FROM silver.crm_prd_info 
WHERE prd_nm != TRIM(prd_nm ) ;


-- Check from NULLs or Negative Numbers
SELECT prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0 ;


-- Data Standardization & Consistency 
SELECT distinct prd_line 
FROM silver.crm_prd_info ;

-- Check for Invalid Date Orders 
SELECT * 
FROM silver.crm_prd_info 
WHERE prd_end_dt < prd_start_dt ;
 
-- ===============================================
-- =             QUALITY CHECKS                  =
-- =       silver.crm_sales_details Table        =
-- ===============================================

-- Check Invalid Dates in Bronze Table
SELECT 
NULLIF(sls_order_dt , 0) As sls_order_dt
FROM bronze.crm_sales_details 
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) != 8
						OR sls_order_dt > 20500101 
						OR sls_order_dt < 19000101 ;

SELECT  sls_order_dt , sls_due_dt ,sls_ship_dt 
FROM bronze.crm_sales_details 
WHERE sls_order_dt > sls_due_dt OR sls_order_dt >sls_ship_dt ;

-- Check Data Consistency : Between Sales , Quantity , and Price 
-- # Sales = Quantity * Price
-- # Values must not be NULL , zero, or Negative 

SELECT DISTINCT 
sls_sales As sls_sales_old,
sls_quantity AS sls_quantity_old ,
sls_price AS sls_price_old,
CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price)  
		THEN sls_quantity * ABS(sls_price) 
	ELSE sls_sales
END AS sls_sales ,

sls_quantity ,

CASE WHEN sls_price = 0 OR sls_price IS NULL 
		THEN sls_sales / NULLIF(sls_quantity ,0)
	WHEN sls_price < 0 
		THEN ABS(sls_price)
	ELSE sls_price
END AS sls_price 
FROM silver.crm_sales_details 
WHERE sls_sales != sls_quantity * sls_price 
	  OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL 
	  OR sls_sales < 0 OR sls_quantity < 0 OR sls_price < 0 
ORDER BY  sls_sales ,
		  sls_quantity ,
		  sls_price ;



-- ===============================================
-- =             QUALITY CHECKS                  =
-- =         silver.erp_cust_az12 Table          =
-- ===============================================

-- Identify Out-Of-Range Dates
SELECT DISTINCT 
bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1984-10-04' OR bdate > GETDATE() ;

-- Data Standardization & Consistency 
SELECT DISTINCT gen ,
CASE WHEN bdate > GETDATE() THEN NULL 
		ELSE bdate 
	END AS bdate ,

	CASE WHEN TRIM(UPPER(gen)) IN ( 'F' , 'FEMALE' ) THEN 'Female'
		 WHEN TRIM(UPPER(gen)) IN ( 'M' , 'MALE' ) THEN 'Male'
		 ELSE 'n/a' 
	END gen
FROM silver.erp_cust_az12 
WHERE gen NOT IN ('Female' , 'Male') ;

-- ===============================================
-- =             QUALITY CHECKS                  =
-- =         silver.erp_loc_a101 Table           =
-- ===============================================

-- Data Standardization & Consistency 
SELECT DISTINCT cntry ,
CASE WHEN TRIM(UPPER(cntry)) ='DE' THEN 'Germany'
     WHEN TRIM(UPPER(cntry)) IN ('US' , 'USA' )  THEN 'United States'
	 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
	 ELSE TRIM(cntry) 
END AS cntry
FROM silver.erp_loc_a101 ;


-- ===============================================
-- =             QUALITY CHECKS                  =
-- =         silver.erp_px_cat_g1v2 Table           =
-- ===============================================

-- Check for unwanted spaces
SELECT * 
FROM silver.erp_px_cat_g1v2  
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

-- Data Standardization & Consistency 
SELECT DISTINCT 
cat
FROM silver.erp_px_cat_g1v2  ;

SELECT DISTINCT 
maintenance
FROM silver.erp_px_cat_g1v2  ;
