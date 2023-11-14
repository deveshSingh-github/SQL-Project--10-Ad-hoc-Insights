
		 #####################    Request -2    #####################
                        
-- By using CTE and CASE statement       
/* Here we are providing the condition for fiscal year from inside by using CASE statement */     

WITH cte as (
		SELECT
			COUNT(DISTINCT CASE WHEN fiscal_year = 2020 THEN product_code END) AS unique_product_2020,
			COUNT(DISTINCT CASE WHEN fiscal_year = 2021 THEN product_code END) AS unique_product_2021 
		FROM fact_sales_monthly
		WHERE fiscal_year IN (2020, 2021)
	   )
SELECT unique_product_2020, unique_product_2021, 
       ROUND((unique_product_2021 - unique_product_2020)*100/unique_product_2020, 2) as percentage_chg
       FROM cte;


	
-- By using CTE (Common Table Expression)      
/* Here we are providing the condition for fiscal year from outside by using WHERE clause */

WITH cte as(
     SELECT fiscal_year, count(distinct product_code) as product_count
     FROM fact_sales_monthly
     GROUP BY fiscal_year
     )
SELECT 
    cte1.product_count as unique_product_2020,
    cte2.product_count as unique_product_2021,
    ROUND((cte2.product_count - cte1.product_count)*100/cte1.product_count, 2) as percentage_chg
FROM cte cte1
CROSS JOIN cte cte2 
WHERE cte1.fiscal_year = 2020 AND cte2.fiscal_year = 2021;
      
