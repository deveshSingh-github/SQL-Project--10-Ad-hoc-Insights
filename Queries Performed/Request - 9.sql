

                 
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
