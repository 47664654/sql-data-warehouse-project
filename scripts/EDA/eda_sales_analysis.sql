/*
===============================================================================
 Script Name     : Exploratory Data Analysis – Gold Layer
 Purpose         : Performs advanced EDA on final analytical views in the 'gold' 
                   schema to extract actionable business insights.

 Description     : 
    This script covers multiple types of analyses using the star schema model 
    (fact_sales and dimensions) to uncover trends, anomalies, and performance 
    indicators. The key analyses included are:

        1. Change Over Time: Sales trends by month/year
        2. Cumulative Analysis: Running totals and moving averages
        3. Performance Analysis: Product sales vs average and previous periods
        4. Part-to-Whole: Category-level contribution to total sales
        5. Segmentation: Customer and product grouping based on behavior

    These queries help uncover hidden patterns in sales, customer behavior, 
    and product performance.

 Usage Notes     : 
    - Execute after views in the gold layer are created
    - All queries are read-only and non-destructive
    - Ideal for use in BI dashboards, data storytelling, or as a basis for 
      predictive modeling

 Parameters      : None

 Returns         : Insightful query result sets for data storytelling and 
                   business decisions

 Author          : Amine Bouraoui
 Created On      : 2025-07-29
 Last Modified   : -
===============================================================================
*/

-- === #1 change over time === --

-- sales peformance over time 
SELECT 
		DATETRUNC(MONTH,order_date) AS order_date,
		SUM(sales_amount) AS total_sales,
		COUNT(distinct customer_key) AS total_customers,
		SUM(quantity) AS total_quantity 
FROM gold.fact_sales
WHERE order_date is not null
GROUP BY DATETRUNC(MONTH,order_date)
ORDER BY DATETRUNC(MONTH,order_date)


-- OR 

SELECT 
		FORMAT(order_date,'yyyy-MMM') AS order_date, 
		SUM(sales_amount) AS total_sales,
		COUNT(DISTINCT customer_key) AS total_customers,
		SUM(quantity) AS total_quantity 
FROM gold.fact_sales
WHERE order_date is not null
GROUP BY FORMAT(order_date,'yyyy-MMM')
ORDER BY FORMAT(order_date,'yyyy-MMM')


-- === #2 Cumulative Analysis === --
SELECT 
		order_date,
		total_sales,
		SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
		AVG(avg_price) OVER (ORDER BY order_date) AS moving_avg_price
from 
(
	SELECT 
		DATETRUNC(YEAR,order_date) AS order_date,
		SUM(sales_amount) AS Total_sales,
		AVG(price) AS avg_price
	FROM gold.fact_sales
	WHERE order_date is not null
	GROUP BY DATETRUNC(YEAR,order_date)
)t
ORDER BY order_date


-- === #3 Performance Analysis === --
/*anaylze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */


;WITH yearly_product_sales AS 
(
SELECT 
	MONTH(f.order_date) AS order_date, 
	p.product_name,
	SUM(f.sales_amount) AS  current_sales 
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_product AS p
ON		f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY MONTH(f.order_date), p.product_name
) 
SELECT 
	order_date,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS Diff_avg,
	CASE
		WHEN current_sales - AVG(current_sales) OVER ( PARTITION BY product_name) > 0 THEN 'Above Avg'
		WHEN current_sales - AVG(current_sales) OVER ( PARTITION BY product_name) < 0 THEN 'Below Avg'
		ELSE 'Avg'
	END AS avg_change,
	LAG(current_sales) OVER (partition by product_name ORDER BY order_date) AS py_sales,
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name order by order_date) AS diff_sales,
	CASE
		WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name order by order_date) > 0 THEN 'Increase'
		WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name order by order_date) < 0 THEN 'Descrease'
		ELSE 'No Change'
	END AS sales_change	
FROM yearly_product_sales
ORDER BY product_name,order_date


-- === #4 part to whole analysis=== --
-- which category contribute to the most overall sales 


;WITH category_sales AS 
(
SELECT 
	category,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales       AS f
LEFT JOIN gold.dim_product AS p 
ON		f.product_key = p.product_key 
GROUP BY category
) 

SELECT 
	category,
	total_sales,
	SUM(total_sales) OVER () AS overall_sales,
	concat(Round((cast(total_sales AS FLOAT) / SUM(total_sales) OVER ())* 100,2),'%')  AS percentage_of_total
FROM category_sales
GROUP BY category,total_sales
ORDER BY total_sales DESC



-- === #5 data segmentation=== --

;WITH product_segments AS 
(
	SELECT 
		product_key,
		product_name,
		cost,
		CASE 
			WHEN cost < 100 THEN 'Below 100'
			WHEN cost between 100 and 500 THEN '100-500' 
			WHEN cost between 500 and 1000 THEN '500-1000'
			ELSE 'Above 1000'
		END AS cost_range 
	FROM gold.dim_product
) 
SELECT 
	cost_range, 
	count(*) AS total_products
FROM product_segments 
GROUP BY cost_range
ORDER BY total_products DESC


/* Group customers into three segments based on their spending behavior : 
	- VIP : at least 12 months of history but spending more than $5,000.
	- Regular : at least 12 months of history but spending $5,000 or less. 
	- New : lifespan less than 12 months.
And find total number of customers by each group 
*/ 

;WITH fact_table  AS 
(
SELECT  
	 c.customer_key,
	 SUM(f.sales_amount) AS total_spending,
	 max(f.order_date)   AS last_order ,
	 min(f.order_date)   AS first_order,
	 DATEDIFF(MONTH,MIN(order_date),MAX (f.order_date) ) AS lifespan
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON		f.customer_key = c.customer_key 
GROUP BY c.customer_key
),
behavior_table AS 
(
SELECT 
	lifespan,
	total_spending,
	CASE 
		WHEN total_spending >  5000 and lifespan >= 12  THEN 'VIP'
		WHEN total_spending <= 5000 and lifespan >= 12 THEN 'Regular'
		ELSE 'New'
	END AS spending_behavior 
FROM fact_table 
)
SELECT 
	spending_behavior,
	COUNT(*) AS total_nbr_customer,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2))AS pct_of_customers
FROM behavior_table 
GROUP BY spending_behavior
ORDER BY total_nbr_customer DESC
