

   
       
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
      
