-- ===============================================
-- =             QUALITY CHECKS                  =
-- =         gold.dim_customers Table            =
-- ===============================================

-- Check gender consistency between CRM and ERP sources
SELECT DISTINCT
    ci.cst_gndr,
    ca.gen,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a') 
    END AS gender 
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca 
    ON ci.cst_key = ca.cid 
LEFT JOIN silver.erp_loc_a101 loc
    ON ci.cst_key = loc.cid
ORDER BY 1, 2;

-- Check values of gender in the final gold.dim_customers table
SELECT DISTINCT 
    new_gen
FROM gold.dim_customers;

-- ===============================================
-- =             QUALITY CHECKS                  =
-- =         gold.dim_products Table             =
-- ===============================================

-- Check integrity between product category IDs in CRM and ERP
SELECT DISTINCT 
    cat_id, 
    id
FROM silver.crm_prd_info pr 
LEFT JOIN silver.erp_px_cat_g1v2 pcat
    ON pr.cat_id = pcat.id 
ORDER BY 1, 2;

--  Check active (non-expired) products in CRM
SELECT
    ROW_NUMBER() OVER (ORDER BY pr.prd_id) AS product_key,
    pr.prd_id, 
    pr.cat_id,
    pr.prd_key, 
    pr.prd_nm,
    pr.prd_cost,
    pr.prd_line, 
    pr.prd_start_dt,
    pr.prd_end_dt 
FROM silver.crm_prd_info pr 
WHERE pr.prd_end_dt IS NULL;

--  Check for duplicate product keys (prd_key) 

SELECT prd_key, COUNT(*) 
FROM (
    SELECT
        ROW_NUMBER() OVER (ORDER BY pr.prd_id) AS product_key,
        pr.prd_id, 
        pr.cat_id,
        pr.prd_key, 
        pr.prd_nm,
        pr.prd_cost,
        pr.prd_line, 
        pr.prd_start_dt,
        pr.prd_end_dt,
        pcat.cat,
        pcat.subcat,
        pcat.maintenance 
    FROM silver.crm_prd_info pr 
    LEFT JOIN silver.erp_px_cat_g1v2 pcat
        ON pr.cat_id = pcat.id 
    WHERE pr.prd_end_dt IS NULL
) t 
GROUP BY prd_key 
HAVING COUNT(*) > 1;

--  Review contents of gold.dim_products to validate structure
SELECT * FROM gold.dim_products;

-- ===============================================
-- =             QUALITY CHECKS                  =
-- =         gold.fact_sales Table               =
-- ===============================================

-- Foreign key integrity check:

SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key 
LEFT JOIN gold.dim_products p 
    ON f.product_key = p.product_id 
WHERE c.customer_key IS NULL;
