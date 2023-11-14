

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
       
       
