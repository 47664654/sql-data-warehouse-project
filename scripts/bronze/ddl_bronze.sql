/*
***************************************************************************************
  Script Name :Create Bronze Tables
  Purpose     : Creates (or recreates) all required tables in the Bronze Layer of the 
                DataWarehouse database. Drops existing tables if they exist to ensure
                a clean refresh for raw data ingestion.

  Description :
    - Drops and recreates CRM tables:
        * bronze.crm_cust_info
        * bronze.crm_prd_info
        * bronze.crm_sales_details
    - Drops and recreates ERP tables:
        * bronze.erp_CUST_AZ12
        * bronze.erp_LOC_A101
        * bronze.erp_PX_CAT_G1V2
    - Sets up schemas and defines appropriate column data types for initial raw load

  Author      : Amine Bouraoui
  Created On  : 26/07/2025
  Modified On : 26/07/2025
  Notes       :
    - Ensure the 'bronze' schema exists in the DataWarehouse database
    - Adjust data types if source files change in format
    - Use NVARCHAR for flexibility during raw ingestion
    - Consider converting date fields to DATE or DATETIME after data cleansing

***************************************************************************************
*/
IF OBJECT_ID ('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info(
cst_id INT,
cst_key NVARCHAR (50),
cst_firstname NVARCHAR (50),
cst_lastname NVARCHAR (50),
cst_marital_status NVARCHAR (50),
cst_gndr NVARCHAR (50),
cst_create_date NVARCHAR(50)
);

IF OBJECT_ID ('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
Create Table bronze.crm_prd_info(
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATETIME,
prd_end_dt DATETIME
); 

IF OBJECT_ID ('bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
sls_ord_num NVARCHAR (50),
sls_prd_key NVARCHAR (50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);

IF OBJECT_ID ('bronze.erp_CUST_AZ12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_CUST_AZ12;
Create table bronze.erp_CUST_AZ12(
CID NVARCHAR (50),
BDATE DATE ,
GEN NVARCHAR (50)
);

IF OBJECT_ID ('bronze.erp_LOC_A101', 'U') IS NOT NULL
	DROP TABLE bronze.erp_LOC_A101;
create table bronze.erp_LOC_A101(
CID NVARCHAR (50),
CNTRY NVARCHAR (50)
);

IF OBJECT_ID ('bronze.erp_PX_CAT_G1V2', 'U') IS NOT NULL
	DROP TABLE bronze.erp_PX_CAT_G1V2;
create table bronze.erp_PX_CAT_G1V2(
ID NVARCHAR (50),
CAT NVARCHAR (50),
SUBCAT NVARCHAR (50),
MAINTENANCE NVARCHAR (50)
);
