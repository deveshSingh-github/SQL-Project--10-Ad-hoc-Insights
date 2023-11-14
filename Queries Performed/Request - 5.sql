

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
       
