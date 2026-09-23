/* 
==========================================
Quality Checks
==========================================
Script Purpose:
	This script performs quality checks for data consistency, accuracy, and standardization across the 
	'silver' schemas. It includes checks for: null or duplicate primary keys, unwanted spaces , data standardization and consistency, invalid date range,
	data consistency between related fields.

Usage notes:
	- Run these checks after data loading in silver layer.
	- investigate and resolve any discrepancies found during the checks.
===========================================
*/

-- =========================================
-- Checking 'silver.crm_cust_info'
-- =========================================

-- check for nulls or duplicates in primary key
-- Expectation: No Result
SELECT 
	cst_id,
	count(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 or cst_id IS NULL;
GO
--check for unwanted spaces
--expectation: no results
SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)
GO
--Data Standardization & Consistency
SELECT DISTINCT cst_gndr 
FROM silver.crm_cust_info
GO

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info
GO

-- =========================================
-- Checking 'silver.crm_prd_info'
-- =========================================
--check for nulls in primary key
SELECT prd_id,COUNT(*) FROM silver.crm_prd_info GROUP BY prd_id HAVING COUNT(*) > 1 OR prd_id IS NULL

--check for unwanted spaces
SELECT TOP 1000 * FROM bronze.crm_prd_info
SELECT prd_nm from silver.crm_prd_info where prd_nm != TRIM(prd_nm)

--check for nulls or negative numbers
--expectation: no results
SELECT prd_cost
FROM silver.crm_prd_info 
where prd_cost is null or prd_cost <0

--data standardization & consistency
SELECT DISTINCT prd_line FROM silver.crm_prd_info
SELECT TOP 1000 * FROM bronze.crm_prd_info

--Check for Invalid Date Orders
SELECT * FROM silver.crm_prd_info
WHERE  prd_end_dt < prd_start_dt;
-- =========================================
-- Checking 'silver.crm_sales_details'
-- =========================================
--Check for invalid dates
SELECT 
NULLIF(sls_order_dt, 0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 or len(sls_order_dt) != 8;
GO

SELECT 
NULLIF(sls_ship_dt, 0) sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 or len(sls_ship_dt) != 8;
GO

SELECT 
NULLIF(sls_due_dt, 0) sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 or len(sls_due_dt) != 8;
GO
-- Check for Invalid date orders
SELECT * FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt;
GO

-- Check Data Consistency: Sales, Quantity and Price
-- values must not be NULL, zero or negative
SELECT 
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE Sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <=0 OR sls_quantity <=0 or sls_price <=0
ORDER BY sls_quantity, sls_price;
GO 

-- =========================================
-- Checking 'silver.erp_cust_az12'
-- =========================================
	
--Identify out-of-range birthdates
SELECT DISTINCT bdate from bronze.erp_cust_az12 
WHERE bdate < '1924-01-01' or bdate > GETDATE()

--Data Standardization and Consistency
SELECT DISTINCT 
gen
FROM bronze.erp_cust_az12 

-- =========================================
-- Checking 'silver.erp_px_cat_g1v2'
-- =========================================

--check for unwanted spaces
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE TRIM(id) != id

-- Data standardization & consistency
SELECT DISTINCT subcat from bronze.erp_px_cat_g1v2;
SELECT DISTINCT cat from bronze.erp_px_cat_g1v2;
SELECT DISTINCT maintenance from bronze.erp_px_cat_g1v2;
