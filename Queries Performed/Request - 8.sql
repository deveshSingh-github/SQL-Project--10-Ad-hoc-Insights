


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


