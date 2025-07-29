
/*
===============================================================================
 Script Name     : Create Gold Views – Star Schema
 Purpose         : Builds final analytical views in the 'gold' schema using
                   curated and enriched data from the 'silver' layer.

 Description     : 
    This script creates business-ready views for dimension and fact tables
    following the star schema model. These views serve as the foundation
    for analytics, dashboards, and reporting.

    Includes:
        - Dimension Views (dim_customers, dim_products) with surrogate keys
        - Fact View (fact_sales) linking to dimensions
        - Data enrichment, cleanup, and surrogate key generation
        - Joins across CRM and ERP sources for completeness

 Usage Notes     : 
    - Execute after all transformations in the silver layer are complete
    - These views are not materialized; they compute results at query time
    - Recommended as the primary interface for BI/reporting tools

 Parameters      : None

 Returns         : Logical views with clean and joined data ready for analysis

 Author          : Amine Bouraoui
 Created On      : 2025-07-29
 Last Modified   : -
===============================================================================
*/

-- =====================================================
-- Create Dimension : gold.dim_customers
-- =====================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT  
    ROW_NUMBER() OVER (ORDER BY cst_id ) customer_key,
    ci.cst_id             AS customer_id,
    ci.cst_key            AS customer_number, 
    ci.cst_firstname      AS first_name,
    ci.cst_lastname       AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status ,
    CASE 
         WHEN ci.cst_gndr != 'n/a' 
         THEN ci.cst_gndr -- CRM is the master for gender info 
         ELSE COALESCE(ca.gen,'n/a')
    END AS gender,
    ca.bdate              AS birthdate,
    ci.cst_create_date    AS create_date
from silver.crm_cust_info AS ci 
LEFT JOIN silver.erp_CUST_AZ12 AS ca 
    ON		ci.cst_key = ca.cid
LEFT JOIN silver.erp_LOC_A101  AS la 
    ON		ci.cst_key = la.cid;
GO 

-- =====================================================
-- Create Dimension : gold.dim_product
-- =====================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_product AS
SELECT 
    ROW_number() OVER (ORDER BY pn.prd_start_dt,pn.prd_id) AS product_key,
    pn.prd_id         AS product_id,
    pn.prd_key        AS product_number,
    pn.prd_nm         AS product_name,
    pn.cat_id         AS category_id,
    pc.cat            AS category,
    pc.subcat         AS subcategory ,
    pc.maintenance    AS maintenace,
    pn.prd_cost       AS cost,
    pn.prd_line       AS product_line,
    pn.prd_start_dt   AS start_date
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_PX_CAT_G1V2 AS PC 
    ON      pn.cat_id = pc.id    
WHERE pn.prd_end_dt is null;
GO

-- =====================================================
-- Create Dimension : gold.fact_sales
-- =====================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS 
SELECT 
    sd.sls_ord_num   AS order_number,
    pr.product_key   AS product_key,
    cu.customer_key  AS customer_key,
    sd.sls_order_dt  AS order_date,
    sd.sls_ship_dt   AS shipping_date,
    sd.sls_due_dt    AS due_date,
    sd.sls_sales     AS sales_amount,
    sd.sls_quantity  AS quantity ,
    sd.sls_price     AS price
from silver.crm_sales_details AS sd
LEFT JOIN gold.dim_product as pr
    on      sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers as cu
    on      sd.sls_cust_id = cu.customer_id;
GO
