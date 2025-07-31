/*
===============================================================================
 Script Name     : Customer Report – Gold Layer
 Purpose         : Consolidates key customer metrics for analytical reporting.

 Description     : 
    This view aggregates customer behavior and performance insights by:
        1. Retrieving core transaction and customer data
        2. Calculating aggregated metrics at the customer level:
            - Total orders, sales, quantity, product variety
            - Lifespan of customer (months between first and last order)
        3. Deriving KPIs:
            - Recency (months since last order)
            - Average order value
            - Average monthly spend
        4. Enriching customers with segmentation:
            - Age group classification
            - Customer type (VIP, Regular, New)

 Usage Notes     : 
    - Execute after the Gold Layer is populated
    - Ideal for dashboards, CRM analytics, and customer lifecycle modeling

 Returns         : View: gold.report_customers

 Author          : Amine Bouraoui
 Created On      : 2025-07-29
 Last Modified   : -
===============================================================================
*/

-- =============================================================================
-- Drop view if it exists
-- =============================================================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

-- =============================================================================
-- Create View: gold.report_customers
-- =============================================================================
CREATE VIEW gold.report_customers AS

WITH base_query AS (
    /* 
    -----------------------------------------------------
    Step 1: Retrieve core fields from fact and dimension tables
    -----------------------------------------------------
    */
    SELECT 
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_customers AS c ON f.customer_key = c.customer_key
    WHERE f.order_date IS NOT NULL
),

customer_aggregation AS (
    /*
    -----------------------------------------------------
    Step 2: Aggregate metrics at the customer level
    -----------------------------------------------------
    */
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number)      AS total_orders,
        SUM(sales_amount)                 AS total_sales,
        SUM(quantity)                     AS total_quantity,
        COUNT(DISTINCT product_key)       AS total_products,
        MAX(order_date)                   AS last_order,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
    FROM base_query
    GROUP BY 
        customer_key,
        customer_number,
        customer_name,
        age
)

-- =============================================================================
-- Final Select: KPIs, Segments, and Output
-- =============================================================================
SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,

    -- Age Group Classification
    CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END AS age_group,

    -- Customer Segment Classification
    CASE 
        WHEN total_sales > 5000 AND lifespan >= 12 THEN 'VIP'
        WHEN total_sales <= 5000 AND lifespan >= 12 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,

    -- KPIs
    DATEDIFF(MONTH, last_order, GETDATE()) AS recency,
    total_orders,
    total_sales,
    total_quantity,
    last_order,
    lifespan,

    -- Average Order Value
    CASE 
        WHEN total_orders = 0 THEN 0 
        ELSE (total_sales * 1.0 / total_orders)
    END AS avg_order_value,

    -- Average Monthly Spend
    CASE 
        WHEN total_orders = 0 THEN 0 
        WHEN lifespan = 0 THEN total_sales 
        ELSE (total_sales * 1.0 / lifespan)
    END AS avg_monthly_spend

FROM customer_aggregation;
