/*
===============================================================================
 Stored Procedure : silver.load_silver
 Purpose          : Executes the ETL pipeline to load curated data into the 
                    Silver Layer from the Bronze Layer in a structured format.

 Description      : 
    This procedure performs the following actions:
        - Truncates existing tables in the 'silver' schema.
        - Loads and transforms data from the 'bronze' staging tables.
        - Applies data cleaning, standardization, and business logic.
        - Ensures data quality and readiness for analytics and reporting.

 Parameters       : None

 Returns          : None

 Usage            : 
    EXEC silver.load_silver;

 Author           : Amine Bouraoui
 Created On       : 27/07/2025
 Last Modified    : -
===============================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_silver AS 
BEGIN 
	--------   SILVER LAYER   --------
	----------------CRM----------------
	--- silver.crm_cust_info
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME,@BATCH_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT'============================================';
		PRINT'Loading Silver Layer';
		PRINT'============================================';

	
		PRINT'--------------------------------------------';
		PRINT'Loading CRM Tables';
		PRINT'--------------------------------------------';

		SET @start_time = GETDATE();
		PRINT'>> Truncating Table : Silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info;
		PRINT'>> Inserting Table : Silver.crm_cust_info';
		INSERT INTO silver.crm_cust_info(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date)
		SELECT 
		cst_id,
		cst_key,
		TRIM(cst_firstname) AS cst_firstname,
		TRIM (cst_lastname) AS cst_lastname,
		CASE WHEN UPPER (TRIM(cst_marital_status)) = 'S' THEN 'Single'
			 WHEN UPPER (TRIM(cst_marital_status)) = 'M' THEN 'Married' 
			 ELSE 'n/a'
		END cst_marital_status,
		CASE WHEN UPPER (TRIM(cst_gndr)) = 'F' THEN 'FEMALE'
			 WHEN UPPER (TRIM(cst_gndr)) = 'M' THEN 'MALE' 
			 ELSE 'n/a'
		END cst_gndr,
		TRY_CAST(cst_create_date AS DATE) AS cst_create_date
		FROM (
			SELECT 
			*,
			ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		)AS t WHERE flag_last =1;
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: '+  CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' Seconds';
		PRINT'>> -----------';

	----------------------------------
	--- silver.crm_prd_info
		SET @start_time = GETDATE();
		PRINT'>> Truncating Table : silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT'>> Inserting Table : silver.crm_prd_info';
		INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		SELECT	
			prd_id,
			REPLACE (SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
			SUBSTRING( prd_key,7,len(prd_key)) AS prd_key,
			prd_nm,
			ISNULL(prd_cost,0) as prd_cost,
			CASE UPPER(TRIM(prd_line))
				 WHEN'M' THEN 'Montain'
				 WHEN'R' THEN 'Road'
				 WHEN'T' THEN 'Touring'
				 WHEN'S' THEN 'other Sales'
				 ELSE 'n/a'
			END AS  prd_line,
			 CAST(prd_start_dt AS DATE) AS prd_start_dt,
			CAST(LEAD(prd_start_dt) OVER ( PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
		from bronze.crm_prd_info
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: '+  CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' Seconds';
		PRINT'>> -----------';

	----------------------------------
	-- silver.crm_sales_details
		SET @start_time = GETDATE();
		PRINT'>> Truncating Table : crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT'>> Inserting Table : crm_sales_details';
		INSERT INTO silver.crm_sales_details(
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				sls_order_dt,
				sls_ship_dt,
				sls_due_dt,
				sls_sales,
				sls_quantity,
				sls_price
		)
		SELECT 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE
			 WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
			 ELSE CAST (CAST(sls_order_dt AS VARCHAR) AS DATE)
		END AS sls_order_dt,
		CASE 
			 WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
			 ELSE CAST (CAST(sls_ship_dt AS VARCHAR) AS DATE)
		END AS sls_ship_dt,
		CASE
			 WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
			 ELSE CAST (CAST(sls_due_dt AS VARCHAR) AS DATE)
		END AS sls_due_dt,
		CASE
			 WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)         
				THEN sls_quantity * ABS(sls_price)   
			 ELSE  sls_sales
		END AS sls_sales,
		sls_quantity,
		CASE WHEN sls_price IS NULL OR sls_price <= 0
				THEN sls_sales / NULLIF(sls_quantity,0) 
			ELSE sls_price
		END AS sls_price
		from bronze.crm_sales_details
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: '+  CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' Seconds';
		PRINT'>> -----------';
	--====================================--
	----------------ERP---------------------
	-- silver.erp_CUST_AZ12
		PRINT'--------------------------------------------';
		PRINT'Loading ERP Tables';
		PRINT'--------------------------------------------';
	
		SET @start_time = GETDATE();	
		PRINT'>> Truncating Table : silver.erp_CUST_AZ12';
		TRUNCATE TABLE silver.erp_CUST_AZ12;
		PRINT'>> Inserting Table : silver.erp_CUST_AZ12';
		INSERT INTO silver.erp_CUST_AZ12(
				cid,
				bdate,
				gen 
		)
		select 
		CASE 
			 WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,len(cid))
			 ELSE cid
		END AS cid, 
		CASE 
			 WHEN bdate > GETDATE () THEN NULL 
			 ELSE bdate 
		END AS bdate, 
		CASE 
			 WHEN UPPER (TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
			 WHEN UPPER (TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
			 ELSE 'n/a'
		END AS gen
		from bronze.erp_CUST_AZ12
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: '+  CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' Seconds';
		PRINT'>> -----------';

	----------------------------------
	--silver.erp_LOC_A101 
		SET @start_time = GETDATE();	
		PRINT'>> Truncating Table : silver.erp_LOC_A101';
		TRUNCATE TABLE silver.erp_LOC_A101;
		PRINT'>> Inserting Table : silver.erp_LOC_A101';
		INSERT INTO silver.erp_LOC_A101 (
		cid,CNTRY
		)
		select 
		REPLACE(cid,'-','') AS cid,
		CASE WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
			 WHEN TRIM(CNTRY) IN ('US','USA') THEN 'United States'
			 WHEN TRIM(CNTRY) = '' or CNTRY is null THEN 'n/a'
			ELSE TRIM(CNTRY) 
		END AS CNTRY
		from bronze.erp_LOC_A101 
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: '+  CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' Seconds';
		PRINT'>> -----------';
	----------------------------------
	-- silver.erp_PX_CAT_G1V2
		SET @start_time = GETDATE();		
		PRINT'>> Truncating Table : silver.erp_PX_CAT_G1V2';
		TRUNCATE TABLE silver.erp_PX_CAT_G1V2;
		PRINT'>> Truncating Table : silver.erp_PX_CAT_G1V2';
		INSERT INTO silver.erp_PX_CAT_G1V2(id,
			cat,
			subcat,
			maintenance
		)
		SELECT  
		id,
		cat,
		subcat,
		maintenance
		FROM bronze.erp_PX_CAT_G1V2;
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: '+  CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' Seconds';
		PRINT'>> -----------';

		SET @batch_end_time = GETDATE();
		PRINT'>> Total Load Duration: '+  CAST (DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR) + ' Seconds';
		PRINT'>> ==================================';

	END TRY
	BEGIN CATCH
		PRINT'============================================';
		PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT'Error Message'+ ERROR_MESSAGE();
		PRINT'Error Message'+ CAST (ERROR_MESSAGE() AS NVARCHAR);
		PRINT'Error Message'+ CAST (ERROR_STATE() AS NVARCHAR);
		PRINT'============================================';
	END CATCH  -- Ensures error handling,data intergrity, and issue logging for easier debugging
END
