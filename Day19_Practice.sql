--bài tập 1 
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE numeric USING (TRIM(ordernumber):: numeric)
  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN quantityordered TYPE numeric USING (TRIM(quantityordered):: numeric)
  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN priceeach TYPE numeric USING (TRIM(priceeach):: numeric)
  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderlinenumber TYPE numeric USING (TRIM(orderlinenumber):: numeric)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN sales TYPE float USING (TRIM(sales):: float)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date USING (TRIM(orderdate):: date)


