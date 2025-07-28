/*
***************************************************************************************
  Name        :
  Purpose     : Loads data into the Bronze Layer of the data warehouse from CSV files.
                This procedure performs a full refresh of multiple CRM and ERP tables
                by truncating existing data and loading new data using BULK INSERT.
                
  Description :
    - Logs load start and end times
    - Truncates and reloads:
        * CRM tables: crm_cust_info, crm_prd_info, crm_sales_details
        * ERP tables: erp_CUST_AZ12, erp_LOC_A101, erp_PX_CAT_G1V2
    - Handles errors using TRY...CATCH with basic logging for troubleshooting

  Author      : Amine Bouraoui
  Created On  : 26/07/2025
  Modified On : 28/07/2025
  Dependencies: CSV files must be present at specified paths on the server
  Notes       :
    - Intended for dev/test/demo; update file paths or use variables for production
    - Requires access to the 'bronze' schema and BULK INSERT permissions
  Usage Example : 
    - EXEC bronze.load_bronze;

***************************************************************************************
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	--------   BRONZE LAYER   --------
	----------------CRM----------------
	--- bronze.crm_cust_info
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME,@BATCH_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT'============================================';
		PRINT'Loading Bronze Layer';
		PRINT'============================================';

	
		PRINT'--------------------------------------------';
		PRINT'Loading CRM Tables';
		PRINT'--------------------------------------------';

		SET @start_time = GETDATE();
		PRINT'>> Truncating Table: bronze.crm_cust_info';
		truncate table bronze.crm_cust_info; -- refreshing the table , so the data don't load twice 
	
		PRINT'>> inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\MSI\Downloads\SQL\YoutubeSQL_project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: '+  CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' Seconds';
		PRINT'>> -----------';
		
	----------------------------------
	--- bronze.crm_prd_info
		SET @start_time = GETDATE();
		PRINT'>> Truncating Table: bronze.crm_prd_info';
		truncate table bronze.crm_prd_info; -- refreshing the table , so the data don't load twice 
	
		PRINT'>> inserting Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\MSI\Downloads\SQL\YoutubeSQL_project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: '+  CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' Seconds';
		PRINT'>> -----------';
		
		
	 ----------------------------------
	 -- bronze.crm_sales_details
		SET @start_time = GETDATE();
		PRINT'>> Truncating Table: bronze.crm_sales_details';
		truncate table bronze.crm_sales_details; -- refreshing the table , so the data don't load twice 
	
		PRINT'>> inserting Data Into: bronze.crm_sales_details'	;
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\MSI\Downloads\SQL\YoutubeSQL_project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
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
		PRINT'>> Truncating Table: bronze.erp_CUST_AZ12';	
		truncate table bronze.erp_CUST_AZ12; -- refreshing the table , so the data don't load twice 
	
		PRINT'>> inserting Data Into: bronze.erp_CUST_AZ12';	
		BULK INSERT bronze.erp_CUST_AZ12
		FROM 'C:\Users\MSI\Downloads\SQL\YoutubeSQL_project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: '+  CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' Seconds';
		PRINT'>> -----------';

	----------------------------------
	--silver.erp_LOC_A101
		SET @start_time = GETDATE();
		PRINT'>> Truncating Table: bronze.erp_LOC_A101';
		truncate table bronze.erp_LOC_A101; -- refreshing the table , so the data don't load twice 
	
		PRINT'>> inserting Data Into: bronze.erp_LOC_A101';	
		BULK INSERT bronze.erp_LOC_A101
		FROM 'C:\Users\MSI\Downloads\SQL\YoutubeSQL_project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: '+  CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' Seconds';
		PRINT'>> -----------';
		
	----------------------------------
	-- silver.erp_PX_CAT_G1V2
		SET @start_time = GETDATE();		
		PRINT'>> Truncating Table: bronze.erp_PX_CAT_G1V2';
		truncate table bronze.erp_PX_CAT_G1V2; -- refreshing the table , so the data don't load twice 
	
		PRINT'>> inserting Data Into: bronze.erp_PX_CAT_G1V2';		
		BULK INSERT bronze.erp_PX_CAT_G1V2
		FROM 'C:\Users\MSI\Downloads\SQL\YoutubeSQL_project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
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
