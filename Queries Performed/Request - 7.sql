


      
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


