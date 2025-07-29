/*
===============================================================================
 Script Name     : Data Quality Checks – Gold Layer
 Purpose         : Validates the structural and relational integrity of the 
                   analytical 'gold' layer views, which are used for reporting 
                   and business decision-making.

 Description     : 
    This script performs critical QA checks to ensure:
        - Surrogate keys in dimension tables are unique and non-duplicated
        - All foreign key relationships in the fact table align with 
          existing dimension table records
        - The data model adheres to referential integrity for reliable analytics

 Usage Notes     : 
    - Run this script after creating or refreshing the gold views
    - If any rows are returned by the checks, investigate and resolve before 
      proceeding with reporting or dashboarding
    - This script is non-destructive (read-only)

 Parameters      : None

 Returns         : Query result sets highlighting potential integrity issues

 Author          : Amine Bouraoui
 Created On      : 2025-07-29
 Last Modified   : -
===============================================================================
*/ 
-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.product_key'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL  
