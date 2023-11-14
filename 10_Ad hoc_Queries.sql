/* This file will contains all the 10 Ad-Hoc Queries 
   which were performed to get the required result */
   
			#####################    Request -1   #####################
		
SELECT distinct market 
FROM dim_customer
WHERE customer = 'Atliq Exclusive' AND region = 'APAC';




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
      



			    #####################    Request -3    #####################
                    
SELECT 
      segment, count(product_code) as product_count
      FROM dim_product
      GROUP BY segment
      ORDER BY product_count DESC;
      
      
      
      
                             #####################    Request -4    #####################
      
WITH cte as(
		SELECT 
                dp.segment,
				count(distinct CASE WHEN fiscal_year=2020 THEN fs.product_code END) as product_count_2020,
				count(distinct CASE WHEN fiscal_year=2021 THEN fs.product_code END) as product_count_2021
			 FROM fact_sales_monthly fs
			 JOIN dim_product dp
			 USING(product_code)
			 WHERE fiscal_year IN (2020, 2021)
			 GROUP BY dp.segment
     )
     
SELECT segment, product_count_2020,  product_count_2021,
	   (product_count_2021 -  product_count_2020) as difference
       FROM cte;
       
       
							
                            
			    #####################    Request -5    #####################
     
SELECT 
     fc.product_code, dp.product, manufacturing_cost
     FROM fact_manufacturing_cost fc
     JOIN dim_product dp
     USING (product_code)
     WHERE manufacturing_cost IN 
		   (SELECT max(manufacturing_cost) FROM fact_manufacturing_cost
		      UNION
		    SELECT min(manufacturing_cost) FROM fact_manufacturing_cost);     
       
       
       
       
                         #####################    Request -6   #####################

SELECT 
     pid.customer_code, dc.customer, 
     ROUND(AVG(pid.pre_invoice_discount_pct), 4) as average_discount_percentage
     FROM fact_pre_invoice_deductions pid
     JOIN dim_customer dc
     USING (customer_code)
     WHERE dc.market="India" AND pid.fiscal_year= 2021
     GROUP BY dc.customer,pid.customer_code
     ORDER BY average_discount_percentage DESC
     LIMIT 5;       
      
      

      
			#####################    Request -7   #####################
     
SELECT 
		 CONCAT(MONTHNAME(fs.date),' ',YEAR(fs.date) ) as month, 
		 fs.fiscal_year, 
		 ROUND(SUM(fg.gross_price*fs.sold_quantity), 2) as gross_sales_amount
	FROM fact_sales_monthly fs
	JOIN dim_customer dc USING(customer_code)
	JOIN fact_gross_price fg USING(product_code, fiscal_year)
	WHERE dc.customer= 'Atliq Exclusive'
	GROUP BY month, fs.fiscal_year
	ORDER BY fs.fiscal_year;
		        
      
      
      
			#####################    Request -8   #####################
                  
SELECT 
     CASE
        WHEN MONTH(date) IN (9,10,11) THEN 'Q1'
        WHEN MONTH(date) IN (12,1,2) THEN 'Q2'
        WHEN MONTH(date) IN (3,4,5) THEN 'Q3'
        ELSE 4
        END as quaters, 
       ROUND(SUM(sold_quantity/1000000), 2) as total_sold_quantity_mln
     FROM fact_sales_monthly
     WHERE fiscal_year = 2020
    GROUP BY quaters;                  
                  
                  
                  
                  
                   #####################    Request -9   #####################
                   
WITH cte as(
		SELECT 
			 dc.channel, 
			 ROUND(SUM(fg.gross_price*fs.sold_quantity)/1000000, 2) as gross_sales_mln
		FROM fact_sales_monthly fs
		JOIN dim_customer dc USING(customer_code)
		JOIN fact_gross_price fg USING(product_code, fiscal_year)
		WHERE fs.fiscal_year = 2021
		GROUP BY dc.channel
        )
SELECT *, 
       CONCAT(ROUND(gross_sales_mln*100/(SUM(gross_sales_mln) OVER()), 2), ' %') as percentage
       FROM cte;                   
                   
                   
                   
                   
                    #####################    Request -10   #####################
      
WITH cte1 as(
		SELECT 
			 dp.division, dp.product_code, dp.product,
			 SUM(fs.sold_quantity) as total_sold_quantity
		FROM fact_sales_monthly fs
		JOIN dim_product dp USING(product_code)
		WHERE fs.fiscal_year = 2021
        GROUP BY dp.product_code, dp.product, dp.division		
        ),
cte2 as(  
		 SELECT *,
			ROW_NUMBER() 
			OVER(partition by division ORDER BY total_sold_quantity DESC) as rank_order 
		 FROM cte1
	   )

SELECT * from cte2 where rank_order <= 3;
      
      
      
      
