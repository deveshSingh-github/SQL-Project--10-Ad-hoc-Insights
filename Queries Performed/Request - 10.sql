
                 
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
      
      
