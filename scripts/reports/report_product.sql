/*
/*
===============================================================================
 Script Name     : Product Report – Gold Layer
 Purpose         : Consolidates key product metrics for analytical reporting.

 Description     : 
    This view aggregates product-level insights and sales behaviors by:
        1. Extracting core product and transaction data from the Gold Layer
        2. Computing aggregated metrics per product:
            - Total sales, quantity sold, number of orders, unique customers
            - Product lifespan in months
        3. Calculating key KPIs:
            - Recency (months since last sale)
            - Average selling price
            - Average order revenue (AOR)
            - Average monthly revenue
        4. Segmenting products based on performance:
            - High-Performer, Mid-Range, Low-Performer classifications

 Usage Notes     : 
    - Run this script after the Gold Layer is fully loaded
    - Useful for dashboards, product performance analysis, and revenue insights

 Returns         : View: gold.report_products

 Author          : Amine Bouraoui
 Created On      : 2025-07-29
 Last Modified   : -
===============================================================================
*/

-- =============================================================================
-- Create Report View: gold.report_products
-- =============================================================================

IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS
WITH base_query AS (
    /* -------------------------------------------------------------------------
       Step 1: Extract core transactional and product attributes
    -------------------------------------------------------------------------- */
    SELECT
        f.order_number,
        f.product_key,
        f.customer_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        f.price,
        p.cost,
        p.product_name,
        p.category,
        p.subcategory
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_product AS p
        ON f.product_key = p.product_key
),
product_aggregation AS (
    /* -------------------------------------------------------------------------
       Step 2: Aggregate product-level metrics
    -------------------------------------------------------------------------- */
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity_sold,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        MAX(order_date) AS last_sale_date,
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
    FROM base_query
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

-- --------------------------------------------------------------------------
-- Step 3: Final Output – Enrich with segmentation and KPI calculations
-- --------------------------------------------------------------------------
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
    
    -- Segmenting products based on total sales performance
    CASE
        WHEN total_sales > 10000 THEN 'High-Performer'
        WHEN total_sales >= 5000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,
    
    lifespan,
    total_orders,
    total_sales,
    total_quantity_sold,
    total_customers,
    avg_selling_price,
    
    -- Average Order Revenue (AOR)
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE (total_sales / total_orders)
    END AS avg_order_revenue,
    
    -- Average Monthly Revenue
    CASE 
        WHEN lifespan = 0 THEN total_sales
        ELSE (total_sales / lifespan)
    END AS avg_monthly_revenue

FROM product_aggregation;
