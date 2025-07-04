

IF OBJECT_ID('gold.dim_customer ') IS NOT NULL	
DROP VIEW gold.dim_customer ;
GO
CREATE VIEW gold.dim_customers AS 
SELECT 
	ROW_NUMBER() OVER (ORDER BY cst_id )  AS customer_key ,
	ci.cst_id as custemer_id ,
	ci.cst_key as customer_number ,
	ci.cst_firstname as first_name ,
	ci.cst_lastname as last_name ,
	ci.cst_marital_status as marital_status ,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master for hender Informations
		 ELSE COALESCE(ca.gen , 'n/a' ) 
	END AS new_gen ,
	loc.cntry as country ,
	ca.bdate as birthdate ,
	ci.cst_create_date as create_date 
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca 
ON ci.cst_key = ca.cid 
LEFT JOIN	silver.erp_loc_a101 loc
ON ci.cst_key = loc.cid ;



IF OBJECT_ID('gold.dim_products ') IS NOT NULL	
DROP VIEW gold.dim_products ;
GO
CREATE VIEW gold.dim_products AS 
SELECT	
	ROW_NUMBER() OVER (ORDER BY pr.prd_start_dt) As product_key ,
	pr.prd_id AS product_id ,
	pr.prd_key AS product_number ,
	pr.prd_nm AS product_name ,
	pr.cat_id AS categorie_id ,
	pcat.cat AS categorie ,
	pcat.subcat AS subcategorie ,
	pcat.maintenance AS maintenance ,
	pr.prd_cost AS product_cost ,
	pr.prd_line AS product_line ,
	pr.prd_start_dt AS start_date

FROM silver.crm_prd_info pr 
LEFT JOIN  silver.erp_px_cat_g1v2 pcat
ON pr.cat_id = pcat.id 
WHERE pr.prd_end_dt IS NULL ; -- Filter out all historical data 


IF OBJECT_ID('gold.fact_sales ') IS NOT NULL	
DROP VIEW gold.fact_sales ;
GO
CREATE VIEW gold.fact_sales AS
SELECT
	sl.sls_ord_num AS order_number ,
	pr.product_key ,
	cu.customer_key ,
	sl.sls_order_dt AS order_date ,
	sl.sls_ship_dt AS shipping_date ,
	sl.sls_due_dt AS due_date ,
	sl.sls_sales AS sales_amount ,
	sl.sls_quantity AS quantity ,
	sl.sls_price AS price

FROM silver.crm_sales_details sl 
LEFT JOIN gold.dim_customers cu 
ON sl.sls_cust_id = cu.custemer_id 
LEFT JOIN gold.dim_products pr
ON 	sl.sls_prd_key = pr.product_number ;

