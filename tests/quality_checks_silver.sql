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
